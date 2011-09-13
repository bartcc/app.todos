// Create the Task model.
var Task = Spine.Model.setup("Task", "name", "done", 'order');

var UnsavedTask = Spine.Model.setup("UnsavedTask", "name", "done", 'order');

UnsavedTask.extend({
  
  addUnsaved: function(saved) {
    if(!this.exists(saved.id)) {
      this.create(saved.clone().attributes());
    }
  },
    
  removeUnsaved: function(saved) {
    if(this.exists(saved.id)) {
      this.destroy(saved.id);
    }
  },
    
  // save each todo who's id is in the list
  save: function() {
    this.each(function(unsaved) {
      if(Task.exists(unsaved.id)) {
        var saved = Task.find(unsaved.id);
        saved.save();
        Task.trigger('change:unsaved');
      }
    })
  }
})

// Persist model between page reloads.
Task.extend(Spine.Model.Ajax);

Task.extend({
    
  defaults: {
    name: 'Empty Todo...',
    done: false
  },
  
  fromJSON: function(object) {
	return this.__super__.constructor.fromJSON.call (this, object.json)
  },
  
  // Return all active tasks.
  active: function(){
    return(this.select(function(item){
      return !item.done;
    }));
  },
  
  // Return all done tasks.
  done: function(){
    return(this.select(function(item){
      return !!item.done;
    }));    
  },
  
  url: function() {
    return '' + base_url + (this.className.toLowerCase()) + 's';
  },
  
  // Clear all done tasks.
  destroyDone: function(){
    jQuery(this.done()).each(function(i, rec){
      rec.remove();
    });
  },
    
  nextOrder: function() {
    var next = this.last() ? (parseInt(this.last().order) + 1) : 0;
    return next;
  },
    
  filterUnsaved: function() {
    return this.select(function(task) {
      var isEqual = _.isEqual(task.savedAttributes, task.attributes());
      if(!task.isScheduledForSave) {
        !isEqual ? UnsavedTask.addUnsaved(task) : UnsavedTask.removeUnsaved(task);
      }
      return !isEqual;
    })
  },
  
  comparator: function() {
    this.each(function(rec) {
      console.log(rec.order)
      return rec.order;
      
    })
  },
  
  saveModelState: function(id) {
    if(!this.exists(id)) return;
    var model = this.find(id);
    var saved = model.constructor.records[id].savedAttributes = model.attributes();
    Task.trigger('change:unsaved');
    return saved;
  }
    
});

Task.include({
  initialize: function() {
    
  },
    
  remove: function() {
    this.destroy();
    Task.trigger('change:unsaved', this);
  }
})