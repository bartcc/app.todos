jQuery(function() {
  
  exports.NS('Todos.Views').LoginView = (function() {

    var Login = Backbone.View.extend({
    
      initialize: function() {
        console.log('login initialized')
        _.bindAll(this, 'login', 'close', 'newAttributes');
        
        this.bind('error:auth', this.show);
        
        this.username = this.$('.username');
        this.password = this.$('.password');
        this.closeButton = this.$('._close');
        this.localButton = this.$('._local');
        
        this.model = Todos.Models.User;
        this.model.bind('change', this.login);

      },

      events: {
        
        'click footer ._login'    : 'login',
        'keypress #login input'   : 'login',
        'click footer ._local'    : 'close',
        'click header ._close'    : 'close'

      },

      newAttributes: function() {
        return {
          username: this.username.val(),
          password: this.password.val()
        }
      },
      
      login: function(e) {
        if(e.keyCode != 13 && e.type != 'click') return;
        
        var that = this;
        this.model.action('login');
        this.model.save(this.newAttributes(), {
          success: function() {
            Todos.Views.App.Sidebar.trigger('fetch', 'server');
            that.close();
          },
          error: function() {
            Todos.Views.App.Sidebar.trigger('fetch', 'server');
          }
        });
        this.username.val('');
        this.password.val('');
      },
      
      show: function() {
        $(this.el).show();
        
        this.username.val('');
        this.password.val('') ;
        this.username.focus();
      },
      
      close: function(e) {
        var mode;
        if(e) {
          mode = $(e.currentTarget).hasClass('_local') ? 'local' : 'server' 
          Todos.Views.App.Sidebar.trigger('fetch', mode);
        }
        $(this.el).hide();
      }

    })

    return Login;

  })()
  
})  
  