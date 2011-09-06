var $;
var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
if (typeof Spine !== "undefined" && Spine !== null) {
  Spine;
} else {
  Spine = require("spine");
};
$ = Spine.$;
Spine.Manager.include({
  disableDrag: function() {
    return this.el.draggable('disable');
  },
  enableDrag: function() {
    return this.el.draggable('enable');
  },
  alive: function(el, opts) {
    var defaults, dim, max, min, options, ori;
    if (!el) {
      return;
    }
    this.el = el;
    defaults = {
      height: function() {
        return 500;
      },
      axis: 'x',
      min: 200,
      max: function() {
        return 500;
      },
      handle: '.draghandle'
    };
    options = $.extend({}, defaults, opts);
    ori = options.axis === 'y' ? 'top' : 'left';
    dim = options.axis === 'y' ? 'height' : 'width';
    max = options.max.call(this);
    min = options.min;
    return el.draggable({
      create: __bind(function(e, ui) {
        this.el.css({
          position: 'inherit'
        });
        this.disableDrag();
        return this.currentDim = options.height.call(this);
      }, this),
      axis: options.axis,
      handle: options.handle,
      start: __bind(function(e, ui) {
        return this.currentDim = $(ui.helper)[dim]();
      }, this),
      drag: __bind(function(e, ui) {
        var _cur, _ori, _pos;
        _ori = ui.originalPosition[ori];
        _pos = ui.position[ori];
        _cur = this.currentDim;
        return $(ui.helper)[dim](function() {
          var h;
          h = _cur - _pos + _ori;
          if (h >= min && h <= max) {
            return h;
          }
          if (h < min) {
            return min;
          }
          if (h > max) {
            return max;
          }
        });
      }, this),
      stop: __bind(function(e, ui) {
        return this.currentDim = $(ui.helper)[dim]();
      }, this)
    });
  }
});
Spine.Manager.extend({
  notify: function(t) {}
});