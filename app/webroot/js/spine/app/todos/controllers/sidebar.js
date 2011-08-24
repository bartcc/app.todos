jQuery(function($) {
  
  window.Sidebar = Spine.Controller.create({

    proxied: ['addOne', 'addAll', 'renderCount', 'renderControls', 'renderRefreshState', 'renderSaveState', 'refreshList'],

    events: {
      'click #button-checkall button'                 :'markAllDone',
      'click #button-uncheckall button'               :'markAllUndone',
      'click #todo-controls #button-refresh button'   :'refreshList',
      'click #todo-controls #button-unsaved button'   :'saveUnsaved',
    },

    elements: {
      "#create-todo input"      :"input"
    },

    buttonCheckallTemplate:     $.template(null, $('#button-checkall-template').html()),
    buttonUncheckallTemplate:   $.template(null, $('#button-uncheckall-template').html()),
    buttonUnsavedTemplate:      $.template(null, $('#button-unsaved-template').html()),
    buttonRefreshTemplate:      $.template(null, $('#button-refresh-template').html()),

    init: function(){
      
      Spine.App.bind('render:refreshState', this.proxy(this.renderRefreshState));
      Task.bind('refresh change', this.proxy(this.renderControls));
      Task.bind('change:unsaved', this.proxy(this.renderSaveState));
      
      //this.renderSaveState();
    },
    
    refreshList: function() {
      Task.trigger('refresh:list');
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

    renderControls: function() {
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

    saveUnsaved: function() {
      UnsavedTask.save();
    }

  });

}) 
