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
    this.query_ = __bind(this.query_, this);
    Gallery.__super__.constructor.apply(this, arguments);
  }
  Gallery.configure("Gallery", "name", 'author', "description");
  Gallery.extend(Spine.Model.Ajax);
  Gallery.extend(Spine.Model.Filter);
  Gallery.extend(Spine.Model.Extender);
  Gallery.selectAttributes = ["name", 'author', "description"];
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
  Gallery.joinTables = ['GalleriesAlbum'];
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
  Gallery.prototype.query_ = function() {
    var albums;
    console.log('Galleries::query');
    albums = window[this.constructor.joinTables].select(__bind(function(record) {
      console.log(this.id + ' / ' + record.gallery_id);
      return record.gallery_id === this.id;
    }, this));
    console.log(albums);
    return albums;
  };
  Gallery.prototype.select_ = function(query) {
    return window[this.constructor.joinTables].select(__bind(function(record) {
      console.log(this.id + ' / ' + record.gallery_id);
      return record.gallery_id === this.id;
    }, this));
  };
  return Gallery;
})();