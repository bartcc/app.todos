jQuery(function() {
  
  exports.NS('Todos.Views').LoginView = (function() {

    var Login = Backbone.View.extend({
      
      template: _.template($('#flash-template').html()),
      
      loginText: 'Enter Username and Password',
      
      initialize: function() {
        _.bindAll(this, 'login', 'close', 'cancel', 'newAttributes', 'validateLogin', 'updateAuth', 'renderFlash');
        
        this.bind('error:auth', this.show);
        this.bind('flash', this.renderFlash);
        Todos.bind('update:auth', this.updateAuth);
        
        this.username     = this.$('.username');
        this.password     = this.$('.password');
        this.closeButton  = this.$('._close');
        this.cancelButton = this.$('._cancel');
        this.localButton  = this.$('._local');
        this.loginButton  = this.$('._login');
        this.flash        = this.$('._flash span');
        
        this.model = Todos.Models.User;
        this.isValid = false;
        
        this.trigger('flash', this.loginText);

      },

      events: {
        
        'click footer ._cancel'   : 'cancel',
        'click footer ._login'    : 'login',
        'keypress #login input'   : 'login',
        'keyup #login input'      : 'validateLogin',
        'click footer ._local'    : 'close',
        'click header ._close'    : 'close'

      },
      
      renderFlash: function(value, goBack, t) {
        var that = this;
        this.flash.html(this.template({ value: value }));
        if(goBack) {
          setTimeout(function() {
            that.trigger('flash', that.loginText);
          }, t || 3000)
        }
        return this;
      },
      
      newAttributes: function() {
        return {
          username: this.username.val(),
          password: this.password.val()
        }
      },
      
      validateLogin: function() {
        var funcValidate, that = this;
        funcValidate = function() {
          return !that.username.val() || !that.password.val();
        }
        
        this.loginButton.toggleClass(function(i, cl, sw) {
          sw ? $(this).attr('disabled') : $(this).removeAttr('disabled');
          return 'disabled';
        }, funcValidate())
      },
      
      login: function(e) {
        if((e.keyCode != 13 && e.type != 'click') || this.loginButton.hasClass('disabled')) return;
        
        
        var that = this;
        this.model.action('login');
        this.model.save(this.newAttributes(), {
          success: function(a, responseText) {
            Todos.Views.App.Sidebar.trigger('fetch', 'server');
            that.trigger('flash', responseText.flash, true);
            that.username.val('');
            that.password.val('');
            that.close();
          },
          error: function(a, xhr) {
            that.trigger('flash', JSON.parse(xhr.responseText).flash, true);
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
        this.username.val('');
        this.password.val('') ;
        this.validateLogin();
        $(this.el).show();
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
        }, t)
      },
      
      cancel: function(e) {
        this.redirect();
      },
      
      redirect: function(url, external) {
        if (url == null) {
          url = '';
        }
        return location.href = (external ? 'http://' : base_url) + url;
      }

    })

    return Login;

  })()
  
})  
  