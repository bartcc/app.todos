var $, GalleryList;
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
GalleryList = (function() {
  __extends(GalleryList, Spine.Controller);
  GalleryList.extend(Spine.Controller.Drag);
  GalleryList.prototype.events = {
    'click .item': 'click',
    'dblclick .item': 'dblclick'
  };
  function GalleryList() {
    this.select = __bind(this.select, this);    GalleryList.__super__.constructor.apply(this, arguments);
  }
  GalleryList.prototype.change = function() {
    console.log('GalleryList::change');
    return Spine.trigger('show:albums');
  };
  GalleryList.prototype.render = function(items) {
    console.log('GalleryList::render');
    this.html(this.template(items));
    return this.el;
  };
  GalleryList.prototype.select = function(item) {
    Gallery.current(item);
    this.exposeSelection(item);
    Spine.trigger('gallery:exposeSelection', Gallery.record);
    return Spine.trigger('change:selectedGallery', Gallery.record);
  };
  GalleryList.prototype.exposeSelection = function(item) {
    var el;
    console.log('GalleryList::exposeSelection');
    this.deselect();
    el = this.children().forItem(item);
    return el.addClass("active");
  };
  GalleryList.prototype.click = function(e) {
    var item;
    console.log('GalleryList::click');
    item = $(e.currentTarget).item();
    this.select(item);
    e.stopPropagation();
    e.preventDefault();
    return false;
  };
  GalleryList.prototype.dblclick = function(e) {
    console.log('GalleryList::dblclick');
    this.change();
    e.stopPropagation();
    e.preventDefault();
    return false;
  };
  return GalleryList;
})();
if (typeof module !== "undefined" && module !== null) {
  module.exports = GalleryList;
}