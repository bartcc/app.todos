jQuery(function() {
  var Contact;
  Contact = Spine.Model.setup("Contact", "first_name", "last_name", "email", "mobile", "work", "address", "notes");
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
    }
  });
  return window.Contact = Contact;
});