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
  GalleriesAlbum.configure("GalleriesAlbum", 'gallery_id', 'album_id', 'name', 'order');
  GalleriesAlbum.extend(Spine.Model.Ajax);
  GalleriesAlbum.extend(Spine.Model.AjaxRelations);
  GalleriesAlbum.extend(Spine.Model.Filter);
  GalleriesAlbum.url = function() {
    return 'galleries_albums';
  };
  GalleriesAlbum.galleryHasAlbum = function(gid, aid) {
    var ga, gas, _i, _len;
    gas = this.filter(gid, {
      key: 'gallery_id'
    });
    for (_i = 0, _len = gas.length; _i < _len; _i++) {
      ga = gas[_i];
      if (ga.album_id === aid) {
        return true;
      }
    }
    return false;
  };
  GalleriesAlbum.galleries = function(id) {
    var ret;
    ret = [];
    this.each(function() {
      if (item['album_id'] === id) {
        return ret.push(Gallery.find(item['gallery_id']));
      }
    });
    return ret;
  };
  GalleriesAlbum.albums = function(id) {
    var ret;
    ret = [];
    this.each(function(item) {
      if (item['gallery_id'] === id) {
        return ret.push(Album.find(item['album_id']));
      }
    });
    return ret;
  };
  GalleriesAlbum.prototype.select = function(query, options) {
    if (this[options.key] === query && this.constructor.records[this.id]) {
      return true;
    }
    return false;
  };
  GalleriesAlbum.prototype.selectAlbum = function(query) {
    if (this.album_id === query) {
      return true;
    }
  };
  return GalleriesAlbum;
})();
Spine.Model.GalleriesAlbum = GalleriesAlbum;
