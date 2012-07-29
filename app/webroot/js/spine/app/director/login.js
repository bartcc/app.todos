var Login;
var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; }, __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
Login = (function() {
  __extends(Login, Spine.Controller);
  Login.prototype.elements = {
    'form': 'form',
    '.flash': 'flashEl',
    '.info': 'infoEl',
    '#UserPassword': 'passwordEl',
    '#UserUsername': 'usernameEl',
    '#flashTemplate': 'flashTemplate',
    '#infoTemplate': 'infoTemplate'
  };
  Login.prototype.events = {
    'keypress': 'submitOnEnter',
    'click #guestLogin': 'guestLogin',
    'click #cancel': 'cancel'
  };
  Login.prototype.template = function(el, item) {
    return el.tmpl(item);
  };
  function Login(form) {
    this.error = __bind(this.error, this);
    this.success = __bind(this.success, this);
    this.complete = __bind(this.complete, this);
    this.submit = __bind(this.submit, this);
    var lastError;
    Login.__super__.constructor.apply(this, arguments);
    SpineError.fetch();
    if (SpineError.count()) {
      lastError = SpineError.last();
    }
    if (lastError) {
      this.render(this.flashEl, this.flashTemplate, lastError);
      if (lastError.record) {
        this.render(this.infoEl, this.infoTemplate, lastError);
      }
    }
    SpineError.destroyAll();
  }
  Login.prototype.render = function(el, tmpl, item) {
    return el.html(this.template(tmpl, item));
  };
  Login.prototype.submit = function() {
    return $.ajax({
      data: this.form.serialize(),
      type: 'POST',
      success: this.success,
      error: this.error,
      complete: this.complete
    });
  };
  Login.prototype.complete = function(xhr) {
    var json;
    json = xhr.responseText;
    this.passwordEl.val('');
    return this.usernameEl.val('').focus();
  };
  Login.prototype.success = function(json) {
    var delayedFunc, user;
    json = $.parseJSON(json);
    User.fetch();
    User.destroyAll();
    user = new User(this.newAttributes(json));
    user.save();
    this.render(this.flashEl, this.flashTemplate, json);
    delayedFunc = function() {
      return User.redirect('director_app');
    };
    return this.delay(delayedFunc, 1000);
  };
  Login.prototype.error = function(xhr) {
    var delayedFunc, json;
    json = $.parseJSON(xhr.responseText);
    if (!this.oldMessage) {
      this.oldMessage = this.flashEl.html();
    }
    delayedFunc = function() {
      return this.flashEl.html(this.oldMessage);
    };
    this.render(this.flashEl, this.flashTemplate, json);
    return this.delay(delayedFunc, 2000);
  };
  Login.prototype.newAttributes = function(json) {
    return {
      id: json.id,
      username: json.username,
      name: json.name,
      groupname: json.groupname,
      sessionid: json.sessionid
    };
  };
  Login.prototype.cancel = function(e) {
    User.redirect();
    return e.preventDefault();
  };
  Login.prototype.guestLogin = function() {
    console.log('guest login');
    this.passwordEl.val('guest');
    this.usernameEl.val('guest');
    return this.submit();
  };
  Login.prototype.submitOnEnter = function(e) {
    if (e.keyCode !== 13) {
      return;
    }
    this.submit();
    return e.preventDefault();
  };
  return Login;
})();
$(function() {
  return window.Login = new Login({
    el: $('body')
  });
});
