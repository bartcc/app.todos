var Filter;
Filter = function() {
  var extend, include;
  extend = {
    filter: function(query, func) {
      if (func == null) {
        func = 'select';
      }
      if (!query) {
        return this.all();
      }
      return this.select(function(item) {
        return item[func](query);
      });
    }
  };
  include = {
    select: function(query) {
      var atts, key, value;
      query = query != null ? query.toLowerCase() : void 0;
      atts = (this.selectAttributes || this.attributes).apply(this);
      for (key in atts) {
        value = atts[key];
        value = value != null ? value.toLowerCase() : void 0;
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