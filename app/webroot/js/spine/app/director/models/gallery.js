var Gallery;
var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; }, __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
Gallery = (function() {
  __extends(Gallery, Spine.Model);
  function Gallery() {
    this.details = __bind(this.details, this);
    Gallery.__super__.constructor.apply(this, arguments);
  }
  Gallery.configure('Gallery', 'id', 'name', 'author', "description", 'user_id');
  Gallery.extend(Spine.Model.Filter);
  Gallery.extend(Spine.Model.Ajax);
  Gallery.extend(Spine.Model.AjaxRelations);
  Gallery.extend(Spine.Model.Extender);
  Gallery.selectAttributes = ['name', 'author'];
  Gallery.url = function() {
    return '' + base_url + 'galleries';
  };
  Gallery.nameSort = function(a, b) {
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
  Gallery.foreignModels = function() {
    return {
      'Album': {
        className: 'Album',
        joinTable: 'GalleriesAlbum',
        foreignKey: 'gallery_id',
        associationForeignKey: 'album_id'
      }
    };
  };
  Gallery.contains = function(id) {
    var filterOptions;
    filterOptions = {
      key: 'gallery_id',
      joinTable: 'GalleriesAlbum'
    };
    return Album.filterRelated(id, filterOptions);
  };
  Gallery.contains = function(id) {
    return GalleriesAlbum.filter(id, {
      key: 'gallery_id'
    }).length;
  };
  Gallery.albums = function(id) {
    var filterOptions;
    filterOptions = {
      key: 'gallery_id',
      joinTable: 'GalleriesAlbum'
    };
    return Album.filterRelated(id, filterOptions);
  };
  Gallery.prototype.init = function(instance) {
    var newSelection;
    if (!instance.id) {
      return;
    }
    newSelection = {};
    newSelection[instance.id] = [];
    return this.constructor.selection.push(newSelection);
  };
  Gallery.prototype.details = function() {
    var album, albums, imagesCount, _i, _len;
    albums = Gallery.albums(this.id);
    imagesCount = 0;
    for (_i = 0, _len = albums.length; _i < _len; _i++) {
      album = albums[_i];
      imagesCount += album.count = AlbumsPhoto.filter(album.id, {
        key: 'album_id'
      }).length;
    }
    return {
      iCount: imagesCount,
      aCount: albums.length
    };
  };
  Gallery.prototype.contains = function() {
    var albums, filterOptions;
    filterOptions = {
      key: 'gallery_id',
      joinTable: 'GalleriesAlbum'
    };
    return albums = Album.filterRelated(this.id, filterOptions).length;
  };
  Gallery.prototype.updateAttributes = function(atts, options) {
    if (options == null) {
      options = {};
    }
    this.load(atts);
    if (options.silent) {
      Spine.Ajax.enabled = false;
    }
    this.save();
    return Spine.Ajax.enabled = true;
  };
  Gallery.prototype.updateAttribute = function(name, value, options) {
    if (options == null) {
      options = {};
    }
    this[name] = value;
    if (options.silent) {
      Spine.Ajax.enabled = false;
    }
    this.save();
    return Spine.Ajax.enabled = true;
  };
  Gallery.prototype.selectAttributes = function() {
    var attr, result, _i, _len, _ref;
    result = {};
    _ref = this.constructor.selectAttributes;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      attr = _ref[_i];
      result[attr] = this[attr];
    }
    return result;
  };
  Gallery.prototype.select = function(joinTableItems) {
    var record, _i, _len;
    for (_i = 0, _len = joinTableItems.length; _i < _len; _i++) {
      record = joinTableItems[_i];
      if (record.gallery_id === this.id) {
        return true;
      }
    }
  };
  Gallery.prototype.searchSelect = function(query) {
    var atts, key, value;
    query = query.toLowerCase();
    atts = this.selectAttributes.apply(this);
    for (key in atts) {
      value = atts[key];
      value = value.toLowerCase();
      if (!((value != null ? value.indexOf(query) : void 0) === -1)) {
        return true;
      }
    }
    return false;
  };
  return Gallery;
})();
Spine.Model.Gallery = Gallery;
