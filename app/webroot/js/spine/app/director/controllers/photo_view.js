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
    '.preview': 'previewEl',
    '.items': 'items',
    '.items .item': 'item'
  };
  PhotoView.prototype.events = {
    'mousemove .item': 'previewUp',
    'mouseleave  .item': 'previewBye',
    'dragstart .item': 'stopPreview'
  };
  PhotoView.prototype.template = function(item) {
    return $('#photoTemplate').tmpl(item);
  };
  PhotoView.prototype.previewTemplate = function(item) {
    return $('#photoPreviewTemplate').tmpl(item);
  };
  function PhotoView() {
    this.stopPreview = __bind(this.stopPreview, this);
    this.previewBye = __bind(this.previewBye, this);
    this.previewUp = __bind(this.previewUp, this);
    this.callback = __bind(this.callback, this);    PhotoView.__super__.constructor.apply(this, arguments);
    this.preview = new Preview({
      el: this.previewEl,
      template: this.previewTemplate
    });
    Spine.bind('show:photo', this.proxy(this.show));
    AlbumsPhoto.bind('destroy', this.proxy(this.destroy));
    this.img = new Image;
    this.img.onload = this.imageLoad;
  }
  PhotoView.prototype.change = function(item, changed) {
    console.log('PhotoView::change');
    return Photo.activeRecord = this.current = item;
  };
  PhotoView.prototype.render = function(item, mode) {
    console.log('PhotoView::render');
    this.el.data(item);
    this.items.html(this.template(item));
    this.renderHeader(item);
    this.uri(item);
    return this.change(item);
  };
  PhotoView.prototype.renderHeader = function(item) {
    return this.header.change(item);
  };
  PhotoView.prototype.destroy = function(item) {
    var photoEl;
    console.log('PhotoView::destroy');
    photoEl = this.items.children().forItem(this.current);
    photoEl.remove();
    delete this.current;
    return this.renderHeader();
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
  PhotoView.prototype.previewUp = function(e) {
    e.stopPropagation();
    e.preventDefault();
    this.preview.up(e);
    return false;
  };
  PhotoView.prototype.previewBye = function(e) {
    e.stopPropagation();
    e.preventDefault();
    this.preview.bye();
    return false;
  };
  PhotoView.prototype.stopPreview = function(e) {
    return this.preview.bye();
  };
  PhotoView.prototype.show = function(item) {
    App.showView.trigger('change:toolbar', 'Photo');
    Spine.trigger('change:canvas', this);
    return this.render(item);
  };
  return PhotoView;
})();
if (typeof module !== "undefined" && module !== null) {
  module.exports = PhotoView;
}