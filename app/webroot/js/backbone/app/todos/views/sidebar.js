jQuery(function() {
  
  exports.NS('Todos.Views').SidebarView = (function() {
    
    var SidebarView = Backbone.View.extend({
      
      events: {
        'click #todo-controls #button-checkall button'  :'markAllDone',
        'click #todo-controls #button-uncheckall button':'markAllUndone',
        'click #todo-controls #button-unsaved button'   :'saveUnsaved',
        'click #todo-controls #button-refresh button'   :'refresh',
        'click #todo-controls #button-storage button'   :'start',
        'click .showhide-controls'                      :'showhideControls'
      },
      
      initialize: function() {
        _.bindAll(this, 'fetch', 'start', 'render', 'refreshList', 'renderRefreshState', 'renderSaveButton')
        this.bind('fetch',                      this.fetch);
        this.bind('refresh:list',               this.refreshList);
        this.bind('change:unsaved',             this.renderSaveButton);
        Todos.Collections.Todos.bind('all',     this.render);
        
        //this.fetch();
      },
      
      buttonCheckallTemplate:     _.template($('#button-checkall-template').html()),
      buttonUncheckallTemplate:   _.template($('#button-uncheckall-template').html()),
      buttonUnsavedTemplate:      _.template($('#button-unsaved-template').html()),
      buttonRefreshTemplate:      _.template($('#button-refresh-template').html()),
      buttonStorageTemplate:      _.template($('#button-storage-template').html()),
      
      start: function() {
        this.trigger('fetch');
      },
      
      fetch: function(mode) {
        var value = Todos.Collections.Todos.toggleStorageMode(mode);
        this.trigger('refresh:list', value);
        
        this.$('footer #refresh-db')[value.mode === 'server' ? 'show' : 'hide']();
        this.$('span#button-storage').toggleClass('server', value.mode !== 'local');
        this.$('span#button-storage').html(this.buttonStorageTemplate({
          value:    value.button
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
      
      refresh : function() {
        this.trigger('refresh:list');
      },
      
      refreshList: function(mode) {
        //...
        // disable refresh button
        this.renderRefreshState(true);
        var that = this;
        Todos.Collections.Todos.fetch({
          success: function() {
            that.buffer = $();
            // enable refresh button
            that.renderRefreshState();
            if(Backbone.sync === Backbone.serverSync) {
              Todos.trigger('update:auth');
            }
            if(mode) {
              Todos.trigger('render:storagestatus', mode);
            }
          },
          error: function(e, xhr) {
            // enable refresh button
            that.renderRefreshState();
            if(xhr.status >= 400) {
              Todos.Views.App.Login.trigger('error:auth');
              if(Backbone.sync === Backbone.serverSync) {
                Todos.Models.User.set({
                  sessionid : '',
                  name      : '',
                  username  : '',
                  id        : ''
                })
              }
            }
          }
        });
        Todos.trigger('mode');
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
      //Static
    })

    return SidebarView;
    
  })()
})