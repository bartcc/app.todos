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
    if (el.is(':visible')) {
      $('input', el).first().focus().select();
    }
    return el;
  },
  panelIsActive: function(controller) {
    return App[controller].isActive();
  },
  isCtrlClick: function(e) {
    if (!e) {
      return;
    }
    return (e != null ? e.metaKey : void 0) || (e != null ? e.ctrlKey : void 0) || (e != null ? e.altKey : void 0);
  },
  children: function(sel) {
    return this.el.children(sel);
  },
  deselect: function() {
    return this.el.deselect();
  },
  sortable: function(type) {
    return this.el.sortable(type);
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
