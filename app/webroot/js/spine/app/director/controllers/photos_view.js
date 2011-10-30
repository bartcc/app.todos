var $, PhotosView;
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
PhotosView = (function() {
  __extends(PhotosView, Spine.Controller);
  PhotosView.prototype.template = function(items) {
    return $('#photosTemplate').tmpl(items);
  };
  function PhotosView() {
    PhotosView.__super__.constructor.apply(this, arguments);
    Spine.bind('create:photo', this.proxy(this.create));
    Spine.bind('destroy:photo', this.proxy(this.destroy));
    Spine.bind('show:photos', this.proxy(this.show));
  }
  PhotosView.prototype.change = function(item) {
    var photos;
    this.current = item;
    photos = Photo.filter(item != null ? item.id : void 0);
    return this.render(photos);
  };
  PhotosView.prototype.render = function(items) {
    return this.html(this.template(items));
  };
  PhotosView.prototype.create = function(e) {};
  PhotosView.prototype.destroy = function(e) {};
  PhotosView.prototype.show = function(album) {
    this.change(album);
    return Spine.trigger('change:canvas', this);
  };
  PhotosView.prototype.save = function(item) {};
  return PhotosView;
})();
if (typeof module !== "undefined" && module !== null) {
  module.exports = PhotosView;
}