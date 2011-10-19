var $;
if (typeof Spine === "undefined" || Spine === null) {
  Spine = require("spine");
}
$ = Spine.$;
Spine.Controller.include({
  focusFirstInput: function(el) {
    if (!el) {
      return;
    }
    alert('focusFirstInput');
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
  empty: function() {
    console.log('empty');
    return this.constructor.apply(this, arguments);
  }
});