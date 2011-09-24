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
  GalleryList.prototype.selectFirst = true;
  function GalleryList() {
    this.change = __bind(this.change, this);    GalleryList.__super__.constructor.apply(this, arguments);
    this.bind("change", this.change);
    Gallery.bind("change", this.proxy(this.change));
  }
  GalleryList.prototype.template = function() {
    return arguments[0];
  };
  GalleryList.prototype.change = function(item, mode, shiftKey) {
    var changed, newId, oldId, _ref;
    console.log('GalleryList::change');
    if (item) {
      oldId = (_ref = this.current) != null ? _ref.id : void 0;
      newId = item.id;
      changed = !(oldId === newId);
      this.children().removeClass("active");
      if (!shiftKey) {
        this.current = item;
        this.children().forItem(this.current).addClass("active");
      } else {
        this.current = null;
      }
      Gallery.current(this.current);
      return Spine.App.trigger('change:selectedGallery', this.current, mode);
    }
  };
  GalleryList.prototype.render = function(items) {
    console.log('GalleryList::render');
    if (items) {
      this.items = items;
    }
    this.html(this.template(this.items));
    this.change(this.current);
    if (this.selectFirst) {
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
    this.stopEvent(e);
    console.log('GalleryList::click');
    item = $(e.target).item();
    return this.change(item, 'show', e.shiftKey);
  };
  GalleryList.prototype.edit = function(e) {
    var item;
    console.log('GalleryList::edit');
    item = $(e.target).item();
    return this.change(item, 'edit');
  };
  GalleryList.prototype.stopEvent = function(e) {
    if (e.stopPropagation) {
      e.stopPropagation();
      return e.preventDefault();
    } else {
      return e.cancelBubble = true;
    }
  };
  return GalleryList;
})();
if (typeof module !== "undefined" && module !== null) {
  module.exports = Spine.GalleryList;
}