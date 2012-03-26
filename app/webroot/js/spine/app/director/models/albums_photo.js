var AlbumsPhoto;
var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
AlbumsPhoto = (function() {
  __extends(AlbumsPhoto, Spine.Model);
  function AlbumsPhoto() {
    AlbumsPhoto.__super__.constructor.apply(this, arguments);
  }
  AlbumsPhoto.configure("AlbumsPhoto", 'album_id', 'photo_id', 'order');
  AlbumsPhoto.extend(Spine.Model.Ajax);
  AlbumsPhoto.extend(Spine.Model.AjaxRelations);
  AlbumsPhoto.extend(Spine.Model.Filter);
  AlbumsPhoto.url = function() {
    return 'albums_photos';
  };
  AlbumsPhoto.albumHasPhoto_ = function(aid, pid) {
    var ap, aps, _i, _len;
    aps = this.filter(aid, {
      key: 'album_id'
    });
    for (_i = 0, _len = aps.length; _i < _len; _i++) {
      ap = aps[_i];
      if (ap.photo_id === pid) {
        return true;
      }
    }
    return false;
  };
  AlbumsPhoto.albums_ = function(id) {
    var ret;
    ret = [];
    this.each(function(item) {
      if (item['photo_id'] === id) {
        return ret.push(Album.find(item['album_id']));
      }
    });
    return ret;
  };
  AlbumsPhoto.albumPhotos = function(aid) {
    var ret;
    ret = [];
    this.each(function(item) {
      if (item['album_id'] === aid) {
        return ret.push(Photo.find(item['photo_id']));
      }
    });
    return ret;
  };
  AlbumsPhoto.photos = function(aid) {
    return Photo.filterRelated(aid, {
      joinTable: 'AlbumsPhoto',
      key: 'album_id'
    });
  };
  AlbumsPhoto.albums = function(pid) {
    return Album.filterRelated(pid, {
      joinTable: 'AlbumsPhoto',
      key: 'photo_id'
    });
  };
  AlbumsPhoto.c = 0;
  AlbumsPhoto.next = function() {
    return this.uid();
  };
  AlbumsPhoto.prototype.albums = function() {
    return Album.filterRelated(this.album_id, {
      joinTable: 'AlbumsPhoto',
      key: 'album_id'
    });
  };
  AlbumsPhoto.prototype.select = function(id, options) {
    if (this[options.key] === id && this.constructor.records[this.id]) {
      return true;
    }
    return false;
  };
  AlbumsPhoto.prototype.selectPhoto = function(id) {
    if (this.photo_id === id && this.album_id === Album.record.id) {
      return true;
    }
  };
  return AlbumsPhoto;
})();
Spine.Model.AlbumsPhoto = AlbumsPhoto;
