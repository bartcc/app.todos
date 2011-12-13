var $, SlideshowEditView;
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
SlideshowEditView = (function() {
  __extends(SlideshowEditView, Spine.Controller);
  SlideshowEditView.prototype.events = {
    'click': 'click'
  };
  function SlideshowEditView() {
    SlideshowEditView.__super__.constructor.apply(this, arguments);
    this.bind("change", this.change);
  }
  SlideshowEditView.prototype.click = function(e) {
    console.log('click');
    e.stopPropagation();
    e.preventDefault();
    return false;
  };
  return SlideshowEditView;
})();
if (typeof module !== "undefined" && module !== null) {
  module.exports = SlideshowEditView;
}