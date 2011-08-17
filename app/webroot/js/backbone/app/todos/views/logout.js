jQuery(function() {
  
  exports.NS('Todos.Views').LogoutView = (function() {

    var Logout = Backbone.View.extend({
    
      template: _.template($('#button-logout-template').html()),
      
      initialize: function() {
        _.bindAll(this, 'logout', 'newAttributes', 'render', 'template');
        
        this.button = this.$('button._logout');
        this.model = Todos.Models.User;
        
        //this.model.bind('change', this.logout);
        Todos.bind('mode', this.render);
        this.model.bind('change', this.render);

      },

      events: {
        
        'click button._logout'    : 'logout'

      },
      
      render: function() {
        if(Todos.Collections.Todos.storageMode === 'server') {
          $(this.el).html(this.template({
            value: this.model.get('name')
          }));
        } else {
          $(this.el).empty();
        }
      },
      
      newAttributes: function() {
        return {
          username: Todos.Views.App.Login.username.val(),
          password: Todos.Views.App.Login.password.val()
        }
      },
      
      logout: function() {
        this.model.action('logout');
        this.model.save(this.newAttributes(), {
          success: function() {
            Todos.Views.App.Sidebar.trigger('fetch', Todos.Collections.Todos.storageMode || Todos.Collections.Todos.defaultMode);
          }
        });
        Todos.Collections.Todos.empty();
        Todos.Views.App.Login.username.val('');
        Todos.Views.App.Login.password.val('');
        Todos.Views.App.Login.username.focus();
      }

    })

    return Logout;

  })()
  
})  
  