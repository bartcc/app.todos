var LoginView;
var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
LoginView = (function() {
  __extends(LoginView, Spine.Controller);
  LoginView.prototype.elements = {
    'button': 'logoutEl'
  };
  LoginView.prototype.events = {
    'click button': 'logout'
  };
  function LoginView() {
    LoginView.__super__.constructor.apply(this, arguments);
  }
  LoginView.prototype.template = function(item) {
    return $('#loginTemplate').tmpl(item);
  };
  LoginView.prototype.logout = function() {
    console.log('click');
    return window.location = base_url + 'logout';
  };
  LoginView.prototype.render = function(item) {
    return this.html(this.template(item));
  };
  return LoginView;
})();