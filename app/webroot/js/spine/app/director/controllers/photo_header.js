var $, PhotoHeader;
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
PhotoHeader = (function() {
  __extends(PhotoHeader, Spine.Controller);
  PhotoHeader.extend(Spine.Controller.Drag);
  PhotoHeader.prototype.events = {
    'click .closeView .gal': 'backToGalleries',
    'click .closeView .alb': 'backToAlbums',
    'click .closeView .pho': 'backToPhotos',
    'dragenter': 'dragenter',
    'dragover': 'dragover',
    'dragend': 'dragend',
    'drop': 'drop'
  };
  PhotoHeader.prototype.template = function(item) {
    return $("#headerPhotoTemplate").tmpl(item);
  };
  function PhotoHeader() {
    PhotoHeader.__super__.constructor.apply(this, arguments);
  }
  PhotoHeader.prototype.backToGalleries = function() {
    Spine.trigger('album:activate');
    return Spine.trigger('show:galleries');
  };
  PhotoHeader.prototype.backToAlbums = function() {
    Spine.trigger('gallery:activate', Gallery.record);
    return Spine.trigger('show:albums');
  };
  PhotoHeader.prototype.backToPhotos = function() {
    return Spine.trigger('show:photos');
  };
  PhotoHeader.prototype.change = function(item) {
    console.log('PhotoHeader::change');
    this.current = item;
    return this.render();
  };
  PhotoHeader.prototype.render = function() {
    return this.html(this.template(this.current));
  };
  PhotoHeader.prototype.drop = function(e) {
    e.stopPropagation();
    return e.preventDefault();
  };
  return PhotoHeader;
})();
if (typeof module !== "undefined" && module !== null) {
  module.exports = PhotoHeader;
}