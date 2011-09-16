var Gallerie;
var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
Gallerie = (function() {
  __extends(Gallerie, Spine.Model);
  function Gallerie() {
    Gallerie.__super__.constructor.apply(this, arguments);
  }
  Gallerie.configure("Gallerie", "name", 'author', "description");
  Gallerie.extend(Spine.Model.Ajax);
  Gallerie.extend(Spine.Model.Filter);
  Gallerie.selectAttributes = ["name", 'author', "description"];
  Gallerie.url = function() {
    return '' + base_url + this.className.toLowerCase() + 's';
  };
  Gallerie.nameSort = function(a, b) {
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
  Gallerie.fromJSON = function(objects) {
    return this.__super__.constructor.fromJSON.call(this, objects.json);
  };
  Gallerie.prototype.selectAttributes = function() {
    var attr, result, _i, _len, _ref;
    result = {};
    _ref = this.constructor.selectAttributes;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      attr = _ref[_i];
      result[attr] = this[attr];
    }
    return result;
  };
  Gallerie.prototype.updateChangedAttributes = function(atts) {
    var invalid, key, origAtts, value;
    origAtts = this.attributes();
    for (key in atts) {
      value = atts[key];
      if (origAtts[key] !== value) {
        invalid = true;
        this[key] = value;
      }
    }
    if (invalid) {
      return this.save();
    }
  };
  return Gallerie;
})();