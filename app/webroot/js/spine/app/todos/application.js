jQuery(function($){
  
  window.Tasks = Spine.Controller.create({
    tag: "li",
    
    proxied: ["render", "remove"],
    
    events: {
      "change   input[type=checkbox]" :"toggle",
      "click    .destroy"             :"destroy",
      "dblclick .view"                :"edit",
      "keypress input[type=text]"     :"blurOnEnter",
      "blur     input[type=text]"     :"close"
    },
    
    elements: {
      "input[type=text]"              :"input",
      ".item"                         :"wrapper"
    },
        
    init: function(){
      this.item.bind("update",  this.render);
      this.item.bind("destroy", this.remove);
    },
        
    render: function(){
      this.item.reload();
      var isEqual = _.isEqual(this.item.savedAttributes, this.item.attributes());
      var element = $("#taskTemplate").tmpl(this.item);
      this.el.html(element).toggleClass('unsaved', !isEqual);
      this.el.prop('id', 'todo-'+this.item.id).addClass('hover');
      this.refreshElements();
      return this;
    },
    
    toggle: function(){
      this.item.done = !this.item.done;
      this.item.save();
    },
        
    destroy: function(){
      this.item.remove();
    },
    
    edit: function(){
      this.wrapper.addClass("editing");
      this.input.focus();
    },
        
    blurOnEnter: function(e) {
      if (e.keyCode == 13) e.target.blur();
    },
        
    close: function(){
      //this.wrapper.removeClass("editing");
      this.item.updateAttributes({
        name: this.input.val()
      });
    },
        
    remove: function(){
      this.el.remove();
    }
  });
  
  var sortableTodos = $('.items').sortable();
    
  window.TaskApp = Spine.Controller.create({
    el: $("#tasks"),
    
    proxied: ['addOne', 'addAll', 'renderCount', 'renderControls', 'renderSaveState', 'refreshList'],

    events: {
      'keypress #create-todo input'                   :'create',
      'click footer .clear'                           :'clear',
      'click #button-checkall button'                 :'markAllDone',
      'click #button-uncheckall button'               :'markAllUndone',
      'click #todo-controls #button-refresh button'   :'refreshList',
      'click #todo-controls #button-unsaved button'   :'saveUnsaved',
      'sortupdate .items'                             :'sortupdate',
      'keyup #new-todo'                               :'showTooltip'
    },

    elements: {
      ".items"                  :"items",
      "#create-todo .countVal"  :"count",
      "footer .clear"           :"clear",
      "#create-todo input"      :"input"
    },
        
    buttonCheckallTemplate:     $.template(null, $('#button-checkall-template').html()),
    buttonUncheckallTemplate:   $.template(null, $('#button-uncheckall-template').html()),
    buttonUnsavedTemplate:      $.template(null, $('#button-unsaved-template').html()),
    buttonRefreshTemplate:      $.template(null, $('#button-refresh-template').html()),
        
    init: function(){
      Task.bind('create change refresh',  this.updateUnsaved);
      Task.bind('create',  this.addOne);
      Task.bind('refresh', this.addAll);
      Task.bind('refresh change', this.renderControls);
      Task.bind('ajaxSuccess', this.saveToLocal);
      Task.bind('change:unsaved', this.renderSaveState);
      Task.bind('refresh:list', this.refreshList);
      this.renderSaveState();
      this.refreshList();
    },
        
    refreshList: function() {
      // disable refresh button
      this.renderRefreshState(true);
      Task.fetch();
    },
        
    sortupdate: function(e, ui) {
      var task;
      $(sortableTodos).children('li').each(function(index) {
        task = Task.find($(this).attr('id').replace("todo-", ""));
        if(task && task.order != index) {
          task.order = index;
          task.save();
        }
      });
    },
        
    fetch: function(o) {
      Task.trigger("fetch", o);
    },
        
    saveToLocal: function(xhr) {},
        
    markAllDone: function(ev) {
      Task.ajax.enabled = false;
      Task.each(function(task) {
        if(!task.done) {
          task.done = true;
          task.save();
          Task.trigger('change:unsaved', task);
        }
      })
      Task.ajax.enabled = true;
    },
        
    markAllUndone: function(ev) {
      console.log(Task)
      Task.ajax.enabled = false;
      Task.each(function(task) {
        if(task.done) {
          task.done = false;
          task.save();
          Task.trigger('change:unsaved', task);
        }
      })
      Task.ajax.enabled = true;
    },
    
    renderCount: function(){
      var active = Task.active().length;
      this.count.text(active);
      
      var inactive = Task.done().length;
      this.clear[inactive ? "show" : "hide"]();
      console.log(inactive)
    },
        
    renderControls: function() {
      this.renderCount();
      $('#todo-controls #button-checkall').html($.tmpl(this.buttonCheckallTemplate, {
        value:      'Mark all Done',
        remaining:  Task.active().length
      }));
      $('#todo-controls #button-uncheckall').html($.tmpl(this.buttonUncheckallTemplate, {
        value:      'Mark all Undone',
        done:       Task.done().length
      }));
    },
        
    renderRefreshState: function(isBusy) {
      $('#todo-controls #button-refresh').html($.tmpl(this.buttonRefreshTemplate, {
        value:      'Refresh',
        busy:       isBusy
      }));
    },
        
    renderSaveState: function() {
      var unsaved = Task.filterUnsaved();
      var value = function() {
        var val = '';
        switch (unsaved.length) {
          case 0:
            val = 'Server is up to date';
            break;
          case 1:
            val = 'Save ' + unsaved.length + ' local change';
            break;
          default:
            val = 'Save ' + unsaved.length + ' local changes'
        }
        return val;
      }
      $('#todo-controls #button-unsaved').html($.tmpl(this.buttonUnsavedTemplate, {
        value:      value(),
        unsaved:    unsaved.length
      }));
    },
        
    addOne: function(task) {
      var view = Tasks.init({
        item: task
      });
      var el = view.render().el;
      if($('#'+$(el).attr('id')).replaceWith($(el)).length) return;
      $(this.items).append(view.render().el);
    },

    addAll: function() {
      Task.each(this.addOne);
      this.renderRefreshState(false);
    },
        
    updateUnsaved: function(task) {
      if(!Task.ajax.enabled) return;
      if(task && task.id) {
        Task.saveModelState(task.id);
      } else {
        Task.each(function(model) {
          Task.saveModelState(model.id);
        })
      }
    },
        
    saveUnsaved: function() {
      UnsavedTask.save();
    },
        
    newAttributes: function() {
      var attr = {};
      _.extend(attr, Task.defaults, {
        name: this.input.val() || undefined,
        order: Task.nextOrder()
      })
      return attr;
    },
        
    create: function(e){
      if (e.keyCode != 13) return;
      var task = Task.create(this.newAttributes());
      this.input.val("");
      return false;
    },
    
    clear: function(){
      Task.destroyDone();
      Task.trigger('change:unsaved');
    },
        
    // Lazily show the tooltip that tells you to press `enter` to save
    // a new todo item, after one second.
    showTooltip: function(e) {
      var tooltip = this.$(".ui-tooltip-top");
      var val = this.input.val();
      tooltip.fadeOut();
      if (this.tooltipTimeout) clearTimeout(this.tooltipTimeout);
      if (val == '' || val == this.input.attr('placeholder')) return;
      var show = function(){
        tooltip.show().fadeIn();
      };
      this.tooltipTimeout = _.delay(show, 1000);
    }
  });
  
  window.App = TaskApp.init();
});