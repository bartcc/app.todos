var $;
var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; }, __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
if (typeof Spine !== "undefined" && Spine !== null) {
  Spine;
} else {
  Spine = require("spine");
};
$ = Spine.$;
Spine.GalleryList = (function() {
  __extends(GalleryList, Spine.Controller);
  GalleryList.prototype.events = {
    "dblclick .item": "edit",
    "click .item": "click"
  };
  GalleryList.prototype.elements = {
    '.item': 'item'
  };
  GalleryList.prototype.selectFirst = false;
  function GalleryList() {
    this.change = __bind(this.change, this);    GalleryList.__super__.constructor.apply(this, arguments);
  }
  GalleryList.prototype.template = function() {
    return arguments[0];
  };
  GalleryList.prototype.change = function(item, mode, e) {
    var cmdKey, dblclick;
    console.log('GalleryList::change');
    if (e) {
      cmdKey = e.metaKey || e.ctrlKey;
    }
    if (e) {
      dblclick = e.type === 'dblclick';
    }
    this.children().removeClass("active");
    if (!cmdKey && item) {
      if (mode !== 'update') {
        this.current = item;
      }
      this.children().forItem(this.current).addClass("active");
    } else {
      this.current = false;
    }
    Gallery.current(this.current);
    return Spine.trigger('change:selectedGallery', this.current, mode);
  };
  GalleryList.prototype.render = function(items, item, mode) {
    var record, _i, _len;
    console.log('GalleryList::render');
    console.log(mode);
    for (_i = 0, _len = items.length; _i < _len; _i++) {
      record = items[_i];
      record.count = Album.filter(record.id).length;
    }
    this.items = items;
    this.html(this.template(this.items));
    this.change(item, mode);
    if ((!this.current || this.current.destroyed) && !(mode === 'update')) {
      if (!this.children(".active").length) {
        return this.children(":first").click();
      }
    }
  };
  GalleryList.prototype.children = function(sel) {
    return this.el.children(sel);
  };
  GalleryList.prototype.click = function(e) {
    var item;
    console.log('GalleryList::click');
    item = $(e.target).item();
    return this.change(item, 'show', e);
  };
  GalleryList.prototype.edit = function(e) {
    var item;
    console.log('GalleryList::edit');
    item = $(e.target).item();
    return this.change(item, 'edit', e);
  };
  return GalleryList;
})();
if (typeof module !== "undefined" && module !== null) {
  module.exports = Spine.GalleryList;
}