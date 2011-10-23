var MainLogin;
var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; }, __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
MainLogin = (function() {
  __extends(MainLogin, Spine.Controller);
  MainLogin.prototype.elements = {
    'form': 'form',
    '.flash': 'flashEl',
    '.info': 'infoEl',
    '#UserPassword': 'passwordEl',
    '#UserUsername': 'usernameEl',
    '#flashTemplate': 'flashTemplate',
    '#infoTemplate': 'infoTemplate'
  };
  MainLogin.prototype.template = function(el, item) {
    return el.tmpl(item);
  };
  function MainLogin(form) {
    this.error = __bind(this.error, this);
    this.success = __bind(this.success, this);
    this.complete = __bind(this.complete, this);
    this.submit = __bind(this.submit, this);    var lastError;
    MainLogin.__super__.constructor.apply(this, arguments);
    Error.fetch();
    if (Error.count()) {
      lastError = Error.last();
    }
    if (lastError) {
      this.render(this.flashEl, this.flashTemplate, lastError);
      if (lastError.record) {
        this.render(this.infoEl, this.infoTemplate, lastError);
      }
    }
    Error.destroyAll();
  }
  MainLogin.prototype.render = function(el, tmpl, item) {
    return el.html(this.template(tmpl, item));
  };
  MainLogin.prototype.submit = function() {
    return $.ajax({
      data: this.form.serialize(),
      type: 'POST',
      success: this.success,
      error: this.error,
      complete: this.complete
    });
  };
  MainLogin.prototype.complete = function(xhr) {
    var json;
    json = xhr.responseText;
    this.passwordEl.val('');
    return this.usernameEl.val('').focus();
  };
  MainLogin.prototype.success = function(json) {
    var delayedFunc, user;
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
  MainLogin.prototype.error = function(xhr) {
    var delayedFunc, json, oldMessage;
    json = $.parseJSON(xhr.responseText);
    oldMessage = this.flashEl.html();
    delayedFunc = function() {
      return this.flashEl.html(oldMessage);
    };
    this.render(this.flashEl, this.flashTemplate, json);
    return this.delay(delayedFunc, 2000);
  };
  MainLogin.prototype.newAttributes = function(json) {
    return {
      id: json.id,
      username: json.username,
      name: json.name,
      groupname: json.groupname,
      sessionid: json.sessionid
    };
  };
  return MainLogin;
})();
$(function() {
  return window.MainLogin = new MainLogin({
    el: $('body')
  });
});