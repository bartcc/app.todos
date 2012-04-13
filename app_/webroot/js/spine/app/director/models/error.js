var Error;
var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
Error = (function() {
  __extends(Error, Spine.Model);
  function Error() {
    Error.__super__.constructor.apply(this, arguments);
  }
  Error.configure('Error', 'record', 'xhr', 'statusText', 'error');
  Error.extend(Spine.Model.Local);
  Error.prototype.init = function() {};
  return Error;
})();
Spine.Model.Error = Error;