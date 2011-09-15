var Director;
var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
Director = (function() {
  __extends(Director, Spine.Model);
  function Director() {
    Director.__super__.constructor.apply(this, arguments);
  }
  Director.configure("Director", "name", "description");
  Director.extend(Spine.Model.Ajax);
  Director.extend(Spine.Model.Filter);
  Director.selectAttributes = ["name", "description"];
  Director.url = function() {
    return '' + base_url + this.className.toLowerCase() + 's';
  };
  Director.nameSort = function(a, b) {
    var aa, bb, _ref, _ref2;
    aa = (_ref = (a || '').first_name) != null ? _ref.toLowerCase() : void 0;
    bb = (_ref2 = (b || '').first_name) != null ? _ref2.toLowerCase() : void 0;
    if (aa === bb) {
      return 0;
    } else if (aa < bb) {
      return -1;
    } else {
      return 1;
    }
  };
  Director.fromJSON = function(objects) {
    return this.__super__.constructor.fromJSON.call(this, objects.json);
  };
  Director.prototype.selectAttributes = function() {
    var attr, result, _i, _len, _ref;
    result = {};
    _ref = this.constructor.selectAttributes;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      attr = _ref[_i];
      result[attr] = this[attr];
    }
    return result;
  };
  Director.prototype.fullName = function() {
    if (!(this.first_name + this.last_name)) {
      return;
    }
    return this.first_name + ' ' + this.last_name;
  };
  Director.prototype.updateChangedAttributes = function(atts) {
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
  return Director;
})();