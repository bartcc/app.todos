var Recent;
var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
Recent = (function() {
  __extends(Recent, Spine.Model);
  function Recent() {
    Recent.__super__.constructor.apply(this, arguments);
  }
  Recent.configure('Recent', 'id');
  Recent.extend(Spine.Model.Local);
  Recent.check = function(max) {
    this.fetch();
    return this.loadRecent(max);
  };
  Recent.logout = function() {
    this.destroyAll();
    return this.redirect('logout');
  };
  Recent.redirect = function(url) {
    return location.href = base_url + url;
  };
  Recent.prototype.init = function(instance) {
    if (!instance) {}
  };
  Recent.loadRecent = function(max) {
    if (max == null) {
      max = 100;
    }
    return $.ajax({
      contentType: 'application/json',
      dataType: 'json',
      processData: false,
      headers: {
        'X-Requested-With': 'XMLHttpRequest'
      },
      url: base_url + 'photos/recent/' + max,
      type: 'GET',
      success: this.proxy(this.success),
      error: this.proxy(this.error)
    });
  };
  Recent.success = function(json) {
    console.log('Ajax::success');
    return this.trigger('success:recent', json);
  };
  Recent.error = function(xhr) {
    console.log('Ajax::error');
    this.logout();
    return this.redirect('users/login');
  };
  return Recent;
})();
Spine.Model.Recent = Recent;
