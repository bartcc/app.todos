jQuery(function() {
  
  exports.NS('Todos.Views').LoginView = (function() {

    var Login = Backbone.View.extend({
    
      initialize: function() {
        _.bindAll(this, 'login', 'close', 'newAttributes', 'updateAuth');
        
        this.bind('error:auth', this.show);
        Todos.bind('update:auth', this.updateAuth);
        
        this.username = this.$('.username');
        this.password = this.$('.password');
        this.closeButton = this.$('._close');
        this.localButton = this.$('._local');
        
        this.model = Todos.Models.User;

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
      
      updateAuth: function() {
        if(this.model.get('username') !== '') return;
        this.model.action('login');
        this.model.save();
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
  