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
  SidebarView.extend(Spine.Controller.Drag);
  SidebarView.prototype.elements = {
    'input': 'input',
    '.items': 'items',
    '.droppable': 'droppable'
  };
  SidebarView.prototype.events = {
    "click button": "create",
    "keyup input": "filter",
    "dblclick .draghandle": 'toggleDraghandle',
    'dragstart          .items .item': 'dragstart',
    'dragenter          .items .item': 'dragenter',
    'dragover           .items .item': 'dragover',
    'dragleave          .items .item': 'dragleave',
    'drop               .items .item': 'drop',
    'dragend            .items .item': 'dragend'
  };
  SidebarView.prototype.template = function(items) {
    return $("#galleriesTemplate").tmpl(items);
  };
  function SidebarView() {
    SidebarView.__super__.constructor.apply(this, arguments);
    Spine.galleryList = this.list = new Spine.GalleryList({
      el: this.items,
      template: this.template
    });
    Gallery.bind("refresh", this.proxy(this.loadJoinTables));
    Gallery.bind("refresh change", this.proxy(this.render));
    Spine.bind('create:sidebar', this.proxy(this.initDroppables));
    Spine.bind('drag:dropped', this.proxy(this.dropComplete));
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
  SidebarView.prototype.initDroppables = function(items) {
    var dropOptions;
    console.log('Sidebar::initDroppables');
    dropOptions = {
      drop: function() {
        return console.log('Dropped');
      }
    };
    return items.droppable(dropOptions);
  };
  SidebarView.prototype.dropComplete = function(source, target) {
    var albumExists, ga, gallery, item, items, oldTarget, _i, _len;
    console.log('dropComplete');
    items = GalleriesAlbum.filter(target.id);
    for (_i = 0, _len = items.length; _i < _len; _i++) {
      item = items[_i];
      if (item.album_id === source.id) {
        albumExists = true;
      }
    }
    if (albumExists) {
      alert('Album already exists in Gallery');
      return;
    }
    if (!(source instanceof Album)) {
      alert('You can only drop Albums here');
      return;
    }
    ga = new GalleriesAlbum({
      album_id: source.id,
      gallery_id: target.id
    });
    ga.save();
    gallery = Gallery.find(target.id);
    oldTarget = Gallery.record;
    Gallery.current(target);
    gallery.save();
    return Gallery.current(oldTarget);
  };
  SidebarView.prototype.newAttributes = function() {
    return {
      name: 'New Gallery',
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