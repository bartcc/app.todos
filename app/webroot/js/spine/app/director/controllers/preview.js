var $, Preview;
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
Preview = (function() {
  __extends(Preview, Spine.Controller);
  Preview.prototype.events = {
    'dragstart': 'byebye'
  };
  function Preview() {
    this.position = __bind(this.position, this);    Preview.__super__.constructor.apply(this, arguments);
  }
  Preview.prototype.render = function(item) {
    this.html(this.template(item));
    return this.el;
  };
  Preview.prototype.up = function(e) {
    var el;
    if (!this.current) {
      el = $(e.currentTarget);
      this.current = el.item();
      this.render(this.current).show();
    }
    return this.position(e);
  };
  Preview.prototype.bye = function() {
    if (!this.current) {
      return;
    }
    this.el.hide();
    return this.current = null;
  };
  Preview.prototype.byebye = function() {
    return alert('byebye');
  };
  Preview.prototype.position = function(e) {
    var h, maxx, maxy, minx, posx, posy, preview_h, preview_w, t, w;
    preview_h = this.el.innerHeight();
    preview_w = this.el.innerWidth();
    w = $(window).width();
    h = $(window).height();
    t = $(window).scrollTop();
    posx = e.pageX + 10;
    posy = e.pageY;
    maxx = posx + preview_w;
    minx = posx - preview_w;
    maxy = posy + preview_h;
    if (maxx >= w) {
      posx = e.pageX - (preview_w + 10);
    }
    if (maxy >= (h + t)) {
      posy = e.pageY - preview_h;
    }
    return this.el.css({
      top: posy + 'px',
      left: posx + 'px',
      display: 'block'
    });
  };
  return Preview;
})();
if (typeof module !== "undefined" && module !== null) {
  module.exports = Preview;
}