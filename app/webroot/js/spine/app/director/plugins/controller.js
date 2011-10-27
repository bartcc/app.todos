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
  },
  openPanel: function(controller, target) {
    App[controller].deactivate();
    return target.click();
  },
  closePanel: function(controller, target) {
    App[controller].activate();
    return target.click();
  },
  isCtrlClick: function(e) {
    return e.metaKey || e.ctrlKey || e.altKey;
  }
});
Spine.Controller.extend({
  createImage: function(url) {
    var img;
    img = new Image();
    img.src = url;
    return img;
  },
  empty: function() {
    console.log('empty');
    return this.constructor.apply(this, arguments);
  }
});