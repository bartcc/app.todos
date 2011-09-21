var GalleriesAlbum;
var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
GalleriesAlbum = (function() {
  __extends(GalleriesAlbum, Spine.Model);
  function GalleriesAlbum() {
    GalleriesAlbum.__super__.constructor.apply(this, arguments);
  }
  GalleriesAlbum.configure("GalleriesAlbum", "gallery_id", 'album_id');
  GalleriesAlbum.extend(Spine.Model.Filter);
  GalleriesAlbum.extend(Spine.Model.Local);
  GalleriesAlbum.prototype.select = function(query) {
    if (this.gallery_id === query) {
      return true;
    }
  };
  return GalleriesAlbum;
})();