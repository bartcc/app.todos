var $, PhotosList;
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
PhotosList = (function() {
  __extends(PhotosList, Spine.Controller);
  PhotosList.prototype.elements = {
    '.thumbnail': 'thumb'
  };
  PhotosList.prototype.events = {
    'click .item': "click",
    'dblclick .item': 'dblclick',
    'mousemove .item': 'infoUp',
    'mouseleave  .item': 'infoBye',
    'dragstart .item': 'stopInfo'
  };
  PhotosList.prototype.selectFirst = true;
  function PhotosList() {
    this.size = __bind(this.size, this);
    this.sliderStart = __bind(this.sliderStart, this);
    this.stopInfo = __bind(this.stopInfo, this);
    this.infoBye = __bind(this.infoBye, this);
    this.infoUp = __bind(this.infoUp, this);
    this.closeInfo = __bind(this.closeInfo, this);
    this.callback = __bind(this.callback, this);    PhotosList.__super__.constructor.apply(this, arguments);
    Spine.bind('photo:exposeSelection', this.proxy(this.exposeSelection));
    Photo.bind('update', this.proxy(this.update));
    Photo.bind("ajaxError", Photo.customErrorHandler);
    Photo.bind('uri', this.proxy(this.uri));
  }
  PhotosList.prototype.change = function() {
    return console.log('PhotosList::change');
  };
  PhotosList.prototype.select = function(item, e) {
    console.log('PhotosList::select');
    this.exposeSelection();
    this.current = item;
    return Spine.trigger('change:selectedPhoto', item);
  };
  PhotosList.prototype.render = function(items, mode) {
    if (mode == null) {
      mode = 'html';
    }
    console.log('PhotosList::render');
    if (Album.record) {
      if (items.length) {
        this[mode](this.template(items));
        if (mode !== 'append') {
          this.exposeSelection();
        }
        this.uri(items, mode);
        return this.el;
      } else {
        return this.html('<label class="invite"><span class="enlightened">This album has no images.</span></label>');
      }
    } else {
      return this.renderAll();
    }
  };
  PhotosList.prototype.renderAll = function() {
    var items;
    console.log('PhotosList::renderAll');
    items = Photo.all();
    if (items.length) {
      this.html(this.template(items));
      this.exposeSelection();
      this.uri(items, 'html');
      return this.el;
    }
  };
  PhotosList.prototype.update = function(item) {
    var active, backgroundImage, css, el, tb, tmplItem;
    console.log('PhotosList::update');
    el = __bind(function() {
      return this.children().forItem(item);
    }, this);
    tb = function() {
      return $('.thumbnail', el());
    };
    backgroundImage = tb().css('backgroundImage');
    css = tb().attr('style');
    active = el().hasClass('active');
    tmplItem = el().tmplItem();
    tmplItem.tmpl = $("#photosTemplate").template();
    tmplItem.update();
    tb().attr('style', css);
    el().toggleClass('active', active);
    return this.refreshElements();
  };
  PhotosList.prototype.thumbSize = function(width, height) {
    if (width == null) {
      width = this.parent.thumbSize;
    }
    if (height == null) {
      height = this.parent.thumbSize;
    }
    return {
      width: width,
      height: height
    };
  };
  PhotosList.prototype.uri = function(items, mode) {
    console.log('PhotosList::uri');
    this.size(this.parent.sOutValue);
    if (Album.record) {
      return Album.record.uri(this.thumbSize(), mode, __bind(function(xhr, record) {
        return this.callback(items, xhr);
      }, this));
    } else {
      return Photo.uri(this.thumbSize(), mode, __bind(function(xhr, record) {
        return this.callback(items, xhr);
      }, this));
    }
  };
  PhotosList.prototype.callback = function(items, json) {
    var ele, img, item, jsn, searchJSON, src, _i, _len, _results;
    console.log('PhotosList::callback');
    searchJSON = function(id) {
      var itm, _i, _len;
      for (_i = 0, _len = json.length; _i < _len; _i++) {
        itm = json[_i];
        if (itm[id]) {
          return itm[id];
        }
      }
    };
    _results = [];
    for (_i = 0, _len = items.length; _i < _len; _i++) {
      item = items[_i];
      jsn = searchJSON(item.id);
      _results.push(jsn ? (ele = this.children().forItem(item), src = jsn.src, img = new Image, img.element = ele, img.onload = this.imageLoad, img.src = src) : void 0);
    }
    return _results;
  };
  PhotosList.prototype.imageLoad = function() {
    var css;
    css = 'url(' + this.src + ')';
    return $('.thumbnail', this.element).css({
      'backgroundImage': css,
      'backgroundPosition': 'center, center',
      'backgroundSize': '100%'
    });
  };
  PhotosList.prototype.exposeSelection = function() {
    var current, el, id, item, list, _i, _len;
    console.log('PhotosList::exposeSelection');
    this.deselect();
    list = Album.selectionList();
    for (_i = 0, _len = list.length; _i < _len; _i++) {
      id = list[_i];
      if (Photo.exists(id)) {
        item = Photo.find(id);
        el = this.children().forItem(item);
        el.addClass("active");
      }
    }
    current = list.length === 1 ? list[0] : void 0;
    return Photo.current(current);
  };
  PhotosList.prototype.click = function(e) {
    var item;
    console.log('PhotosList::click');
    item = $(e.currentTarget).item();
    item.addRemoveSelection(this.isCtrlClick(e));
    Spine.trigger('change:toolbar', 'Photos', App.showView.initSlider);
    this.select(item, e);
    e.stopPropagation();
    e.preventDefault();
    return false;
  };
  PhotosList.prototype.dblclick = function(e) {
    console.log('PhotosList::dblclick');
    Spine.trigger('show:photo', this.current);
    e.stopPropagation();
    e.preventDefault();
    return false;
  };
  PhotosList.prototype.closeInfo = function(e) {
    this.el.click();
    e.stopPropagation();
    e.preventDefault();
    return false;
  };
  PhotosList.prototype.initSelectable = function() {
    var options;
    options = {
      helper: 'clone'
    };
    return this.el.selectable();
  };
  PhotosList.prototype.infoUp = function(e) {
    e.stopPropagation();
    e.preventDefault();
    this.info.up(e);
    return false;
  };
  PhotosList.prototype.infoBye = function(e) {
    e.stopPropagation();
    e.preventDefault();
    this.info.bye();
    return false;
  };
  PhotosList.prototype.stopInfo = function(e) {
    return this.info.bye();
  };
  PhotosList.prototype.sliderStart = function() {
    return console.log(this.thumb.length);
  };
  PhotosList.prototype.size = function(val, bg) {
    if (bg == null) {
      bg = 'none';
    }
    return this.thumb.css({
      'height': val + 'px',
      'width': val + 'px',
      'backgroundSize': bg
    });
  };
  return PhotosList;
})();
if (typeof module !== "undefined" && module !== null) {
  module.exports = PhotosList;
}