jQuery(function() {
  
  exports.NS('Todos.Views').LoginView = (function() {

    var Login = Backbone.View.extend({
    
      initialize: function() {
        console.log('Login initialized')
        _.bindAll(this, 'login', 'onCancel', 'newAttributes');
        
        this.username = $('.username');
        this.password = $('.password');
        
        this.bind('error:auth', this.show);
        this.model = new Todos.Models.User();
        this.model.action = 'login';
        this.model.bind('change', this.login);

      },

      events: {
        
        'click footer ._login'    : 'login',
        'keypress #login input'   : 'login',
        'click footer ._cancel'   : 'onCancel',
        'click header ._close'    : 'onCancel'

      },

      newAttributes: function() {
        return {
          username: this.username.val(),
          password: this.password.val()
        }
      },
      
      onCancel: function() {
        this.close();
        Todos.Views.App.Sidebar.trigger('fetch', Todos.Collections.Todos.storageMode || Todos.Collections.Todos.defaultMode);
      },
      
      login: function(e) {
        if(e.keyCode != 13 && e.type != 'click') return;
        var that = this;
        this.model.save(this.newAttributes(), {
          success: function() {
            Todos.Views.App.Sidebar.trigger('fetch', Todos.Collections.Todos.storageMode || Todos.Collections.Todos.defaultMode);
            that.close();
          },
          error: function() {
            Todos.Views.App.Sidebar.trigger('fetch', Todos.Collections.Todos.storageMode || Todos.Collections.Todos.defaultMode);
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
      
      close: function() {
//        this.unbind();
        $(this.el).hide();
//        this.remove();
      }

    })

    return Login;

  })()
  
})  
  