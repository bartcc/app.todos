App.NS('Collections').UnsavedTodos = (function() {
  
  var UnsavedList = Backbone.Collection.extend({

    model: App.Models.UnsavedTodo,

    initialize: function() {
      _.bindAll(this, 'removeUnsaved');
      this.bind('remove:unsaved', this.removeUnsaved);
    },

    addUnsaved: function(saved) {
      // prevent from duplicated items
      if(!this.detect(function(unsaved) {
        return unsaved.get('id') === saved.get('id');
      })) this.add(_.clone(saved));
    },

    removeUnsaved: function(idOrModel) {
      var model = this.get(idOrModel);
      if(model) this.remove(model);
    },

    // save each todo who's id is in the list
    save: function() {
      this.each(function(unsaved) {
        var saved = App.Collections.Todos.find(function(saved) {
          return saved.get('id') == unsaved.get('id');
        })
        if(saved) {
          App.Collections.Todos.flag(unsaved.get('id'));
          saved.save();
        }
      })
      App.Collections.Todos.unflag();
      App.Collections.Todos.trigger('change:unsaved');
    }
  },
  {
  // Class properties
  });

  return new UnsavedList;
  
})()

