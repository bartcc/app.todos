var $, Model;
if (typeof Spine === "undefined" || Spine === null) {
  Spine = require("spine");
}
$ = Spine.$;
Model = Spine.Model;
Model.Base = {
  extended: function() {
    var Extend;
    Extend = {
      counter: 0
    };
    return this.extend(Extend);
  }
};
