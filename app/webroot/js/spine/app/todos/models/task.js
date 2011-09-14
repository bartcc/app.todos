var Task, UnsavedTask;
var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
Task = (function() {
  __extends(Task, Spine.Model);
  function Task() {
    Task.__super__.constructor.apply(this, arguments);
  }
  Task.configure("Task", "name", "done", 'order');
  Task.extend(Spine.Model.Ajax);
  Task.defaults = {
    name: 'Empty Todo...',
    done: false
  };
  Task.fromJSON = function(object) {
    return this.__super__.constructor.fromJSON.call(this, object.json);
  };
  Task.active = function() {
    return this.select(function(item) {
      return !item.done;
    });
  };
  Task.done = function() {
    return this.select(function(item) {
      return !!item.done;
    });
  };
  Task.url = function() {
    return '' + base_url + (this.className.toLowerCase()) + 's';
  };
  Task.destroyDone = function() {
    return $(this.done()).each(function(i, rec) {
      return rec.remove();
    });
  };
  Task.nextOrder = function() {
    if (this.last()) {
      return parseInt(this.last().order) + 1;
    } else {
      return 0;
    }
  };
  Task.filterUnsaved = function() {
    return this.select(function(task) {
      var isEqual;
      isEqual = _.isEqual(task.savedAttributes, task.attributes());
      if (!task.isScheduledForSave) {
        if (!isEqual) {
          UnsavedTask.addUnsaved(task);
        } else {
          UnsavedTask.removeUnsaved(task);
        }
      }
      return !isEqual;
    });
  };
  Task.comparator = function() {
    return this.each(function(rec) {
      return rec.order;
    });
  };
  Task.saveModelState = function(id) {
    var model, saved;
    if (!this.exists(id)) {
      return;
    }
    model = this.find(id);
    saved = model.constructor.records[id].savedAttributes = model.attributes();
    Task.trigger('change:unsaved');
    return saved;
  };
  Task.prototype.init = function() {};
  Task.prototype.remove = function() {
    this.destroy();
    return Task.trigger('change:unsaved', this);
  };
  return Task;
})();
UnsavedTask = (function() {
  __extends(UnsavedTask, Spine.Model);
  function UnsavedTask() {
    UnsavedTask.__super__.constructor.apply(this, arguments);
  }
  UnsavedTask.configure("UnsavedTask", "name", "done", 'order');
  UnsavedTask.addUnsaved = function(saved) {
    if (!this.exists(saved.id)) {
      return this.create(saved.clone().attributes());
    }
  };
  UnsavedTask.removeUnsaved = function(saved) {
    if (this.exists(saved.id)) {
      return this.destroy(saved.id);
    }
  };
  UnsavedTask.save = function() {
    return this.each(function(unsaved) {
      var saved;
      if (Task.exists(unsaved.id)) {
        saved = Task.find(unsaved.id);
        saved.save();
        return Task.trigger('change:unsaved');
      }
    });
  };
  return UnsavedTask;
})();