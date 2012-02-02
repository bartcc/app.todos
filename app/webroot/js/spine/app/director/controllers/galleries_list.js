var $, GalleriesList;
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
GalleriesList = (function() {
  __extends(GalleriesList, Spine.Controller);
  GalleriesList.extend(Spine.Controller.Drag);
  GalleriesList.prototype.events = {
    'click .item': 'click',
    'dblclick .item': 'dblclick'
  };
  function GalleriesList() {
    this.select = __bind(this.select, this);    GalleriesList.__super__.constructor.apply(this, arguments);
  }
  GalleriesList.prototype.change = function() {
    console.log('GalleryList::change');
    return Spine.trigger('show:albums');
  };
  GalleriesList.prototype.render = function(items) {
    console.log('GalleryList::render');
    this.html(this.template(items));
    return this.el;
  };
  GalleriesList.prototype.select = function(item) {
    Spine.trigger('change:toolbarOne', ['Gallery']);
    Spine.trigger('gallery:activate');
    return this.exposeSelection(item);
  };
  GalleriesList.prototype.exposeSelection = function(item) {
    var el;
    console.log('GalleryList::exposeSelection');
    this.deselect();
    if (item) {
      el = this.children().forItem(item);
      el.addClass("active");
      Spine.trigger('gallery:exposeSelection', item);
      return Spine.trigger('change:toolbarOne');
    }
  };
  GalleriesList.prototype.click = function(e) {
    var item;
    console.log('GalleryList::click');
    item = $(e.currentTarget).item();
    this.select(Gallery.current(item));
    e.stopPropagation();
    return e.preventDefault();
  };
  GalleriesList.prototype.dblclick = function(e) {
    console.log('GalleryList::dblclick');
    this.change();
    e.stopPropagation();
    return e.preventDefault();
  };
  return GalleriesList;
})();
if (typeof module !== "undefined" && module !== null) {
  module.exports = GalleriesList;
}
