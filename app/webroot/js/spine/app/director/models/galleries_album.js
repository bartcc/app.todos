var GalleriesAlbum;
var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; }, __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
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
    this.GalleriesAlbum = __bind(this.GalleriesAlbum, this);
    GalleriesAlbum.__super__.constructor.apply(this, arguments);
  }
  GalleriesAlbum.configure("GalleriesAlbum", 'gallery_id', 'album_id', 'order');
  GalleriesAlbum.extend(Spine.Model.Ajax);
  GalleriesAlbum.extend(Spine.Model.AjaxRelations);
  GalleriesAlbum.extend(Spine.Model.Filter);
  GalleriesAlbum.extend(Spine.Model.Base);
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
  GalleriesAlbum.galleries = function(aid) {
    var ret;
    ret = [];
    this.each(function() {
      if (item['album_id'] === aid) {
        return ret.push(Gallery.find(item['gallery_id']));
      }
    });
    return ret;
  };
  GalleriesAlbum.albums = function(gid) {
    var ret;
    ret = [];
    this.each(function(item) {
      if (item['gallery_id'] === gid) {
        return ret.push(Album.find(item['album_id']));
      }
    });
    return ret;
  };
  GalleriesAlbum.next = function(gid) {
    var max;
    max = Math.max(this.count + 1, this.albums(gid).length);
    return this.counter = max;
  };
  GalleriesAlbum.prototype.select = function(id, options) {
    if (this[options.key] === id && this.constructor.records[this.id]) {
      return true;
    }
    return false;
  };
  GalleriesAlbum.prototype.selectAlbum = function(id) {
    if (this.album_id === id && this.gallery_id === Gallery.record.id) {
      return true;
    }
  };
  return GalleriesAlbum;
})();
Spine.Model.GalleriesAlbum = GalleriesAlbum;
