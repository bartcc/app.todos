var $, PhotoList;
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
PhotoList = (function() {
  __extends(PhotoList, Spine.Controller);
  PhotoList.prototype.events = {
    'click .close': "closeInfo",
    'click .item': "click",
    'dblclick .item': 'dblclick',
    'mousemove .item': 'previewUp',
    'mouseleave  .item': 'previewBye',
    'dragstart .item': 'stopPreview'
  };
  PhotoList.prototype.selectFirst = true;
  function PhotoList() {
    this.stopPreview = __bind(this.stopPreview, this);
    this.previewBye = __bind(this.previewBye, this);
    this.previewUp = __bind(this.previewUp, this);
    this.closeInfo = __bind(this.closeInfo, this);
    this.callback = __bind(this.callback, this);    PhotoList.__super__.constructor.apply(this, arguments);
    Spine.bind('photo:exposeSelection', this.proxy(this.exposeSelection));
    Photo.bind('update', this.proxy(this.update));
    Photo.bind("ajaxError", Photo.customErrorHandler);
    Photo.bind('uri', this.proxy(this.uri));
  }
  PhotoList.prototype.change = function(item, e) {
    this.exposeSelection(e);
    this.current = item;
    return Spine.trigger('change:selectedPhoto', item);
  };
  PhotoList.prototype.render = function(items, album, mode) {
    if (mode == null) {
      mode = 'html';
    }
    console.log('PhotoList::render');
    if (album == null) {
      album = Album.record;
    }
    if (album) {
      if (items.length) {
        this[mode](this.template(items));
        this.exposeSelection();
        this.uri(album, items, mode);
        this.change();
        return this.el;
      } else {
        return this.html('<label class="invite"><span class="enlightened">This album has no images.</span></label>');
      }
    } else {
      return this.html('<label class="invite"><span class="enlightened">Albums can only be viewed when linked up with a gallery.<br>To do so drag and drop it over a gallery and try again.</span></label>');
    }
  };
  PhotoList.prototype.renderItem = function(item) {
    var backgroundImage, el, isActive, style, tb, tmplItem;
    el = __bind(function() {
      return this.children().forItem(item);
    }, this);
    tb = function() {
      return $('.thumbnail', el());
    };
    backgroundImage = tb().css('backgroundImage');
    style = el().prop('style');
    isActive = el().hasClass('active');
    tmplItem = el().tmplItem();
    tmplItem.tmpl = $("#photosTemplate").template();
    tmplItem.update();
    tb().css('backgroundImage', backgroundImage);
    return el().toggleClass('active', isActive);
  };
  PhotoList.prototype.update = function(item) {
    return this.renderItem(item);
  };
  PhotoList.prototype.previewSize = function(width, height) {
    if (width == null) {
      width = 140;
    }
    if (height == null) {
      height = 140;
    }
    return {
      width: width,
      height: height
    };
  };
  PhotoList.prototype.uri = function(album, items, mode) {
    console.log('PhotoList::uri');
    return album.uri(this.previewSize(), mode, __bind(function(xhr, record) {
      return this.callback(items, xhr);
    }, this));
  };
  PhotoList.prototype.callback = function(items, json) {
    var ele, img, item, jsn, searchJSON, src, _i, _len, _results;
    console.log('PhotoList::callback');
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
      _results.push(jsn ? (ele = this.children().forItem(item), src = jsn.src, img = new Image, img.element = ele, img.src = src, img.onload = this.imageLoad) : void 0);
    }
    return _results;
  };
  PhotoList.prototype.imageLoad = function() {
    var css;
    css = 'url(' + this.src + ')';
    return $('.thumbnail', this.element).css({
      'backgroundImage': css,
      'backgroundPosition': 'center, center'
    });
  };
  PhotoList.prototype.exposeSelection = function(e) {
    var current, el, id, item, list, _i, _len;
    console.log('PhotoList::exposeSelection');
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
  PhotoList.prototype.click = function(e) {
    var item;
    console.log('PhotoList::click');
    item = $(e.currentTarget).item();
    item.addRemoveSelection(Album, this.isCtrlClick(e));
    if (App.hmanager.hasActive()) {
      this.openPanel('photo', App.showView.btnPhoto);
    }
    App.showView.trigger('change:toolbar', 'Photo');
    this.change(item, e);
    e.stopPropagation();
    e.preventDefault();
    return false;
  };
  PhotoList.prototype.dblclick = function(e) {
    var item;
    console.log('PhotoList::dblclick');
    item = $(e.currentTarget).item();
    this.change(item);
    Spine.trigger('show:photo', item);
    e.stopPropagation();
    e.preventDefault();
    return false;
  };
  PhotoList.prototype.closeInfo = function(e) {
    this.el.click();
    e.stopPropagation();
    e.preventDefault();
    return false;
  };
  PhotoList.prototype.initSelectable = function() {
    var options;
    options = {
      helper: 'clone'
    };
    return this.el.selectable();
  };
  PhotoList.prototype.previewUp = function(e) {
    e.stopPropagation();
    e.preventDefault();
    this.preview.up(e);
    return false;
  };
  PhotoList.prototype.previewBye = function(e) {
    e.stopPropagation();
    e.preventDefault();
    this.preview.bye();
    return false;
  };
  PhotoList.prototype.stopPreview = function(e) {
    return this.preview.bye();
  };
  return PhotoList;
})();
if (typeof module !== "undefined" && module !== null) {
  module.exports = PhotoList;
}