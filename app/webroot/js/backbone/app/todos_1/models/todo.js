exports.NS('Todos.Models').Todo = (function() {
    
  // Todo Model
  // ----------

  // Our basic **Todo** model has `content`, `order`, and `done` attributes.
  var Todo = Backbone.Model.extend({

    // If you don't provide a todo, one will be provided for you.
    defaults: {
      content : 'Empty todo...',
      done    : false
    },

    // Ensure that each todo created has `content`.
    initialize: function() {
      _.bindAll(this, 'defaults')
      //            if (!this.get("content")) {
      //                this.set({"content": this.EMPTY});
      //            }

      this.isScheduledForSave = false;
      // create a savedAttributes property for all models
      this.saveModelState();
    },

    // Toggle the `done` state of this todo item.
    toggle: function() {
      this.save({
        done: !this.get("done")
      });
    },

    // override save to keep a copy of model's attributes in savedAttributes
    save: function(attrs, opts) {
      var that = this;
      var options = {
        success: function(model, response) {
          that.saveModelState();
          Todos.Views.App.Sidebar.trigger('change:unsaved');
        }
      }
      options = _.extend(options, opts);
      Backbone.Model.prototype.save.call(this, attrs, options);
    },

    // keep a copy of server versions' state in the model
    saveModelState: function() {
      this.savedAttributes = _.clone(this.attributes);
      this.change();
    },

    setDone: function() {
      if(!this.get('done')) this.save({
        done: true
      });
    },

    // Remove this Todo from *localStorage* and delete its view.
    clear: function() {
      
      var that = this;
      this.destroy({
        success: function() {
          // remove from UnsavedList
          Todos.Collections.UnsavedTodos.removeUnsaved(that.get('id'));
          // remove from view
          that.view.remove();
          // update unsaved count
          Todos.Views.App.Sidebar.trigger('change:unsaved');
        }
      });
    },

    parse: function(data) {
      return data.attributes || data;
    }
  },
  {
    //Class
  });
  
  return Todo;
})()