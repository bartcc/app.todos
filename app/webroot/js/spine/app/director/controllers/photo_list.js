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
    'click .item': "click",
    'dblclick .item': 'dblclick'
  };
  PhotoList.prototype.selectFirst = true;
  function PhotoList() {
    this.callback = __bind(this.callback, this);    PhotoList.__super__.constructor.apply(this, arguments);
    Spine.bind('photo:exposeSelection', this.proxy(this.exposeSelection));
    Photo.bind("ajaxError", Photo.customErrorHandler);
    Photo.bind('uri', this.proxy(this.uri));
  }
  PhotoList.prototype.render = function(items, album) {
    console.log('PhotoList::render');
    if (album) {
      if (items.length) {
        this.html(this.template(items));
        this.uri(album, items);
        this.change();
        return this.el;
      } else {
        return this.html('<label class="invite"><span class="enlightened">This album has no images.</span></label>');
      }
    } else {
      return this.html('<label class="invite"><span class="enlightened">No album selected.</span></label>');
    }
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
  PhotoList.prototype.uri = function(album, items) {
    console.log('PhotoList::uri');
    return album.uri(this.previewSize(), __bind(function(xhr, record) {
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
  PhotoList.prototype.change = function(item) {
    var list;
    list = Album.selectionList();
    this.children().removeClass("active");
    return this.exposeSelection(list);
  };
  PhotoList.prototype.exposeSelection = function(list) {
    var id, item, _i, _len, _results;
    console.log('PhotoList::exposeSelection');
    _results = [];
    for (_i = 0, _len = list.length; _i < _len; _i++) {
      id = list[_i];
      _results.push(Photo.exists(id) ? (item = Photo.find(id), this.children().forItem(item).addClass("active")) : void 0);
    }
    return _results;
  };
  PhotoList.prototype.children = function(sel) {
    return this.el.children(sel);
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
    this.change(item);
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
  return PhotoList;
})();
if (typeof module !== "undefined" && module !== null) {
  module.exports = PhotoList;
}