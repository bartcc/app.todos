jQuery(function() {
  
  exports.NS('Todos.Views').MainView = (function() {
    
    var MainView = Backbone.View.extend({

      // Instead of generating a new element, bind to the existing skeleton of
      // the App already present in the HTML.
      el: $("#wrapper"),

      // Our template for the line of statistics at the bottom of the Todos.
      statsTemplate:              _.template($('#stats-template').html()),

      Todos:                      Todos.Collections.Todos,
      UnsavedTodos:               Todos.Collections.UnsavedTodos,

      // Delegated events for creating new items, and clearing completed ones.
      events: {
        'keypress #new-todo input'                      :'createOnEnter',
        'keyup #new-todo'                               :'showTooltip',
        'click footer .clear'                           :'clearCompleted',
        'sortupdate #todo-list'                         :'sortupdate'
      },

      // At initialization we bind to the relevant events on the `Todos`
      // collection, when items are added or changed. Kick things off by
      // loading any preexisting todos that might be saved in *localStorage*.
      initialize: function() {
        _.bindAll(this, 'render', 'addOne', 'addAll', 'addToBuffer', 'sortupdate', 'renderBackground');

        this.buffer = $();
        this.input    = this.$("#new-todo input");
        this.sortableTodos = this.$('#todo-list');

        Todos.Collections.Todos.bind('add',     this.addOne);
        Todos.Collections.Todos.bind('reset',   this.addAll);
        Todos.Collections.Todos.bind('all',     this.render);
        
        Todos.bind('change:background', this.renderBackground);
        
        this.sortableTodos.sortable();
      },

      sortupdate: function(e, ui) {
        var todo;
        this.sortableTodos.children('li').each(function(index) {
          todo = Todos.Collections.Todos.get($(this).attr('id').replace("todo-", ""));
          if(todo.get('order') != index) todo.save({
            order: index
          });
        });
      },

      // Re-rendering the App just means refreshing the statistics -- the rest
      // of the app doesn't change.
      render: function() {
        this.$('#todo-stats').html(this.statsTemplate({
          total:      Todos.Collections.Todos.length,
          done:       Todos.Collections.Todos.done().length,
          remaining:  Todos.Collections.Todos.remaining().length
        }));
        
      },
      
      renderBackground: function(pers) {
        var mode = pers.mode;
        if(mode == 'server') {
          this.$('#todo-list').addClass("cloud");
        } else if(mode == 'local') {
          this.$('#todo-list').removeClass("cloud");
        }
      },
      
      // buffers a TodoView
      addToBuffer: function(todo) {
        var view = new Todos.Views.TodoView({
          model: todo
        });
        this.buffer = this.buffer.add(view.render().el);
      },
      
      // not used in this modified version, instead we use addToBuffer
      // Add a single todo item to the list by creating a view for it, and
      // appending its element to the `<ul>`.
      addOne: function(todo) {
        var view = new Todos.Views.TodoView({
          model: todo
        });
        this.$("#todo-list.items").append(view.render().el);
      },

      // Add all items in the **Todos** collection at once.
      addAll: function() {
        // render save button
        Todos.Views.App.Sidebar.trigger('change:unsaved');
        // buffer all View in the list
        Todos.Collections.Todos.each(this.addToBuffer);
        // send buffer to view
        $('#todo-list').html(this.buffer);
        // clear buffer
        this.buffer = $();
      },

      // Generate the attributes for a new Todo item.
      newAttributes: function() {
        return {
          content: this.input.val() || undefined,
          order:   this.App.nextOrder()
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
        this.App.create(this.newAttributes(), options);
        this.input.val('');
      },

      // Clear all done todo items, destroying their models.
      clearCompleted: function() {
        _.each(Todos.Collections.Todos.done(), function(todo){
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

    },
    {
      test: {main: 'Main'}
    })
    
    return MainView;
  })()
})