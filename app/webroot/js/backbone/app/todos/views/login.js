jQuery(function() {
  
  exports.NS('Todos.Views').LoginView = (function() {

    var Login = Backbone.View.extend({
    
      initialize: function() {
        _.bindAll(this, 'login', 'close', 'newAttributes', 'validateLogin', 'updateAuth');
        
        this.bind('error:auth', this.show);
        Todos.bind('update:auth', this.updateAuth);
        
        this.username = this.$('.username');
        this.password = this.$('.password');
        this.closeButton = this.$('._close');
        this.localButton = this.$('._local');
        this.loginButton = this.$('._login');
        this.flash = this.$('._flash');
        
        this.model = Todos.Models.User;
        this.isValid = false;

      },

      events: {
        
        'click footer ._login'    : 'login',
        'keypress #login input'   : 'login',
        'keyup #login input'      : 'validateLogin',
        'click footer ._local'    : 'close',
        'click header ._close'    : 'close'

      },

      newAttributes: function() {
        return {
          username: this.username.val(),
          password: this.password.val()
        }
      },
      
      validateLogin: function() {
        var funcValidate, funcAttr, username, password;
        funcValidate = function() {
          username = this.username.val();
          password = this.password.val();
          return !username || !password;
        }.bind(this)
        
        this.loginButton.toggleClass(function(i, cl, sw) {
          sw ? $(this).attr('disabled') : $(this).removeAttr('disabled');
          return 'disabled';
        }, funcValidate())
      },
      
      login: function(e) {
        if((e.keyCode != 13 && e.type != 'click') || this.loginButton.hasClass('disabled')) return;
        
        
        var that = this, json;
        this.model.action('login');
        this.model.save(this.newAttributes(), {
          success: function(a, xhr) {
            Todos.Views.App.Sidebar.trigger('fetch', 'server');
            json = xhr.responseText;
            that.flash.html(xhr.flash);
            that.username.val('');
            that.password.val('');
            that.close();
          },
          error: function(a, xhr) {
            //Todos.Views.App.Sidebar.trigger('fetch', 'server');
            json = xhr.responseText;
            that.flash.html(JSON.parse(json).flash);
            that.username.focus();
            that.password.val('');
            that.validateLogin();
          }
        });
      },
      
      updateAuth: function() {
        if(this.model.get('name') !== '') return;
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
        var mode, that = this, t = 1500;
        if(e) {
          t = 0;
          mode = $(e.currentTarget).hasClass('_local') ? 'local' : 'server' 
          Todos.Views.App.Sidebar.trigger('fetch', mode);
        }
        setTimeout(function(t) {
          $(that.el).hide();
          that.flash.empty();
        }, t)
      }

    })

    return Login;

  })()
  
})  
  