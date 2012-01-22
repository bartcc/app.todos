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
  AlbumsPhoto.configure("AlbumsPhoto", "album_id", 'photo_id', 'order');
  AlbumsPhoto.extend(Spine.Model.Ajax);
  AlbumsPhoto.extend(Spine.Model.AjaxRelations);
  AlbumsPhoto.extend(Spine.Model.Filter);
  AlbumsPhoto.url = function() {
    return 'albums_photos';
  };
  AlbumsPhoto.albumHasPhoto = function(aid, pid) {
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
  AlbumsPhoto.albums = function(id) {
    var ret;
    ret = [];
    this.each(function() {
      if (item['photo_id'] === id) {
        return ret.push(Album.find(item['album_id']));
      }
    });
    return ret;
  };
  AlbumsPhoto.photos = function(id) {
    var ret;
    ret = [];
    this.each(function(item) {
      if (item['album_id'] === id) {
        return ret.push(Photo.find(item['photo_id']));
      }
    });
    return ret;
  };
  AlbumsPhoto.photos_ = function(id) {
    var ap, aps, ret, _i, _len;
    aps = AlbumsPhoto.filter(id, {
      key: 'album_id'
    });
    ret = [];
    for (_i = 0, _len = aps.length; _i < _len; _i++) {
      ap = aps[_i];
      ret.push(Photo.find(ap.photo_id));
    }
    return ret;
  };
  AlbumsPhoto.prototype.select = function(id, options) {
    if (this[options.key] === id && this.constructor.records[this.id]) {
      return true;
    }
    return false;
  };
  AlbumsPhoto.prototype.selectPhoto = function(query) {
    if (this.photo_id === query) {
      return true;
    }
  };
  return AlbumsPhoto;
})();
Spine.Model.AlbumsPhoto = AlbumsPhoto;
