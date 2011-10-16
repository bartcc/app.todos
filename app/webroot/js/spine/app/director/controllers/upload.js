var $, UploadView;
var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
if (typeof Spine === "undefined" || Spine === null) {
  Spine = require("spine");
}
$ = Spine.$;
UploadView = (function() {
  __extends(UploadView, Spine.Controller);
  UploadView.prototype.events = {
    "click .item": "click"
  };
  function UploadView() {
    UploadView.__super__.constructor.apply(this, arguments);
    this.bind("change", this.change);
  }
  return UploadView;
})();
if (typeof module !== "undefined" && module !== null) {
  module.exports = UploadView;
}