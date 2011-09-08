var Contact;
var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
Contact = (function() {
  __extends(Contact, Spine.Model);
  function Contact() {
    Contact.__super__.constructor.apply(this, arguments);
  }
  Contact.configure("Contact", "first_name", "last_name", "email", "mobile", "work", "address", "notes");
  Contact.extend(Spine.Model.Ajax);
  Contact.extend(Spine.Model.Filter);
  Contact.extend({
    selectAttributes: ["first_name", "last_name", "email", "mobile", "work", "address", "notes"],
    url: function() {
      return '' + base_url + this.className.toLowerCase() + 's';
    },
    nameSort: function(a, b) {
      var aa, bb;
      aa = (a || '').first_name.toLowerCase();
      bb = (b || '').first_name.toLowerCase();
      if (aa === bb) {
        return 0;
      } else if (aa < bb) {
        return -1;
      } else {
        return 1;
      }
    }
  });
  Contact.include({
    selectAttributes: function() {
      var attr, result, _i, _len, _ref;
      result = {};
      _ref = this.constructor.selectAttributes;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        attr = _ref[_i];
        result[attr] = this[attr];
      }
      return result;
    },
    fullName: function() {
      if (!(this.first_name + this.last_name)) {
        return;
      }
      return this.first_name + ' ' + this.last_name;
    },
    updateChangedAttributes: function(atts) {
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
    }
  });
  return Contact;
})();