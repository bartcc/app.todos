var $, PhotosView;
var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; }, __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
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
PhotosView = (function() {
  __extends(PhotosView, Spine.Controller);
  function PhotosView() {
    this.show = __bind(this.show, this);    PhotosView.__super__.constructor.apply(this, arguments);
    Spine.bind('create:photo', this.proxy(this.create));
    Spine.bind('destroy:photo', this.proxy(this.destroy));
    Spine.bind('show:photos', this.proxy(this.show));
  }
  PhotosView.prototype.create = function(e) {
    return console.log('PhotoView::create');
  };
  PhotosView.prototype.destroy = function(e) {
    return console.log('PhotosView::destroy');
  };
  PhotosView.prototype.show = function() {
    console.log('PhotosView::show');
    console.log(this);
    return App.canvasManager.trigger('change', this);
  };
  return PhotosView;
})();
if (typeof module !== "undefined" && module !== null) {
  module.exports = PhotosView;
}