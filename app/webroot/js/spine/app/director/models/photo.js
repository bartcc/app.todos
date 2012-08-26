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
    Photo.__super__.constructor.apply(this, arguments);
  }
  Photo.configure("Photo", 'title', "description", 'filesize', 'captured', 'exposure', "iso", 'longitude', 'aperture', 'make', 'model', 'user_id', 'order', 'active');
  Photo.extend(Spine.Model.Cache);
  Photo.extend(Spine.Model.Ajax);
  Photo.extend(Spine.Model.AjaxRelations);
  Photo.extend(Spine.Model.Filter);
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
  Photo.trashed = function() {
    var item, res;
    res = [];
    for (item in this.records) {
      if (!AlbumsPhoto.exists(item.id)) {
        res.push(item);
      }
    }
    return res;
  };
  Photo.inactive = function() {
    return this.findAllByAttribute('active', false);
  };
  Photo.prototype.init = function(instance) {
    if (!instance) {
      return;
    }
    return this.constructor.initCache(instance.id);
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
  Photo.prototype.select = function(joinTableItems) {
    var record, _i, _len;
    for (_i = 0, _len = joinTableItems.length; _i < _len; _i++) {
      record = joinTableItems[_i];
      if (record.photo_id === this.id && ((this['order'] = record.order) != null)) {
        return true;
      }
    }
  };
  Photo.prototype.selectPhoto = function(id) {
    if (this.id === id) {
      return true;
    }
    return false;
  };
  Photo.prototype.details = function() {
    return {
      gallery: Gallery.record,
      album: Album.record,
      photo: Photo.record
    };
  };
  return Photo;
})();
Spine.Model.Photo = Photo;
