var Sidebar;
var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
Sidebar = (function() {
  __extends(Sidebar, Spine.Controller);
  Sidebar.prototype.events = {
    'click #button-checkall button': 'markAllDone',
    'click #button-uncheckall button': 'markAllUndone',
    'click #todo-controls #button-refresh button': 'refreshList',
    'click #todo-controls #button-unsaved button': 'saveUnsaved'
  };
  Sidebar.prototype.buttonCheckallTemplate = function() {
    return $.template(null, $('#button-checkall-template').html());
  };
  Sidebar.prototype.buttonUncheckallTemplate = function() {
    return $.template(null, $('#button-uncheckall-template').html());
  };
  Sidebar.prototype.buttonUnsavedTemplate = function() {
    return $.template(null, $('#button-unsaved-template').html());
  };
  Sidebar.prototype.buttonRefreshTemplate = function() {
    return $.template(null, $('#button-refresh-template').html());
  };
  function Sidebar() {
    Sidebar.__super__.constructor.apply(this, arguments);
    Spine.App.bind('render:refreshState', this.proxy(this.renderRefreshState));
    Task.bind('refresh change', this.proxy(this.renderControls));
    Task.bind('change:unsaved', this.proxy(this.renderSaveState));
  }
  Sidebar.prototype.refreshList = function() {
    return Task.trigger('refresh:list');
  };
  Sidebar.prototype.saveToLocal = function(xhr) {};
  Sidebar.prototype.markAllDone = function(ev) {
    Spine.Ajax.enabled = false;
    Task.each(function(task) {
      if (!task.done) {
        task.done = true;
        task.save();
        return Task.trigger('change:unsaved', task);
      }
    });
    return Spine.Ajax.enabled = true;
  };
  Sidebar.prototype.markAllUndone = function(ev) {
    Spine.Ajax.enabled = false;
    Task.each(function(task) {
      if (task.done) {
        task.done = false;
        task.save();
        return Task.trigger('change:unsaved', task);
      }
    });
    return Spine.Ajax.enabled = true;
  };
  Sidebar.prototype.renderControls = function() {
    $('#todo-controls #button-checkall').html($.tmpl(this.buttonCheckallTemplate(), {
      value: 'Mark all Done',
      remaining: Task.active().length
    }));
    return $('#todo-controls #button-uncheckall').html($.tmpl(this.buttonUncheckallTemplate(), {
      value: 'Mark all Undone',
      done: Task.done().length
    }));
  };
  Sidebar.prototype.renderRefreshState = function(isBusy) {
    return $('#todo-controls #button-refresh').html($.tmpl(this.buttonRefreshTemplate(), {
      value: 'Refresh',
      busy: isBusy
    }));
  };
  Sidebar.prototype.renderSaveState = function() {
    var unsaved, value;
    unsaved = Task.filterUnsaved();
    value = function() {
      var val;
      switch (unsaved.length) {
        case 0:
          val = 'Server is up to date';
          break;
        case 1:
          val = 'Save ' + unsaved.length + ' local change';
          break;
        default:
          val = 'Save ' + unsaved.length + ' local changes';
      }
      return val;
    };
    return $('#todo-controls #button-unsaved').html($.tmpl(this.buttonUnsavedTemplate(), {
      value: value(),
      unsaved: unsaved.length
    }));
  };
  Sidebar.prototype.saveUnsaved = function() {
    return UnsavedTask.save();
  };
  return Sidebar;
})();