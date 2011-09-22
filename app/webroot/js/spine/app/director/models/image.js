var Image;
var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
Image = (function() {
  __extends(Image, Spine.Model);
  function Image() {
    Image.__super__.constructor.apply(this, arguments);
  }
  Image.configure("Image", 'title', "description", "exif");
  Image.extend(Spine.Model.Ajax);
  Image.extend(Spine.Model.Filter);
  Image.extend(Spine.Model.Extender);
  Image.selectAttributes = ['title', "description", "exif"];
  Image.url = function() {
    return '' + base_url + this.className.toLowerCase() + 's';
  };
  Image.nameSort = function(a, b) {
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
  Image.prototype.selectAttributes = function() {
    var attr, result, _i, _len, _ref;
    result = {};
    _ref = this.constructor.selectAttributes;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      attr = _ref[_i];
      result[attr] = this[attr];
    }
    return result;
  };
  return Image;
})();