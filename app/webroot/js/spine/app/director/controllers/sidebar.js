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
if (typeof Spine === "undefined" || Spine === null) {
  Spine = require("spine");
}
$ = Spine.$;
SidebarView = (function() {
  __extends(SidebarView, Spine.Controller);
  SidebarView.extend(Spine.Controller.Drag);
  SidebarView.prototype.elements = {
    'input': 'input',
    '.items': 'items',
    '.droppable': 'droppable',
    '.inner': 'inner'
  };
  SidebarView.prototype.events = {
    "click button": "create",
    "keyup input": "filter",
    "dblclick .draghandle": 'toggleDraghandle',
    'dragstart .items .item': 'dragstart',
    'dragenter .items .item': 'dragenter',
    'dragover  .items .item': 'dragover',
    'dragleave .items .item': 'dragleave',
    'drop      .items .item': 'drop',
    'dragend   .items .item': 'dragend'
  };
  SidebarView.prototype.template = function(items) {
    return $("#galleriesTemplate").tmpl(items);
  };
  SidebarView.prototype.subListTemplate = function(items) {
    return $('#albumsSubListTemplate').tmpl(items);
  };
  function SidebarView() {
    SidebarView.__super__.constructor.apply(this, arguments);
    this.el.width(300);
    this.list = new Spine.GalleryList({
      el: this.items,
      template: this.template
    });
    Gallery.bind("refresh change", this.proxy(this.render));
    Gallery.bind("ajaxError", Gallery.errorHandler);
    Spine.bind('render:galleryItem', this.proxy(this.renderItem));
    Spine.bind('render:subList', this.proxy(this.renderSubList));
    Spine.bind('create:gallery', this.proxy(this.create));
    Spine.bind('destroy:gallery', this.proxy(this.destroy));
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
    var item, _i, _len, _ref, _results;
    console.log('Sidebar::renderItem');
    _ref = this.galleryItems;
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      item = _ref[_i];
      $('.cta', '#' + item.id).html(Album.filter(item.id).length);
      _results.push(this.renderSubList(item.id));
    }
    return _results;
  };
  SidebarView.prototype.renderSubList = function(id) {
    var albums;
    albums = Album.filter(id);
    return $('#sub-' + id).html(this.subListTemplate(albums));
  };
  SidebarView.prototype.dragStart = function(e) {
    var id, raw, selection, _ref;
    console.log('Sidebar::dragStart');
    if ($(e.target).parent()[0].id) {
      raw = $(e.target).parent()[0].id;
      id = raw.replace(/(^sub-)()/, '');
      if (id && Gallery.exists(id)) {
        Spine.dragItem.origin = Gallery.find(id);
      }
      selection = [];
    } else {
      selection = Gallery.selectionList();
    }
    this.newSelection = selection.slice(0);
    if (_ref = Spine.dragItem.source.id, __indexOf.call(selection, _ref) < 0) {
      return this.newSelection.push(Spine.dragItem.source.id);
    }
  };
  SidebarView.prototype.dragOver = function(e) {
    var item, items, target, _i, _len, _ref, _results;
    target = $(e.target).item();
    if (target) {
      $(e.target).removeClass('nodrop');
      items = GalleriesAlbum.filter(target.id);
      _results = [];
      for (_i = 0, _len = items.length; _i < _len; _i++) {
        item = items[_i];
        _results.push((_ref = item.album_id, __indexOf.call(this.newSelection, _ref) >= 0) ? $(e.target).addClass('nodrop') : void 0);
      }
      return _results;
    }
  };
  SidebarView.prototype.dragLeave = function(e) {};
  SidebarView.prototype.dropComplete = function(target, e) {
    var albums, item, items, origin, source, _i, _len, _ref, _ref2;
    console.log('Sidebar::dropComplete');
    source = (_ref = Spine.dragItem) != null ? _ref.source : void 0;
    origin = ((_ref2 = Spine.dragItem) != null ? _ref2.origin : void 0) || Gallery.record;
    if (!(source instanceof Album)) {
      alert('You should only drop Albums here');
      return;
    }
    if (!(target instanceof Gallery)) {
      return;
    }
    if (!(origin.id !== target.id)) {
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
    Spine.trigger('create:albumJoin', target, albums);
    if (!this.isCtrlClick(e)) {
      return Spine.trigger('destroy:albumJoin', origin, albums);
    }
  };
  SidebarView.prototype.newAttributes = function() {
    return {
      name: 'New Gallery',
      user_id: User.first().id
    };
  };
  SidebarView.prototype.create = function() {
    var gallery;
    console.log('Sidebar::create');
    this.openPanel('gallery', App.albumsShowView.btnGallery);
    gallery = new Gallery(this.newAttributes());
    return gallery.save();
  };
  SidebarView.prototype.destroy = function() {
    console.log('Sidebar::destroy');
    Gallery.record.destroy();
    if (!Gallery.count()) {
      return Gallery.current();
    }
  };
  SidebarView.prototype.toggleDraghandle = function() {
    var speed, w, width;
    width = __bind(function() {
      var max, w;
      max = App.vmanager.currentDim;
      w = this.el.width();
      if (App.vmanager.sleep) {
        App.vmanager.awake();
        this.clb = function() {};
        return max + "px";
      } else {
        this.clb = App.vmanager.goSleep;
        return '8px';
      }
    }, this);
    w = width();
    speed = 500;
    return this.el.animate({
      width: w
    }, speed, __bind(function() {
      return this.clb();
    }, this));
  };
  return SidebarView;
})();
if (typeof module !== "undefined" && module !== null) {
  module.exports = SidebarView;
}