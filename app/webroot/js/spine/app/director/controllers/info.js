var $, Info;
var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; }, __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
if (typeof Spine === "undefined" || Spine === null) {
  Spine = require("spine");
}
$ = Spine.$;
Info = (function() {
  __extends(Info, Spine.Controller);
  function Info() {
    this.position = __bind(this.position, this);    Info.__super__.constructor.apply(this, arguments);
    this.el.css({
      visibility: 'hidden'
    });
  }
  Info.prototype.render = function(item) {
    this.html(this.template(item));
    return this.el;
  };
  Info.prototype.up = function(e) {
    var el;
    if (!this.current) {
      el = $(e.currentTarget);
      this.current = el.item();
      this.render(this.current).css({
        visibility: 'visible'
      });
    }
    return this.position(e);
  };
  Info.prototype.bye = function() {
    if (!this.current) {
      return;
    }
    this.el.css({
      visibility: 'hidden'
    });
    return this.current = null;
  };
  Info.prototype.position = function(e) {
    var h, info_h, info_w, maxx, maxy, minx, posx, posy, t, w;
    info_h = this.el.innerHeight();
    info_w = this.el.innerWidth();
    w = $(window).width();
    h = $(window).height();
    t = $(window).scrollTop();
    posx = e.pageX + 10;
    posy = e.pageY;
    maxx = posx + info_w;
    minx = posx - info_w;
    maxy = posy + info_h;
    if (maxx >= w) {
      posx = e.pageX - (info_w + 10);
    }
    if (maxy >= (h + t)) {
      posy = e.pageY - info_h;
    }
    return this.el.css({
      top: posy + 'px',
      left: posx + 'px'
    });
  };
  return Info;
})();
if (typeof module !== "undefined" && module !== null) {
  module.exports = Info;
}
