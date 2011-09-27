var $, Model;
if (typeof Spine !== "undefined" && Spine !== null) {
  Spine;
} else {
  Spine = require("spine");
};
$ = Spine.$;
Model = Spine.Model;
Singleton.Extender = {
  extended: function() {
    var include;
    include = {
      create: function(params) {
        console.log('create');
        return this.send(params, {
          type: "DELETE",
          data: '',
          url: this.base
        });
      },
      destroy: function(params) {
        console.log('destroy');
        return this.send(params, {
          type: "DELETE",
          url: this.url,
          success: this.blankResponse(params),
          error: this.errorResponse(params)
        });
      },
      update: function(params) {
        console.log('update');
        return this.send(params, {
          type: "PUT",
          data: JSON.stringify(this.records),
          url: this.url,
          success: this.recordResponse(params),
          error: this.errorResponse(params)
        });
      },
      empty: function(atts) {}
    };
    return this.extend(include);
  }
};