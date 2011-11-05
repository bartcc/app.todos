var Photo;
var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
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
    Photo.__super__.constructor.apply(this, arguments);
  }
  Photo.configure("Photo", 'title', "description", 'filesize', 'captured', 'exposure', "iso", 'longitude', 'aperture', 'make', 'model', 'user_id');
  Photo.extend(Spine.Model.Ajax);
  Photo.extend(Spine.Model.AjaxRelations);
  Photo.extend(Spine.Model.Filter);
  Photo.extend(Spine.Model.Extender);
  Photo.selectAttributes = ['title', "description", 'user_id'];
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
  Photo.prototype.select = function(id) {
    var ap, record, _i, _len;
    ap = AlbumsPhoto.filter(id);
    for (_i = 0, _len = ap.length; _i < _len; _i++) {
      record = ap[_i];
      if (record.photo_id === this.id) {
        return true;
      }
    }
  };
  return Photo;
})();
Spine.Model.Photo = Photo;