var Extend, Include, Model;
if (typeof Spine !== "undefined" && Spine !== null) {
  Spine;
} else {
  Spine = require("spine");
};
Model = Spine.Model;
Extend = {
  filter: function(query) {
    if (!query) {
      return this.all();
    }
    return this.select(function(item) {
      return item.select(query);
    });
  }
};
Include = {
  select: function(query) {
    var atts, key, value;
    query = query.toLowerCase();
    atts = (this.selectAttributes || this.attributes).apply(this);
    for (key in atts) {
      value = atts[key];
      value = value.toLowerCase();
      if (!((value != null ? value.indexOf(query) : void 0) === -1)) {
        return true;
      }
    }
    return false;
  }
};
Model.Filter = {
  extended: function() {
    this.extend(Extend);
    return this.include(Include);
  }
};