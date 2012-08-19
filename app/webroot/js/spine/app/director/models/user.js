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
  User.configure('User', 'id', 'username', 'name', 'groupname', 'sessionid', 'hash');
  User.extend(Spine.Model.Local);
  User.ping = function() {
    var user;
    this.fetch();
    if (user = this.first()) {
      return user.confirm();
    } else {
      return this.redirect('users/login');
    }
  };
  User.logout = function() {
    this.destroyAll();
    return this.redirect('logout');
  };
  User.redirect = function(url, hash) {
    if (url == null) {
      url = '';
    }
    if (hash == null) {
      hash = '';
    }
    return location.href = base_url + url + hash;
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
    return this.constructor.trigger('pinger', this, $.parseJSON(json));
  };
  User.prototype.error = function(xhr) {
    console.log('Ajax::error');
    this.constructor.logout();
    return this.constructor.redirect('users/login');
  };
  return User;
})();
Spine.Model.User = User;
