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
    'click .gal': 'backToGalleries',
    'click .alb': 'backToAlbums',
    'click .pho': 'backToPhotos',
    'dragenter': 'dragenter',
    'dragend': 'dragend',
    'drop': 'drop'
  };
  PhotoHeader.prototype.template = function(item) {
    return $("#headerPhotoTemplate").tmpl(item);
  };
  function PhotoHeader() {
    PhotoHeader.__super__.constructor.apply(this, arguments);
    Gallery.bind('change', this.proxy(this.change));
    Album.bind('change', this.proxy(this.change));
  }
  PhotoHeader.prototype.backToGalleries = function(e) {
    this.navigate('/galleries/');
    e.stopPropagation();
    return e.preventDefault();
  };
  PhotoHeader.prototype.backToAlbums = function(e) {
    var _ref;
    this.navigate('/gallery', ((_ref = Gallery.record) != null ? _ref.id : void 0) || '');
    e.stopPropagation();
    return e.preventDefault();
  };
  PhotoHeader.prototype.backToPhotos = function(e) {
    var _ref;
    this.navigate('/gallery', (Gallery.record.id || '') + '/' + (((_ref = Album.record) != null ? _ref.id : void 0) || ''));
    e.stopPropagation();
    return e.preventDefault();
  };
  PhotoHeader.prototype.change = function() {
    console.log('PhotoHeader::change');
    return this.render();
  };
  PhotoHeader.prototype.render = function() {
    return this.html(this.template(Photo.record));
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
