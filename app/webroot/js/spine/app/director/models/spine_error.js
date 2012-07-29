var SpineError;
var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
SpineError = (function() {
  __extends(SpineError, Spine.Model);
  function SpineError() {
    SpineError.__super__.constructor.apply(this, arguments);
  }
  SpineError.configure('SpineError', 'record', 'xhr', 'statusText', 'error');
  SpineError.extend(Spine.Model.Local);
  SpineError.prototype.init = function() {};
  return SpineError;
})();
Spine.Model.SpineError = SpineError;
