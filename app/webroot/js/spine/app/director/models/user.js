var User;
var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
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
    User.__super__.constructor.apply(this, arguments);
  }
  User.configure('User', 'id', 'username', 'name', 'groupname', 'sessionid');
  User.extend(Spine.Model.Local);
  User.prototype.init = function() {};
  return User;
})();
Spine.Model.User = User;