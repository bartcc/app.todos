var $;
var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
if (typeof Spine !== "undefined" && Spine !== null) {
  Spine;
} else {
  Spine = require("spine");
};
$ = Spine.$;
Spine.Manager.include({
  sleep: true,
  height: function(func) {
    return this.currentHeight = func.call(this);
  },
  alive: function(el, axis) {
    if (axis == null) {
      axis = 'x';
    }
    if (!el) {
      return;
    }
    this.el = el;
    this.axis = axis === 'y' ? 'top' : 'left';
    return this.el.draggable({
      axis: this.axis,
      handle: '.draghandle',
      start: __bind(function(e, ui) {
        if (this.sleep) {
          return;
        }
        return this.currentHeight = $(ui.helper).height();
      }, this),
      drag: __bind(function(e, ui) {
        var _cur, _ori, _pos;
        if (this.sleep) {
          return;
        }
        _ori = ui.originalPosition[this.axis];
        _pos = ui.position[this.axis];
        _cur = this.currentHeight;
        return $(ui.helper).height(function() {
          return _cur - _pos + _ori;
        });
      }, this),
      stop: __bind(function(e, ui) {
        if (this.sleep) {
          return;
        }
        return this.currentHeight = $(ui.helper).height();
      }, this)
    });
  }
});
Spine.Manager.extend({
  notify: function(t) {}
});