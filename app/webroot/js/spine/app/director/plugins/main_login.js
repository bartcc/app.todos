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
  function MainLogin(form, displayField) {
    if (displayField == null) {
      displayField = '._flash';
    }
    this.error = __bind(this.error, this);
    this.success = __bind(this.success, this);
    this.complete = __bind(this.complete, this);
    this.submit = __bind(this.submit, this);
    MainLogin.__super__.constructor.apply(this, arguments);
    this.displayField = $('._flash');
    this.passwordField = $('#UserPassword');
  }
  MainLogin.prototype.submit = function() {
    return $.ajax({
      data: this.el.serialize(),
      type: 'POST',
      success: this.success,
      error: this.error,
      complete: this.complete
    });
  };
  MainLogin.prototype.complete = function(xhr) {
    var json;
    json = xhr.responseText;
    return this.passwordField.val('').focus();
  };
  MainLogin.prototype.success = function(json) {
    var delayedFunc, redirect_url;
    console.log('success');
    console.log(json);
    redirect_url = base_url + 'director_app';
    this.displayField.html(json.flash);
    delayedFunc = function() {
      return window.location = redirect_url;
    };
    return this.delay(delayedFunc, 2000);
  };
  MainLogin.prototype.error = function(xhr) {
    var delayedFunc, json, oldMessage;
    json = $.parseJSON(xhr.responseText);
    oldMessage = this.displayField.html();
    delayedFunc = function() {
      return this.displayField.html(oldMessage);
    };
    this.displayField.html(json.flash);
    return this.delay(delayedFunc, 2000);
  };
  return MainLogin;
})();