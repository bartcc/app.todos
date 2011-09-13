jQuery(function($){
  
  window.Main = Spine.Controller.create({
    
    events: {
      'sortupdate .items'           : 'sortupdate',
      'click footer .clear'         : 'clear',
      'keypress #create-todo input' : 'create',
      'keyup #new-todo'             : 'showTooltip'
    },
    
    elements: {
      "footer .clear"           : 'clear',
      '.items'                  : 'items',
      '#create-todo input'      : 'input',
      '#create-todo .countVal'  : 'count',
      '#stats'                  : 'stats'
    },
    
    statsTemplate: $.template(null, $('#stats-template').html()),
    
    init: function(){
      Task.bind('create',  this.proxy(this.addOne));
      Task.bind('refresh change',  this.proxy(this.updateUnsaved));
      Task.bind('refresh change', this.proxy(this.renderCount));
      Task.bind('refresh change', this.proxy(this.renderStats));
      Task.bind('refresh', this.proxy(this.addAll));
      Task.bind('refresh:list', this.proxy(this.refreshList));
      this.items.sortable();
    },
    
    refreshList: function() {
      // disable refresh button
      Spine.App.trigger('render:refreshState', true);
      Spine.Ajax.enabled = false;
      Task.destroyAll();
      Spine.Ajax.enabled = true;
      Task.fetch();
    },

    sortupdate: function(e, ui) {
      var task;
      this.items.children('li').each(function(index) {
        task = Task.find($(this).attr('id').replace("todo-", ""));
        if(task && task.order != index) {
          task.order = index;
          task.save();
        }
      });
    },
    
    create: function(e){
      if (e.keyCode != 13) return;
      Task.create(this.newAttributes());
      this.input.val("");
      return false;
    },

    newAttributes: function() {
      var attr = {};
      _.extend(attr, Task.defaults, {
        name: this.input.val() || undefined,
        order: Task.nextOrder()
      })
      return attr;
    },
    
    addOne: function(task) {
      var view = Tasks.init({
        item: task
      });
      var el = view.render().el;
      this.items.append(el);
    },

    addAll: function() {
      Task.each(this.proxy(this.addOne));
      Spine.App.trigger('render:refreshState', false);
    },
    
    renderCount: function(){
      var active = Task.active().length, s;
      this.count.text(active + ' item' + (s = active !== 1 ? 's' : '') + ' left');
    },
    
    renderStats: function(){
      var active = Task.active().length, s;
      this.stats.html($.tmpl(this.statsTemplate, {
        done: Task.done().length
      }))
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
    
  
});