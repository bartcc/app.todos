var $;
var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
if (typeof Spine === "undefined" || Spine === null) {
  Spine = require("spine");
}
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
      min: function() {
        return 20;
      },
      max: function() {
        return 300;
      },
      tol: 10,
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
    this.currentDim = options.initSize.call(this);
    if (options.disabled) {
      this.disableDrag();
    }
    this.goSleep = __bind(function() {
      this.sleep = true;
      return options.goSleep();
    }, this);
    this.awake = __bind(function() {
      this.sleep = false;
      return options.awake();
    }, this);
    return el.draggable({
      create: __bind(function(e, ui) {
        return this.el.css({
          position: 'inherit'
        });
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
          if (!this.sleep) {
            if (d >= _min && d <= _max) {
              return d;
            }
            if (d < _min) {
              if (!this.el.draggable("option", "disabled")) {
                this.goSleep();
              }
              return _min;
            }
            if (d > _max) {
              return _max;
            }
          } else if (d >= _min) {
            if (!this.el.draggable("option", "disabled")) {
              this.awake();
            }
            return d;
          }
        }, this));
      }, this),
      stop: __bind(function(e, ui) {
        if (!this.el.draggable("option", "disabled")) {
          if (!this.sleep) {
            return this.currentDim = $(ui.helper)[dim]();
          }
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
        return this.last = controller;
      }
    }
    return false;
  },
  active: function() {
    return this.hasActive();
  },
  lastActive: function() {
    return this.last || this.controllers[0];
  },
  externalUI: function(controller) {
    var activeController;
    activeController = controller || this.lastActive();
    return $(activeController.externalUI, this.external.el);
  }
});
Spine.Manager.extend({
  deactivate: function() {
    console.log('deactivate');
    return this.constructor.apply(this, arguments);
  }
});
