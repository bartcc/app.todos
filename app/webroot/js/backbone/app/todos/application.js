// An example Backbone application contributed by
// [JÃ©rÃ´me Gravel-Niquet](http://jgn.me/). This demo uses a simple
// [LocalStorage adapter](backbone-localstorage.html)
// to persist Backbone models within your browser.

// Load the application once the DOM is ready, using `jQuery.ready`:
$(function(){
    
  // Todo Model
  // ----------

  // Our basic **Todo** model has `content`, `order`, and `done` attributes.
  window.Todo = Backbone.Model.extend({
        
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
      var options = {
        success: function(model, response) {
          this.saveModelState();
          Todos.trigger('change:unsaved');
        }.bind(this)
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
      this.destroy({
        success: function() {
          // remove from UnsavedList
          UnsavedTodos.removeUnsaved(this.get('id'));
          // remove from view
          this.view.remove();
          // update unsaved count
          Todos.trigger('change:unsaved');
        }.bind(this)
      });
    },

    parse: function(data) {
      return data.attributes || data;
    }
  });

  // Todo Collection
  // ---------------

  // The collection of todos is backed by *localStorage* instead of a remote
  // server.
  window.TodoList = Backbone.Collection.extend({

    // Reference to this collection's model.
    model: Todo,
        
    defaultMode: 'local',
        
    persistModes: {
      local: 'local', 
      server: 'server'
    },
        
    toggleStorageMode: function(mode) {
      var mapMode = {
        'local':    {
          button: 'Switch to Server Storage', 
          header: 'Local Mode'
        },
        'server':   {
          button: 'Switch to Local Storage', 
          header: 'Server Mode'
        }
<<<<<<< HEAD
    });

    // Todo Collection
    // ---------------

    // The collection of todos is backed by *localStorage* instead of a remote
    // server.
    window.TodoList = Backbone.Collection.extend({

        // Reference to this collection's model.
        model: Todo,
        
        defaultMode: 'server',
        
        persistModes: {local: 'local', server: 'server'},
        
        toggleStorageMode: function(mode) {
            var mapMode = {
                'local':    {button: 'Switch to Server Storage', header: 'Local Mode'},
                'server':   {button: 'Switch to Local Storage', header: 'Server Mode'}
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
=======
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
>>>>>>> dev
                    
          case server:
            delete this.localStorage;
            Backbone.sync = Backbone.serverSync;
            break;
        }
//        window.UnsavedTodos = new UnsavedList;
        UnsavedTodos.reset();
        this.storageMode = mode;
        this.trigger('refresh:list');
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
      return data;
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
          !isEqual ? UnsavedTodos.addUnsaved(todo) : UnsavedTodos.removeUnsaved(todo);
        }
        return !isEqual;
      })
    },
        
    flag: function(id) {
      var saved = Todos.get(id);
      if(saved) saved.isScheduledForSave = true;
    },
        
    unflag: function(id) {
      if(id) {
        var saved = Todos.get(id);
        if(saved) saved.isScheduledForSave = false;
      } else {
        UnsavedTodos.each(function(unsaved) {
          var saved = Todos.get(unsaved.get('id'));
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
    }

  });

  // Create our global collection of **Todos**.
  window.Todos = new TodoList;
    
  window.UnsavedTodo = Backbone.Model;
    
  window.UnsavedList = Backbone.Collection.extend({
        
    model: UnsavedTodo,
        
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
        var saved = Todos.find(function(saved) {
          return saved.get('id') == unsaved.get('id');
        })
        if(saved) {
          Todos.flag(unsaved.get('id'));
          saved.save();
        }
      })
      Todos.unflag();
      Todos.trigger('change:unsaved');
    }
  },
  {
  // Class properties
  });
  
  window.UnsavedTodos = new UnsavedList;
  
  // Todo Item View
  // --------------

  // The DOM element for a todo item...
  window.TodoView = Backbone.View.extend({

    //... is a list tag.
    tagName:  "li",

    // Cache the template function for a single item.
    template: _.template($('#item-template').html()),

    // The DOM events specific to an item.
    events: {
      "click .check"              : "toggleDone",
      "dblclick div.todo-content" : "edit",
      "click span.todo-destroy"   : "clear",
      "keypress .todo-input"      : "updateOnEnter"
    },

    // The TodoView listens for changes to its model, re-rendering. Since there's
    // a one-to-one correspondence between a **Todo** and a **TodoView** in this
    // app, we set a direct reference on the model for convenience.
    initialize: function() {
      _.bindAll(this, 'render', 'close');

      this.model.bind('change', this.render);
      this.model.view = this;
    },

    // Re-render the contents of the todo item.
    render: function() {
      var isEqual = _.isEqual(this.model.savedAttributes, this.model.attributes);
      $(this.el).html(this.template(this.model.toJSON())).toggleClass('unsaved', !isEqual);
      $(this.el).prop('id', 'todo-'+this.model.get('id')).addClass('hover');
      this.setContent();
      return this;
    },
        
    // To avoid XSS (not that it would be harmful in this particular app),
    // we use `jQuery.text` to set the contents of the todo item.
    setContent: function() {
      var content = this.model.get('content');
      this.$('.todo-content').text(content);
      this.input = this.$('.todo-input');
      this.input.bind('blur', this.close);
      this.input.val(content);
    },

    // Toggle the `"done"` state of the model.
    toggleDone: function() {
      this.model.toggle();
    },

    // Switch this view into `"editing"` mode, displaying the input field.
    edit: function() {
      $(this.el).addClass("editing");
      this.input.focus();
    },

    // Close the `"editing"` mode, saving changes to the todo.
    close: function() {
      this.model.save({
        content: this.input.val()
      });
      $(this.el).removeClass("editing");
    },

    // If you hit `enter`, we're through editing the item.
    updateOnEnter: function(e) {
      if (e.keyCode == 13) this.close();
    },

    // Remove this view from the DOM.
    remove: function() {
      $(this.el).remove();
    },

    // Remove the item, destroy the model.
    clear: function() {
      this.model.clear();
    }
  });
    
    
  // The Application
  // ---------------

  // Our overall **AppView** is the top-level piece of UI.
  window.AppView = Backbone.View.extend({

    // Instead of generating a new element, bind to the existing skeleton of
    // the App already present in the HTML.
    el: $("#todoapp"),

    // Our template for the line of statistics at the bottom of the app.
    statsTemplate:              _.template($('#stats-template').html()),
    buttonCheckallTemplate:     _.template($('#button-checkall-template').html()),
    buttonUncheckallTemplate:   _.template($('#button-uncheckall-template').html()),
    buttonUnsavedTemplate:      _.template($('#button-unsaved-template').html()),
    buttonRefreshTemplate:      _.template($('#button-refresh-template').html()),
    buttonStorageTemplate:      _.template($('#button-storage-template').html()),
    storageHeaderTemplate:      _.template($('#storage-header-template').html()),

    // Delegated events for creating new items, and clearing completed ones.
    events: {
      'keypress #new-todo'                            :'createOnEnter',
      'keyup #new-todo'                               :'showTooltip',
      'click .todo-clear a'                           :'clearCompleted',
      'click #todo-controls #button-checkall button'  :'markAllDone',
      'click #todo-controls #button-uncheckall button':'markAllUndone',
      'click #todo-controls #button-unsaved button'   :'saveUnsaved',
      'click #todo-controls #button-refresh button'   :'refreshList',
      'click #todo-controls #button-storage button'   :'renderStorage',
      'sortupdate #todo-list'                         :'sortupdate',
      'click .showhide-controls'                      :'showhideControls'
    },
    
    // At initialization we bind to the relevant events on the `Todos`
    // collection, when items are added or changed. Kick things off by
    // loading any preexisting todos that might be saved in *localStorage*.
    initialize: function() {
        
      _.bindAll(this, 'addOne', 'addAll', 'addToBuffer', 'render', 'markAllDone', 'markAllUndone', 'renderSaveButton', 'renderStorage', 'refreshList', 'sortupdate');
            
      this.buffer = $();
      this.input    = this.$("#new-todo");
      this.sortableTodos = this.$('#todo-list');
      
      Todos.bind('add',     this.addOne);
      Todos.bind('reset', this.addAll);
      Todos.bind('all',     this.render);
      Todos.bind('refresh:list', this.refreshList);
      // custom event for changes on a model
      Todos.bind('change:unsaved', this.renderSaveButton);
      
      this.sortableTodos.sortable();
      this.renderStorage();
    },
        
    refreshList: function() {
      // disable refresh button
      this.renderRefreshState(true);
      var that = this;
      Todos.fetch({
        success: function() {
          that.buffer = $();
        }
      });
    },
        
    sortupdate: function(e, ui) {
      var todo;
      this.sortableTodos.children('li').each(function(index) {
        todo = Todos.get($(this).attr('id').replace("todo-", ""));
        if(todo.get('order') != index) todo.save({
          order: index
        });
      });
    },
        
    showhideControls: function(ev, dur) {
      var target = ev.target || ev;
      var duration = !dur ? 0 : dur;
      $(target).parent().next('.showhide').toggle(duration, function() {
        $(target).prev('span').toggleClass('down');
      });
      return target;
    },
        
    // Re-rendering the App just means refreshing the statistics -- the rest
    // of the app doesn't change.
    render: function() {
      this.$('#todo-stats').html(this.statsTemplate({
        total:      Todos.length,
        done:       Todos.done().length,
        remaining:  Todos.remaining().length
      }));
      this.$('#todo-controls #button-checkall').html(this.buttonCheckallTemplate({
        value:      'Mark all Done',
        remaining:  Todos.remaining().length
      }));
      this.$('#todo-controls #button-uncheckall').html(this.buttonUncheckallTemplate({
        value:      'Mark all Undone',
        done:       Todos.done().length
      }));
        
    },
        
    renderRefreshState: function(isBusy) {
      this.$('#todo-controls #button-refresh').html(this.buttonRefreshTemplate({
        value:      'Refresh',
        busy:       isBusy
      }));
    },
        
    renderSaveButton: function() {
      var unsaved = Todos.filterUnsaved();
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
      this.$('#todo-controls #button-unsaved').html(this.buttonUnsavedTemplate({
        unsaved:    unsaved.length,
        value:      value()
      }));
    },
        
    renderStorage: function() {
      var value = Todos.toggleStorageMode();
      this.$('#todo-controls #button-storage').html(this.buttonStorageTemplate({
        value:    value.button
      }));
      this.$('div #storage-mode').html(this.storageHeaderTemplate({
        value:    value.header
      }));
    },
    
    // buffers a TodoView
    addToBuffer: function(todo) {
      var view = new TodoView({
        model: todo
      });
      this.buffer = this.buffer.add(view.render().el);
    },
        
    // not used in this modified version, instead we use addToBuffer
    // Add a single todo item to the list by creating a view for it, and
    // appending its element to the `<ul>`.
    addOne: function(todo) {
      var view = new TodoView({
        model: todo
      });
      this.$("#todo-list").append(view.render().el);
    },
        
    // Add all items in the **Todos** collection at once.
    addAll: function() {
      // render save button
      Todos.trigger('change:unsaved');
      // buffer all View in the list
      Todos.each(this.addToBuffer);
      // send buffer to view
      $('#todo-list').html(this.buffer);
      // clear buffer
      this.buffer = $();
      // enable refresh button again
      this.renderRefreshState(false);
    },
    
    markAllDone: function(ev) {
      Todos.each(function(todo) {
        todo.set({
          done: true
        }, {
          silent: false
        });
      })
      Todos.trigger('change:unsaved');
        
    },
        
    markAllUndone: function(ev) {
      Todos.each(function(todo) {
        todo.set({
          done: false
        }, {
          silent: false
        });
      })
      Todos.trigger('change:unsaved');
        
    },
        
    saveUnsaved: function() {
      UnsavedTodos.save();
    },
        
    // Generate the attributes for a new Todo item.
    newAttributes: function() {
      return {
        content: this.input.val() || undefined,
        order:   Todos.nextOrder()
      };
    },

    // If you hit return in the main input field, create new **Todo** model,
    // persisting it to *localStorage*.
    createOnEnter: function(e) {
      if (e.keyCode != 13) return;
      var options = {
        success: function(model, response) {
          model.saveModelState();
        }
      }
      Todos.create(this.newAttributes(), options);
      this.input.val('');
    },

    // Clear all done todo items, destroying their models.
    clearCompleted: function() {
      _.each(Todos.done(), function(todo){
        todo.clear();
      });
      return false;
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

  // Finally, we kick things off by creating the **App**.
  window.App = new AppView;

});