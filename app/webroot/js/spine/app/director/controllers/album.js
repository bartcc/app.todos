var $, AlbumView;
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
AlbumView = (function() {
  __extends(AlbumView, Spine.Controller);
  AlbumView.prototype.events = {
    "click .item": "click"
  };
  function AlbumView() {
    AlbumView.__super__.constructor.apply(this, arguments);
    this.bind("change", this.change);
  }
  AlbumView.prototype.click = function() {
    return console.log('click');
  };
  return AlbumView;
})();
if (typeof module !== "undefined" && module !== null) {
  module.exports = AlbumView;
}