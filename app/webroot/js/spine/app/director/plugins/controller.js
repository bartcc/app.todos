var $;
if (typeof Spine !== "undefined" && Spine !== null) {
  Spine;
} else {
  Spine = require("spine");
};
$ = Spine.$;
Spine.Controller.include({
  focusFirstInput: function(el) {
    if (!el) {
      return;
    }
    if (el.is(':visible')) {
      $('input', el).first().focus().select();
    }
    return el;
  }
});
Spine.Controller.extend({
  empty: function() {
    console.log('empty');
    return this.constructor.apply(this, arguments);
  }
});