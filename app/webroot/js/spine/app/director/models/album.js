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
    this.query_ = __bind(this.query_, this);
    Album.__super__.constructor.apply(this, arguments);
  }
  Album.configure("Album", "name", 'title', "description");
  Album.extend(Spine.Model.Ajax);
  Album.extend(Spine.Model.Filter);
  Album.extend(Spine.Model.Extender);
  Album.selectAttributes = ["name", 'title', "description"];
  Album.url = function() {
    return '' + base_url + this.className.toLowerCase() + 's';
  };
  Album.nameSort = function(a, b) {
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
  Album.joinTables = ['AlbumsImage'];
  Album.parentJoinTable = 'GalleriesAlbum';
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
  Album.prototype.query_ = function() {
    var albums;
    console.log('Album::query');
    albums = window[this.constructor.joinTables].select(__bind(function(record) {
      console.log(this.id + ' / ' + record.gallery_id);
      return record.gallery_id === this.id;
    }, this));
    console.log(albums);
    return albums;
  };
  Album.prototype.select = function(items) {
    return items.album_id === this.id;
  };
  return Album;
})();