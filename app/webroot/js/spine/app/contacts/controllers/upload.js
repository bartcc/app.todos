var $, Upload;
var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
if (typeof Spine !== "undefined" && Spine !== null) {
  Spine;
} else {
  Spine = require("spine");
};
$ = Spine.$;
Upload = (function() {
  __extends(Upload, Spine.Controller);
  Upload.prototype.events = {
    "click .item": "click"
  };
  function Upload() {
    Upload.__super__.constructor.apply(this, arguments);
    this.bind("change", this.change);
  }
  return Upload;
})();
if (typeof module !== "undefined" && module !== null) {
  module.exports = Upload;
}