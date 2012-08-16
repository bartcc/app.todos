var Album;
var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; }, __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
Album = (function() {
  __extends(Album, Spine.Model);
  function Album() {
    this.details = __bind(this.details, this);
    Album.__super__.constructor.apply(this, arguments);
  }
  Album.configure("Album", 'title', 'description', 'count', 'user_id', 'order', 'invalid');
  Album.extend(Spine.Model.Cache);
  Album.extend(Spine.Model.Filter);
  Album.extend(Spine.Model.Ajax);
  Album.extend(Spine.Model.AjaxRelations);
  Album.extend(Spine.Model.Uri);
  Album.extend(Spine.Model.Extender);
  Album.selectAttributes = ['title'];
  Album.parentSelector = 'Gallery';
  Album.previousID = false;
  Album.url = function() {
    return '' + base_url + this.className.toLowerCase() + 's';
  };
  Album.nameSort = function(a, b) {
    var aa, bb, _ref, _ref2;
    aa = (_ref = (a || '').title) != null ? _ref.toLowerCase() : void 0;
    bb = (_ref2 = (b || '').title) != null ? _ref2.toLowerCase() : void 0;
    if (aa === bb) {
      return 0;
    } else if (aa < bb) {
      return -1;
    } else {
      return 1;
    }
  };
  Album.foreignModels = function() {
    return {
      'Gallery': {
        className: 'Gallery',
        joinTable: 'GalleriesAlbum',
        foreignKey: 'album_id',
        associationForeignKey: 'gallery_id'
      },
      'Photo': {
        className: 'Photo',
        joinTable: 'AlbumsPhoto',
        foreignKey: 'album_id',
        associationForeignKey: 'photo_id'
      }
    };
  };
  Album.contains = function(id) {
    return AlbumsPhoto.filter(id, {
      key: 'album_id'
    }).length;
  };
  Album.photos = function(id, max) {
    return AlbumsPhoto.filterRelated(id, {
      key: 'album_id'
    }).slice(0, max);
  };
  Album.prototype.init = function(instance) {
    var o, s;
    if (!instance.id) {
      return;
    }
    s = new Object();
    s[instance.id] = [];
    this.constructor.selection.push(s);
    o = new Object();
    o[instance.id] = [];
    return this.constructor.caches.push(o);
  };
  Album.prototype.selChange = function(list) {};
  Album.prototype.contains = function() {
    return this.constructor.contains(this.id);
  };
  Album.prototype.photos = function(max) {
    return this.constructor.photos(this.id, max || this.contains());
  };
  Album.prototype.details = function() {
    return {
      iCount: this.constructor.contains(this.id),
      album: Album.record,
      gallery: Gallery.record
    };
  };
  Album.prototype.selectAttributes = function() {
    var attr, result, _i, _len, _ref;
    result = {};
    _ref = this.constructor.selectAttributes;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      attr = _ref[_i];
      result[attr] = this[attr];
    }
    return result;
  };
  Album.prototype.select = function(joinTableItems) {
    var record, _i, _len;
    for (_i = 0, _len = joinTableItems.length; _i < _len; _i++) {
      record = joinTableItems[_i];
      if (record.album_id === this.id && ((this['order'] = record.order) != null)) {
        return true;
      }
    }
  };
  Album.prototype.selectAlbum = function(id) {
    if (this.id === id) {
      return true;
    }
    return false;
  };
  return Album;
})();
Spine.Model.Album = Album;
