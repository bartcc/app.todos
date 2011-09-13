var Filter;
Filter = function() {
  var extend, include;
  extend = {
    filter: function(query) {
      if (!query) {
        return this.all();
      }
      return this.select(function(item) {
        return item.select(query);
      });
    }
  };
  include = {
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
  return {
    extended: function() {
      this.extend(extend);
      return this.include(include);
    }
  };
};
Spine.Model.Filter = Filter();