var $, SidebarView;
var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
}, __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
if (typeof Spine !== "undefined" && Spine !== null) {
  Spine;
} else {
  Spine = require("spine");
};
$ = Spine.$;
SidebarView = (function() {
  __extends(SidebarView, Spine.Controller);
  SidebarView.prototype.elements = {
    ".items": "items",
    "input": "input"
  };
  SidebarView.prototype.events = {
    "click button": "create",
    "keyup input": "filter",
    "dblclick .draghandle": 'toggleDraghandle'
  };
  SidebarView.prototype.template = function(items) {
    return $("#galleriesTemplate").tmpl(items);
  };
  function SidebarView() {
    SidebarView.__super__.constructor.apply(this, arguments);
    Spine.App.galleryList = this.list = new Spine.GalleryList({
      el: this.items,
      template: this.template
    });
    Gallery.bind("refresh", this.proxy(this.loadJoinTables));
    Gallery.bind("refresh change", this.proxy(this.render));
  }
  SidebarView.prototype.loadJoinTables = function() {
    return GalleriesAlbum.records = Gallery.joinTableRecords;
  };
  SidebarView.prototype.filter = function() {
    console.log('Sidebar::filter');
    this.query = this.input.val();
    return this.render();
  };
  SidebarView.prototype.render = function(item) {
    var items;
    console.log('Sidebar::render');
    items = Gallery.filter(this.query);
    items = items.sort(Gallery.nameSort);
    return this.list.render(items, item);
  };
  SidebarView.prototype.newAttributes = function() {
    return {
      name: '',
      author: ''
    };
  };
  SidebarView.prototype.create = function(e) {
    var gallery;
    e.preventDefault();
    this.preserveEditorOpen('gallery', App.albumsShowView.btnGallery);
    gallery = new Gallery(this.newAttributes());
    return gallery.save();
  };
  SidebarView.prototype.toggleDraghandle = function() {
    var width;
    width = __bind(function() {
      var max, min;
      width = this.el.width();
      max = App.vmanager.max();
      min = App.vmanager.min;
      if (width >= min && width < max - 20) {
        return max + "px";
      } else {
        return min + 'px';
      }
    }, this);
    return this.el.animate({
      width: width()
    }, 400);
  };
  return SidebarView;
})();
if (typeof module !== "undefined" && module !== null) {
  module.exports = SidebarView;
}