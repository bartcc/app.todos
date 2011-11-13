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
    this.Album = __bind(this.Album, this);
    Album.__super__.constructor.apply(this, arguments);
  }
  Album.configure("Album", 'title', 'description', 'count', 'user_id');
  Album.extend(Spine.Model.Ajax);
  Album.extend(Spine.Model.AjaxRelations);
  Album.extend(Spine.Model.Filter);
  Album.extend(Spine.Model.Extender);
  Album.caches = [
    {
      global: {}
    }
  ];
  Album.selectAttributes = ['title'];
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
        associationForeignKey: 'image_id'
      }
    };
  };
  Album.cacheList = function(recordID) {
    var id, item, _i, _len, _ref;
    id = recordID || this.record.id;
    if (!id) {
      return this.caches[0].global;
    }
    _ref = this.caches;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      item = _ref[_i];
      if (item[id]) {
        return item[id];
      }
    }
  };
  Album.cache = function(record, url) {
    var cache;
    cache = this.cacheList(record != null ? record.id : void 0);
    return cache[url];
  };
  Album.addToCache = function(url, uri) {
    var cache, _ref;
    if (uri == null) {
      uri = '123abc';
    }
    cache = this.cacheList((_ref = Album.record) != null ? _ref.id : void 0);
    cache[url] = uri;
    return cache;
  };
  Album.prototype.init = function(instance) {
    var cache, newSelection;
    if (!instance) {
      return;
    }
    newSelection = {};
    newSelection[instance.id] = [];
    this.constructor.selection.push(newSelection);
    cache = {};
    cache[instance.id] = {};
    return this.constructor.caches.push(cache);
  };
  Album.prototype.cacheList = function() {
    return this.constructor.cacheList(this.id);
  };
  Album.prototype.addToCache = function(url, uri) {
    var cache;
    if (uri == null) {
      uri = '123abc';
    }
    cache = this.cacheList(this.id);
    cache[url] = uri;
    return cache;
  };
  Album.prototype.cache = function(url) {
    var cache;
    cache = this.cacheList(this.id);
    return cache[url];
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
  Album.prototype.select = function(id) {
    var ga, record, _i, _len;
    ga = GalleriesAlbum.filter(id);
    for (_i = 0, _len = ga.length; _i < _len; _i++) {
      record = ga[_i];
      if (record.album_id === this.id) {
        return true;
      }
    }
  };
  return Album;
})();
Spine.Model.Album = Album;