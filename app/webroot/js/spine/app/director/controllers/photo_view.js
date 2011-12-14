var $, PhotoView;
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
PhotoView = (function() {
  __extends(PhotoView, Spine.Controller);
  PhotoView.prototype.elements = {
    '.items': 'items',
    '.items .item': 'item'
  };
  PhotoView.prototype.template = function(item) {
    return $('#photoTemplate').tmpl(item);
  };
  function PhotoView() {
    this.callback = __bind(this.callback, this);    PhotoView.__super__.constructor.apply(this, arguments);
    Spine.bind('show:photo', this.proxy(this.show));
    this.img = new Image;
    this.img.onload = this.imageLoad;
  }
  PhotoView.prototype.change = function(item, changed) {
    return console.log('PhotoView::change');
  };
  PhotoView.prototype.render = function(item, mode) {
    console.log('PhotoView::render');
    this.el.data(item);
    this.items.html(this.template(item));
    this.renderHeader(item);
    return this.uri(item);
  };
  PhotoView.prototype.renderHeader = function(item) {
    return this.header.change(item);
  };
  PhotoView.prototype.params = function() {
    return {
      width: 600,
      height: 451,
      square: 2,
      force: false
    };
  };
  PhotoView.prototype.uri = function(item, mode) {
    if (mode == null) {
      mode = 'html';
    }
    console.log('PhotoView::uri');
    return item.uri(this.params(), mode, __bind(function(xhr, record) {
      return this.callback(item, xhr);
    }, this));
  };
  PhotoView.prototype.callback = function(record, json) {
    var jsn, searchJSON;
    console.log('PhotoView::callback');
    searchJSON = function(id) {
      var itm, _i, _len;
      for (_i = 0, _len = json.length; _i < _len; _i++) {
        itm = json[_i];
        if (itm[id]) {
          return itm[id];
        }
      }
    };
    jsn = searchJSON(record.id);
    if (jsn) {
      this.img.element = $('.item', this.items).forItem(record);
      return this.img.src = jsn.src;
    }
  };
  PhotoView.prototype.imageLoad = function() {
    var el, h, img, w;
    el = $('.thumbnail', this.element);
    img = $(this);
    w = this.width;
    h = this.height;
    el.html(img.hide().css({
      'opacity': 0.01
    }));
    el.animate({
      'width': w + 'px',
      'height': h + 'px'
    }, {
      complete: __bind(function() {
        return img.css({
          'opacity': 1
        }).fadeIn();
      }, this)
    });
    return el.css({
      'borderWidth': '1px',
      'borderStyle': 'solid',
      'borderColor': '#575757',
      'backgroundColor': 'rgba(255, 255, 255, 0.5)',
      'backgroundImage': 'none'
    });
  };
  PhotoView.prototype.show = function() {
    return Spine.trigger('change:canvas', this);
  };
  return PhotoView;
})();
if (typeof module !== "undefined" && module !== null) {
  module.exports = PhotoView;
}