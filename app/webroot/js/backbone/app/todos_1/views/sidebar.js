jQuery(function() {
  
  exports.NS('Todos.Views').SidebarView = (function() {
    
    var SidebarView = Backbone.View.extend({
      
      events: {
        'click #todo-controls #button-checkall button'  :'markAllDone',
        'click #todo-controls #button-uncheckall button':'markAllUndone',
        'click #todo-controls #button-unsaved button'   :'saveUnsaved',
        'click #todo-controls #button-refresh button'   :'refreshList',
        'click #todo-controls #button-storage button'   :'renderStorageButton',
        'click .showhide-controls'                      :'showhideControls'
      },
      
      initialize: function() {
        _.bindAll(this, 'render', 'refreshList', 'renderRefreshState', 'renderSaveButton', 'renderStorageButton')
        
        this.bind('refresh:list', this.refreshList);
        this.bind('change:unsaved', this.renderSaveButton);
        Todos.Collections.Todos.bind('all',     this.render);
        
        this.renderStorageButton();
      },
      
      buttonCheckallTemplate:     _.template($('#button-checkall-template').html()),
      buttonUncheckallTemplate:   _.template($('#button-uncheckall-template').html()),
      buttonUnsavedTemplate:      _.template($('#button-unsaved-template').html()),
      buttonRefreshTemplate:      _.template($('#button-refresh-template').html()),
      buttonStorageTemplate:      _.template($('#button-storage-template').html()),
      storageHeaderTemplate:      _.template($('#storage-header-template').html()),
      
      renderStorageButton: function() {
        var value = Todos.Collections.Todos.toggleStorageMode();
        this.trigger('refresh:list', value);
        this.$('span#button-storage').html(this.buttonStorageTemplate({
          value:    value.button
        }));
        this.$('div #storage-mode').html(this.storageHeaderTemplate({
          value:    value.header
        }));
      },
      
      render: function() {
        
        this.$('#button-checkall').html(this.buttonCheckallTemplate({
          value:      'Mark all Done',
          remaining:  Todos.Collections.Todos.remaining().length
        }));
        this.$('#button-uncheckall').html(this.buttonUncheckallTemplate({
          value:      'Mark all Undone',
          done:       Todos.Collections.Todos.done().length
        }));
        
      },
      
      refreshList: function(mode) {
        //...
        // disable refresh button
        this.renderRefreshState(true);
        var that = this;
        Todos.Collections.Todos.fetch({
          success: function() {
            that.buffer = $();
            that.renderRefreshState();
            Todos.trigger('change:background', mode)
          },
          error: function(e, ev) {
            alert('Can not connect to server !')
          }
        });
      },
      
      renderRefreshState: function(isBusy) {
        this.$('#button-refresh').html(this.buttonRefreshTemplate({
          value:      'Reset',
          busy:       isBusy
        }));
      },
      
      renderSaveButton: function() {
        var unsaved = Todos.Collections.Todos.filterUnsaved();
        var value = function() {
          var val = '';
          switch (unsaved.length) {
            case 0:
              val = 'Up-To-Date';
              break;
            case 1:
              val = 'Commit ' + unsaved.length + ' change';
              break;
            default:
              val = 'Commit ' + unsaved.length + ' changes'
          }
          return val;
        }
        this.$('span#button-unsaved').html(this.buttonUnsavedTemplate({
          unsaved:    unsaved.length,
          value:      value()
        }));
      },

      markAllDone: function(ev) {
        Todos.Collections.Todos.each(function(todo) {
          todo.set({
            done: true
          }, {
            silent: false
          });
        })
        this.trigger('change:unsaved');

      },

      markAllUndone: function(ev) {
        Todos.Collections.Todos.each(function(todo) {
          todo.set({
            done: false
          }, {
            silent: false
          });
        })
        this.trigger('change:unsaved');

      },

      saveUnsaved: function() {
        Todos.Collections.UnsavedTodos.save();
      },
      
      showhideControls: function(ev, dur) {
        var target = ev.target || ev;
        var duration = !dur ? 0 : dur;
        $(target).parent().next('.showhide').toggle(duration, function() {
          $(target).prev('span').toggleClass('down');
        });
        return target;
      }

    },
    {
      test: {sidebar: 'Sidebar'}
    })

    return SidebarView;
    
  })()
})