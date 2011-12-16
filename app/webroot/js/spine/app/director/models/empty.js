var Empty;
var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
Empty = (function() {
  __extends(Empty, Spine.Model);
  function Empty() {
    Empty.__super__.constructor.apply(this, arguments);
  }
  Empty.extend(Spine.Model.Extender);
  return Empty;
})();
Spine.Model.Empty = Empty;