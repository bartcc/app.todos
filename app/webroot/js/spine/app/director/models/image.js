var Bitmap;
var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
Bitmap = (function() {
  __extends(Bitmap, Spine.Model);
  function Bitmap() {
    Bitmap.__super__.constructor.apply(this, arguments);
  }
  Bitmap.configure("Bitmap", 'title', "description", "exif", 'user_id');
  Bitmap.extend(Spine.Model.Ajax);
  Bitmap.extend(Spine.Model.AjaxRelations);
  Bitmap.extend(Spine.Model.Filter);
  Bitmap.extend(Spine.Model.Extender);
  Bitmap.selectAttributes = ['title', "description", "exif", 'user_id'];
  Bitmap.foreignModels = function() {
    return {
      'Album': {
        className: 'Album',
        joinTable: 'AlbumsBitmap',
        foreignKey: 'bitmap_id',
        associationForeignKey: 'album_id'
      }
    };
  };
  Bitmap.url = function() {
    return '' + base_url + this.className.toLowerCase() + 's';
  };
  Bitmap.nameSort = function(a, b) {
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
  Bitmap.prototype.selectAttributes = function() {
    var attr, result, _i, _len, _ref;
    result = {};
    _ref = this.constructor.selectAttributes;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      attr = _ref[_i];
      result[attr] = this[attr];
    }
    return result;
  };
  return Bitmap;
})();
Spine.Model.Bitmap = Bitmap;