var Photo;
var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; }, __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
Photo = (function() {
  __extends(Photo, Spine.Model);
  function Photo() {
    this.Photo = __bind(this.Photo, this);
    this.Photo = __bind(this.Photo, this);
    this.Photo = __bind(this.Photo, this);
    Photo.__super__.constructor.apply(this, arguments);
  }
  Photo.configure("Photo", 'title', "description", 'filesize', 'captured', 'exposure', "iso", 'longitude', 'aperture', 'make', 'model', 'user_id');
  Photo.extend(Spine.Model.Ajax);
  Photo.extend(Spine.Model.AjaxRelations);
  Photo.extend(Spine.Model.Filter);
  Photo.extend(Spine.Model.Cache);
  Photo.extend(Spine.Model.Uri);
  Photo.extend(Spine.Model.Extender);
  Photo.selectAttributes = ['title', "description", 'user_id'];
  Photo.parentSelector = 'Album';
  Photo.foreignModels = function() {
    return {
      'Album': {
        className: 'Album',
        joinTable: 'AlbumsPhoto',
        foreignKey: 'photo_id',
        associationForeignKey: 'album_id'
      }
    };
  };
  Photo.url = function() {
    return '' + base_url + this.className.toLowerCase() + 's';
  };
  Photo.nameSort = function(a, b) {
    var aa, bb, _ref, _ref2;
    aa = (_ref = (a || '').name) != null ? _ref.toLowerCase() : void 0;
    bb = (_ref2 = (b || '').name) != null ? _ref2.toLowerCase() : void 0;
    if (aa === bb) {
      return 0;
    } else if (aa < bb) {
      return -1;
    } else {
      return 1;
    }
  };
  Photo.defaults = {
    width: 140,
    height: 140,
    square: 1,
    quality: 70
  };
  Photo.uri_ = function(album, params, callback) {
    var ap, aps, options, photos, uri, url;
    if (callback == null) {
      callback = this.success;
    }
    options = $.extend({}, this.defaults, params);
    aps = AlbumsPhoto.filter(album != null ? album.id : void 0, {
      key: 'album_id'
    });
    photos = (function() {
      var _i, _len, _results;
      _results = [];
      for (_i = 0, _len = aps.length; _i < _len; _i++) {
        ap = aps[_i];
        _results.push(Photo.find(ap.photo_id));
      }
      return _results;
    })();
    if (!photos.length) {
      return;
    }
    url = options.width + '/' + options.height + '/' + options.square + '/' + options.quality;
    uri = Album.cache(album, url);
    if (!uri) {
      return $.ajax({
        url: base_url + 'photos/uri/' + url,
        data: JSON.stringify(photos),
        type: 'POST',
        success: function(uri) {
          Album.addToCache(album, url, uri);
          return callback.call(this, uri);
        },
        error: this.error
      });
    } else {
      console.log(uri);
      return callback.call(this, uri);
    }
  };
  Photo.success = function(uri) {
    console.log('Ajax::success');
    return Photo.trigger('uri', uri);
  };
  Photo.error = function(json) {
    return Photo.trigger('ajaxError', json);
  };
  Photo.create = function(atts) {
    console.log('my create');
    return this.__super__.constructor.create.call(this, atts);
  };
  Photo.refresh = function(values, options) {
    if (options == null) {
      options = {};
    }
    console.log('my refresh');
    return this.__super__.constructor.refresh.call(this, values, options);
  };
  Photo.prototype.init = function(instance) {
    var cache;
    cache = {};
    cache[instance.id] = [];
    return this.constructor.caches.push(cache);
  };
  Photo.prototype.selectAttributes = function() {
    var attr, result, _i, _len, _ref;
    result = {};
    _ref = this.constructor.selectAttributes;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      attr = _ref[_i];
      result[attr] = this[attr];
    }
    return result;
  };
  Photo.prototype.select = function(id, options) {
    var ap, record, _i, _len;
    ap = Spine.Model[options.joinTable].filter(id, options);
    for (_i = 0, _len = ap.length; _i < _len; _i++) {
      record = ap[_i];
      if (record.photo_id === this.id) {
        return true;
      }
    }
  };
  Photo.prototype.details = function() {
    var details;
    return details = {
      album: Album.record,
      gallery: Gallery.record
    };
  };
  return Photo;
})();
Spine.Model.Photo = Photo;