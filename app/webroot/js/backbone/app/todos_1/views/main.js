jQuery(function() {
  
  App.NS('Views').MainView = (function() {
    
    var MainView = Backbone.View.extend({

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

      Todos:                      App.Collections.Todos,
      UnsavedTodos:               App.Collections.UnsavedTodos,

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

        App.Collections.Todos.bind('add',     this.addOne);
        App.Collections.Todos.bind('reset', this.addAll);
        App.Collections.Todos.bind('all',     this.render);
        App.Collections.Todos.bind('refresh:list', this.refreshList);
        // custom event for changes on a model
        App.Collections.Todos.bind('change:unsaved', this.renderSaveButton);
        this.sortableTodos.sortable();
        this.renderStorage();
      },

      refreshList: function() {
        // disable refresh button
        this.renderRefreshState(true);
        var that = this;
        App.Collections.Todos.fetch({
          success: function() {
            that.buffer = $();
          }
        });
      },

      sortupdate: function(e, ui) {
        var todo;
        this.sortableTodos.children('li').each(function(index) {
          todo = App.Collections.Todos.get($(this).attr('id').replace("todo-", ""));
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
          total:      App.Collections.Todos.length,
          done:       App.Collections.Todos.done().length,
          remaining:  App.Collections.Todos.remaining().length
        }));
        this.$('#todo-controls #button-checkall').html(this.buttonCheckallTemplate({
          value:      'Mark all Done',
          remaining:  this.Todos.remaining().length
        }));
        this.$('#todo-controls #button-uncheckall').html(this.buttonUncheckallTemplate({
          value:      'Mark all Undone',
          done:       this.Todos.done().length
        }));

      },

      renderRefreshState: function(isBusy) {
        this.$('#todo-controls #button-refresh').html(this.buttonRefreshTemplate({
          value:      'Refresh',
          busy:       isBusy
        }));
      },

      renderSaveButton: function() {
        var unsaved = App.Collections.Todos.filterUnsaved();
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
        var value = App.Collections.Todos.toggleStorageMode();
        this.$('#todo-controls #button-storage').html(this.buttonStorageTemplate({
          value:    value.button
        }));
        this.$('div #storage-mode').html(this.storageHeaderTemplate({
          value:    value.header
        }));
      },

      // buffers a TodoView
      addToBuffer: function(todo) {
        var view = new App.Views.TodoView({
          model: todo
        });
        this.buffer = this.buffer.add(view.render().el);
      },

      // not used in this modified version, instead we use addToBuffer
      // Add a single todo item to the list by creating a view for it, and
      // appending its element to the `<ul>`.
      addOne: function(todo) {
        var view = new App.Views.TodoView({
          model: todo
        });
        this.$("#todo-list").append(view.render().el);
      },

      // Add all items in the **Todos** collection at once.
      addAll: function() {
        // render save button
        App.Collections.Todos.trigger('change:unsaved');
        // buffer all View in the list
        App.Collections.Todos.each(this.addToBuffer);
        // send buffer to view
        $('#todo-list').html(this.buffer);
        // clear buffer
        this.buffer = $();
        // enable refresh button again
        this.renderRefreshState(false);
      },

      markAllDone: function(ev) {
        App.Collections.Todos.each(function(todo) {
          todo.set({
            done: true
          }, {
            silent: false
          });
        })
        this.Todos.trigger('change:unsaved');

      },

      markAllUndone: function(ev) {
        App.Collections.Todos.each(function(todo) {
          todo.set({
            done: false
          }, {
            silent: false
          });
        })
        App.Collections.Todos.trigger('change:unsaved');

      },

      saveUnsaved: function() {
        App.Collections.UnsavedTodos.save();
      },

      // Generate the attributes for a new Todo item.
      newAttributes: function() {
        return {
          content: this.input.val() || undefined,
          order:   this.Todos.nextOrder()
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
        this.Todos.create(this.newAttributes(), options);
        this.input.val('');
      },

      // Clear all done todo items, destroying their models.
      clearCompleted: function() {
        _.each(App.Collections.Todos.done(), function(todo){
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
    
    return MainView;
  })()
})