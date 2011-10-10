var $, SidebarView;
var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
}, __indexOf = Array.prototype.indexOf || function(item) {
  for (var i = 0, l = this.length; i < l; i++) {
    if (this[i] === item) return i;
  }
  return -1;
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
  SidebarView.prototype.subListTemplate = function(items) {
    return $('#albumsSubListTemplate').tmpl(items);
  };
  function SidebarView() {
    SidebarView.__super__.constructor.apply(this, arguments);
    this.list = new Spine.GalleryList({
      el: this.items,
      template: this.template
    });
    Gallery.bind("refresh change", this.proxy(this.render));
    Spine.bind('render:galleryItem', this.proxy(this.renderItem));
    Spine.bind('render:subList', this.proxy(this.renderSubList));
    Spine.bind('drag:start', this.proxy(this.dragStart));
    Spine.bind('drag:over', this.proxy(this.dragOver));
    Spine.bind('drag:leave', this.proxy(this.dragLeave));
    Spine.bind('drag:drop', this.proxy(this.dropComplete));
  }
  SidebarView.prototype.filter = function() {
    this.query = this.input.val();
    return this.render();
  };
  SidebarView.prototype.render = function(item, mode) {
    var items;
    console.log('Sidebar::render');
    items = Gallery.filter(this.query, 'searchSelect');
    items = items.sort(Gallery.nameSort);
    this.galleryItems = items;
    return this.list.render(items, item, mode);
  };
  SidebarView.prototype.renderItem = function() {
    var albums, item, _i, _len, _ref, _results;
    _ref = this.galleryItems;
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      item = _ref[_i];
      albums = Album.filter(item.id);
      $('#' + item.id + ' span.cta').html(Album.filter(item.id).length);
      _results.push(this.renderSubList(item.id));
    }
    return _results;
  };
  SidebarView.prototype.renderSubList = function(id) {
    var albums;
    albums = Album.filter(id);
    return $('#sub-' + id).html(this.subListTemplate(albums));
  };
  SidebarView.prototype.dragStart = function() {
    var newSelection, selection, _ref;
    selection = Gallery.selectionList();
    newSelection = selection.slice(0);
    if (_ref = Spine.dragItem.id, __indexOf.call(selection, _ref) < 0) {
      newSelection.push(Spine.dragItem.id);
    }
    this.newSelection = newSelection;
    return this.oldtargetID = null;
  };
  SidebarView.prototype.dragOver = function(e) {
    var item, items, target, _i, _len, _ref, _results;
    target = $(e.target).item();
    if (target.id === this.oldtargetID) {
      return;
    }
    this.oldtargetID = target.id;
    items = GalleriesAlbum.filter(target.id);
    _results = [];
    for (_i = 0, _len = items.length; _i < _len; _i++) {
      item = items[_i];
      _results.push((_ref = item.album_id, __indexOf.call(this.newSelection, _ref) >= 0) ? $(e.target).addClass('nodrop') : void 0);
    }
    return _results;
  };
  SidebarView.prototype.dragLeave = function(e) {
    var target;
    target = $(e.target).item();
    if (target.id === this.oldtargetID) {
      return;
    }
    this.oldtargetID = target.id;
    return $('li').removeClass('nodrop');
  };
  SidebarView.prototype.dropComplete = function(target, e) {
    var albums, item, items, origin, source, _i, _len;
    console.log('dropComplete');
    source = Spine.dragItem;
    origin = Gallery.record;
    if (!(source instanceof Album)) {
      alert('You can only drop Albums here');
      return;
    }
    if (!(target instanceof Gallery)) {
      return;
    }
    items = GalleriesAlbum.filter(target.id);
    for (_i = 0, _len = items.length; _i < _len; _i++) {
      item = items[_i];
      if (item.album_id === source.id) {
        alert('Album already exists in Gallery');
        return;
      }
    }
    albums = [];
    Album.each(__bind(function(record) {
      if (this.newSelection.indexOf(record.id) !== -1) {
        return albums.push(record);
      }
    }, this));
    console.log(e);
    Spine.trigger('create:albumJoin', target, albums);
    if (!e.metaKey) {
      return Spine.trigger('destroy:albumJoin', origin, albums);
    }
  };
  SidebarView.prototype.newAttributes = function() {
    return {
      name: 'New Gallery',
      author: 'No Author'
    };
  };
  SidebarView.prototype.create = function(e) {
    var gallery;
    e.preventDefault();
    this.preserveEditorOpen('gallery', App.albumsShowView.btnGallery);
    gallery = new Gallery(this.newAttributes());
    return gallery.save();
  };
  SidebarView.prototype.destroy_ = function(item) {
    console.log('AlbumsEditView::destroy');
    if (!Gallery.record) {
      return;
    }
    item.destroy();
    if (!Gallery.count()) {
      return Gallery.current();
    }
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