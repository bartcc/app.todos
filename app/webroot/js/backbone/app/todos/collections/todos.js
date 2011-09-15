exports.NS('Todos.Collections').Todos = (function() {
  
  var TodosList = Backbone.Collection.extend({

    // Reference to this collection's model.
    model: Todos.Models.Todo,

    defaultMode: 'server',

    persistModes: {
      local: 'local', 
      server: 'server'
    },
    
    setStorageMode: function(mode) {
      for(var key in this.persistModes) {
        if(mode === this.persistModes[key]) {
          this.storageMode = mode;
          return this.storageMode;
        }
      }
    },
    
    toggleStorageMode: function(mode) {
      
      var mapMode = {
        'local':    {
          button      : 'Switch to server mode', 
          statustext  : 'local mode',
          mode        : 'local'
        },
        'server':   {
          button      : 'Switch to local mode', 
          statustext  : 'server mode',
          mode        : 'server'
        }
      },
      
      local = this.persistModes.local,
      server = this.persistModes.server,
      
      useMode = _.bind(function() {
        switch (mode){
          case local:
            Backbone.sync = Backbone.localSync;
            _.extend(this, {
              // Save all of the todo items under the `"todos"` namespace.
              localStorage: new Store("todos")
            })
            break;

          case server:
            delete this.localStorage;
            Backbone.sync = Backbone.serverSync;
            break;
        }
        
        Todos.Collections.UnsavedTodos.reset();
        
        this.setStorageMode(mode);
//        this.trigger('refresh:list', mode);
      }, this)
      var mode = mode ? mode : this.storageMode ? this.storageMode == local ? server : local : this.defaultMode;
      useMode();
      return mapMode[mode];
    },

    url: function() {
      return base_url + 'todos/'
    },

    initialize: function() {
      _.bindAll(this, 'toggleStorageMode');
      this.storageMode = undefined;
    },

    parse: function(data) {
      return data.json || data;
    },

    // Filter down the list of all todo items that are finished.
    done: function() {
      return this.filter(function(todo){
        return todo.get('done');
      });
    },

    // Filter down the list to only todo items that are still not finished.
    remaining: function() {
      return this.without.apply(this, this.done());
    },

    // multi purpose method
    // returns all models not passing the condition and when found put it in the list
    filterUnsaved: function() {
      return this.filter(function(todo) {
        var isEqual = _.isEqual(todo.savedAttributes, todo.attributes);
        if(!todo.isScheduledForSave) {
          !isEqual ? Todos.Collections.UnsavedTodos.addUnsaved(todo) : Todos.Collections.UnsavedTodos.removeUnsaved(todo);
        }
        return !isEqual;
      })
    },

    flag: function(id) {
      var saved = Todos.Collections.Todos.get(id);
      if(saved) saved.isScheduledForSave = true;
    },

    unflag: function(id) {
      if(id) {
        var saved = Todos.Collections.Todos.get(id);
        if(saved) saved.isScheduledForSave = false;
      } else {
        Todos.Collections.UnsavedTodos.each(function(unsaved) {
          var saved = Todos.Collections.Todos.get(unsaved.get('id'));
          if(saved) saved.isScheduledForSave = false;
        })
      }
    },

    // We keep the Todos in sequential order, despite being saved by unordered
    // GUID in the database. This generates the next order number for new items.
    nextOrder: function() {
      if (!this.length) return 1;
      return parseInt(this.last().get('order')) + 1;
    },

    // Todos are sorted by their original insertion order.
    comparator: function(todo) {
      return todo.get('order');
    },
    
    empty: function() {
      this.reset();
    }

  },
  {
    //Class
  });

  return new TodosList;
  
})()

