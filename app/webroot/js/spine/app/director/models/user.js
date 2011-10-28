var User;
var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; }, __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
User = (function() {
  __extends(User, Spine.Model);
  function User() {
    this.error = __bind(this.error, this);
    this.success = __bind(this.success, this);
    User.__super__.constructor.apply(this, arguments);
  }
  User.configure('User', 'id', 'username', 'name', 'groupname', 'sessionid');
  User.extend(Spine.Model.Local);
  User.ping = function() {
    var user;
    User.fetch();
    if (user = User.first()) {
      return user.confirm();
    } else {
      return User.redirect('users/login');
    }
  };
  User.logout = function() {
    User.destroyAll();
    return User.redirect('logout');
  };
  User.redirect = function(url) {
    return window.location = base_url + url;
  };
  User.prototype.init = function(instance) {
    if (!instance) {}
  };
  User.prototype.confirm = function() {
    return $.ajax({
      url: base_url + 'users/ping',
      data: JSON.stringify(this),
      type: 'POST',
      success: this.success,
      error: this.error
    });
  };
  User.prototype.success = function(json) {
    console.log('Ajax::success');
    return User.trigger('pinger', this, json);
  };
  User.prototype.error = function(xhr) {
    console.log('Ajax::error');
    this.constructor.logout();
    return this.constructor.redirect('users/login');
  };
  return User;
})();
Spine.Model.User = User;