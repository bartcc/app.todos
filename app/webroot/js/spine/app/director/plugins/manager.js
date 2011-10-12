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
    this.el.draggable('disable');
    return !this.el.draggable("option", "disabled");
  },
  enableDrag: function() {
    this.el.draggable('enable');
    return !this.el.draggable("option", "disabled");
  },
  initDrag: function(el, opts) {
    var defaults, dim, max, min, options, ori, rev;
    if (!el) {
      return;
    }
    this.el = el;
    defaults = {
      initSize: function() {
        return 500;
      },
      disabled: true,
      axis: 'x',
      min: 20,
      max: function() {
        return 300;
      },
      handle: '.draghandle',
      goSleep: function() {},
      awake: function() {}
    };
    options = $.extend({}, defaults, opts);
    ori = options.axis === 'y' ? 'top' : 'left';
    dim = options.axis === 'y' ? 'height' : 'width';
    rev = options.axis === 'y' ? 1 : -1;
    min = options.min;
    max = options.max;
    return el.draggable({
      create: __bind(function(e, ui) {
        this.el.css({
          position: 'inherit'
        });
        if (options.disabled) {
          this.disableDrag();
        }
        this.currentDim = options.initSize.call(this);
        this.goSleep = options.goSleep;
        this.awake = options.awake;
        this.min = min;
        return this.max = max;
      }, this),
      axis: options.axis,
      handle: options.handle,
      start: __bind(function(e, ui) {
        return this.currentDim = $(ui.helper)[dim]();
      }, this),
      drag: __bind(function(e, ui) {
        var _cur, _max, _min, _ori, _pos;
        _ori = ui.originalPosition[ori];
        _pos = ui.position[ori];
        _cur = this.currentDim;
        _max = max.call(this);
        _min = min.call(this);
        return $(ui.helper)[dim](__bind(function() {
          var d;
          d = (_cur + _ori) - (_pos * rev);
          if (d >= _min && d <= _max) {
            return d;
          }
          if (d < _min) {
            if (!this.el.draggable("option", "disabled")) {
              options.goSleep();
            }
            return _min;
          }
          if (d > _max) {
            if (!this.el.draggable("option", "disabled")) {
              options.awake();
            }
            return _max;
          }
        }, this));
      }, this),
      stop: __bind(function(e, ui) {
        if (!this.el.draggable("option", "disabled")) {
          return this.currentDim = $(ui.helper)[dim]();
        }
      }, this)
    });
  },
  hasActive: function() {
    var controller, _i, _len, _ref;
    _ref = this.controllers;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      controller = _ref[_i];
      if (controller.isActive()) {
        return true;
      }
    }
    return false;
  }
});
Spine.Manager.extend({
  deactivate_: function() {
    console.log('deactivate');
    return this.constructor.apply(this, arguments);
  }
});