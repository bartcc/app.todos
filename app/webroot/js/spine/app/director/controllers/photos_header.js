var $, PhotosHeader;
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
PhotosHeader = (function() {
  __extends(PhotosHeader, Spine.Controller);
  PhotosHeader.prototype.elements = {
    '.closeView': 'closeViewEl'
  };
  PhotosHeader.prototype.events = {
    'click .closeView': 'closeView'
  };
  function PhotosHeader() {
    PhotosHeader.__super__.constructor.apply(this, arguments);
  }
  PhotosHeader.prototype.closeView = function() {
    console.log('AlbumsHeader::closeView');
    Spine.trigger('gallery:exposeSelection', Gallery.record);
    return Spine.trigger('show:albums');
  };
  PhotosHeader.prototype.change = function(item) {
    this.current = item;
    return this.render();
  };
  PhotosHeader.prototype.render = function() {
    return this.html(this.template({
      gallery: Gallery.record,
      record: this.current,
      count: this.photosCount()
    }));
  };
  PhotosHeader.prototype.photosCount = function() {
    var _ref;
    return AlbumsPhoto.filter((_ref = Album.record) != null ? _ref.id : void 0, {
      key: 'album_id'
    }).length;
  };
  return PhotosHeader;
})();
if (typeof module !== "undefined" && module !== null) {
  module.exports = PhotosHeader;
}