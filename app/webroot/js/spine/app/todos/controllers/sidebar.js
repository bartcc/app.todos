jQuery(function($) {
  
  window.Sidebar = Spine.Controller.create({

    proxied: ['addOne', 'addAll', 'renderCount', 'renderControls', 'renderRefreshState', 'renderSaveState', 'refreshList'],

    events: {
      'keypress #create-todo input'                   :'create',
      'click footer .clear'                           :'clear',
      'click #button-checkall button'                 :'markAllDone',
      'click #button-uncheckall button'               :'markAllUndone',
      'click #todo-controls #button-refresh button'   :'refreshList',
      'click #todo-controls #button-unsaved button'   :'saveUnsaved',
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
      Task.bind('create change refresh',  this.proxy(this.updateUnsaved));
      Task.bind('create',  this.proxy(this.addOne));
      Task.bind('refresh', this.proxy(this.addAll));
      Task.bind('refresh change', this.proxy(this.renderControls));
      Task.bind('change:unsaved', this.proxy(this.renderSaveState));
      Task.bind('refresh:list', this.proxy(this.refreshList));
      this.items.sortable();
      this.renderSaveState();
    },

    refreshList: function() {
      // disable refresh button
      this.renderRefreshState(true);
      Task.fetch();
    },

    saveToLocal: function(xhr) {},

    markAllDone: function(ev) {
      Spine.Ajax.enabled = false;
      Task.each(function(task) {
        if(!task.done) {
          task.done = true;
          task.save();
          Task.trigger('change:unsaved', task);
        }
      })
      Spine.Ajax.enabled = true;
    },

    markAllUndone: function(ev) {
      Spine.Ajax.enabled = false;
      Task.each(function(task) {
        if(task.done) {
          task.done = false;
          task.save();
          Task.trigger('change:unsaved', task);
        }
      })
      Spine.Ajax.enabled = true;
    },

    renderCount: function(){
      var active = Task.active().length;
      this.count.text(active);

      var inactive = Task.done().length;
      this.clear[inactive ? "show" : "hide"]();
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
      this.items.append(el);
    },

    addAll: function() {
      this.items.empty();
      Task.each(this.proxy(this.addOne));
      this.renderRefreshState(false);
    },

    updateUnsaved: function(task) {
      if(!Spine.Ajax.enabled) return;
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

}) 
