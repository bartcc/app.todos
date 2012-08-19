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
    'click': 'clickDeselect',
    'click .item': 'click',
    'dblclick .item': 'zoom',
    'click .icon-set .delete': 'deleteGallery',
    'click .icon-set .zoom': 'zoom',
    'mousemove .item': 'infoUp',
    'mouseleave .item': 'infoBye'
  };
  function GalleriesList() {
    this.infoBye = __bind(this.infoBye, this);
    this.infoUp = __bind(this.infoUp, this);
    this.select = __bind(this.select, this);    GalleriesList.__super__.constructor.apply(this, arguments);
    Spine.bind('change:selectedGallery', this.proxy(this.change));
  }
  GalleriesList.prototype.change = function(item) {
    console.log('GalleryList::change');
    return this.exposeSelection(item);
  };
  GalleriesList.prototype.render = function(items) {
    console.log('GalleryList::render');
    this.html(this.template(items));
    return this.el;
  };
  GalleriesList.prototype.select = function(item) {
    Spine.trigger('gallery:activate', item);
    return App.showView.trigger('change:toolbarOne', ['Default']);
  };
  GalleriesList.prototype.exposeSelection = function(item) {
    var el;
    console.log('GalleryList::exposeSelection');
    this.deselect();
    if (item) {
      el = this.children().forItem(item);
      el.addClass("active");
      App.showView.trigger('change:toolbarOne');
    }
    return Spine.trigger('gallery:exposeSelection', item);
  };
  GalleriesList.prototype.clickDeselect = function(e) {
    return Gallery.current();
  };
  GalleriesList.prototype.click = function(e) {
    var item;
    console.log('GalleryList::click');
    item = $(e.currentTarget).item();
    this.select(item);
    e.stopPropagation();
    return e.preventDefault();
  };
  GalleriesList.prototype.zoom = function(e) {
    var item, _ref;
    console.log('GalleryList::zoom');
    item = $(e.currentTarget).item();
    if ((item != null ? (_ref = item.constructor) != null ? _ref.className : void 0 : void 0) !== 'Gallery') {
      return;
    }
    Gallery.current(item);
    this.navigate('/gallery', Gallery.record.id);
    e.stopPropagation();
    return e.preventDefault();
  };
  GalleriesList.prototype.deleteGallery = function(e) {
    var el, item;
    item = $(e.currentTarget).item();
    el = $(e.currentTarget).parents('.item');
    el.removeClass('in');
    window.setTimeout(function() {
      return Spine.trigger('destroy:gallery', item);
    }, 300);
    e.preventDefault();
    return e.stopPropagation();
  };
  GalleriesList.prototype.infoUp = function(e) {
    var el;
    el = $('.icon-set', $(e.currentTarget)).addClass('in').removeClass('out');
    return e.preventDefault();
  };
  GalleriesList.prototype.infoBye = function(e) {
    var el;
    el = $('.icon-set', $(e.currentTarget)).addClass('out').removeClass('in');
    return e.preventDefault();
  };
  return GalleriesList;
})();
if (typeof module !== "undefined" && module !== null) {
  module.exports = GalleriesList;
}
