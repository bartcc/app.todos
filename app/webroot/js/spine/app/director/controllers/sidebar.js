var $, SidebarView;
var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; }, __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
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
};
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
    this.validateDrop = __bind(this.validateDrop, this);
    this.dropComplete = __bind(this.dropComplete, this);
    this.dragLeave = __bind(this.dragLeave, this);
    this.dragOver = __bind(this.dragOver, this);
    this.dragEnter = __bind(this.dragEnter, this);    SidebarView.__super__.constructor.apply(this, arguments);
    this.el.width(300);
    this.list = new GalleryList({
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
    Spine.bind('drag:enter', this.proxy(this.dragEnter));
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
    console.log('Sidebar::renderSubList');
    albums = Album.filter(id);
    if (!albums.length) {
      albums.push({
        flash: 'no albums'
      });
    }
    return $('#' + id + ' ul').html(this.subListTemplate(albums));
  };
  SidebarView.prototype.dragStart = function(e, controller) {
    var el, event, fromSidebar, id, selection, _ref;
    console.log('Sidebar::dragStart');
    el = $(e.target);
    event = e.originalEvent;
    Spine.dragItem.targetEl = null;
    if (el.parents('ul.sublist').length) {
      id = el.parents('li.item')[0].id;
      if (id && Gallery.exists(id)) {
        Spine.dragItem.origin = Gallery.find(id);
      }
      fromSidebar = true;
      selection = [];
    } else {
      selection = Gallery.selectionList();
    }
    if (!(_ref = Spine.dragItem.source.id, __indexOf.call(selection, _ref) >= 0) && !selection.length) {
      selection.push(Spine.dragItem.source.id);
      if (!fromSidebar) {
        Spine.trigger('exposeSelection', selection);
      }
    }
    this.clonedSelection = selection.slice(0);
    if (this.clonedSelection.length > 1) {
      if (this.isCtrlClick(e)) {
        event.dataTransfer.setDragImage(App.ALBUM_DOUBLE_COPY, 60, 60);
      } else {
        event.dataTransfer.setDragImage(App.ALBUM_DOUBLE_MOVE, 60, 60);
      }
    }
    if (this.clonedSelection.length === 1) {
      if (this.isCtrlClick(e)) {
        return event.dataTransfer.setDragImage(App.ALBUM_SINGLE_COPY, 60, 60);
      } else {
        return event.dataTransfer.setDragImage(App.ALBUM_SINGLE_MOVE, 60, 60);
      }
    }
  };
  SidebarView.prototype.dragEnter = function(e) {
    var closest, el, id, origin, source, target, _ref, _ref2, _ref3, _ref4;
    console.log('Sidebar::dragEnter');
    el = $(e.target);
    closest = (el.closest('.item')) || [];
    if (closest.length) {
      id = closest.attr('id');
      target = closest.item();
      source = (_ref = Spine.dragItem) != null ? _ref.source : void 0;
      origin = ((_ref2 = Spine.dragItem) != null ? _ref2.origin : void 0) || Gallery.record;
      if ((_ref3 = Spine.dragItem.closest) != null) {
        _ref3.removeClass('over nodrop');
      }
      Spine.dragItem.closest = closest;
      if (this.validateDrop(target, source, origin)) {
        Spine.dragItem.closest.addClass('over');
      } else {
        Spine.dragItem.closest.addClass('over nodrop');
      }
    }
    if (id && this._id !== id) {
      this._id = id;
      return (_ref4 = Spine.dragItem.closest) != null ? _ref4.removeClass('over') : void 0;
    }
  };
  SidebarView.prototype.dragOver = function(e) {};
  SidebarView.prototype.dragLeave = function(e) {};
  SidebarView.prototype.dropComplete = function(target, e) {
    var albums, origin, source, _ref, _ref2, _ref3;
    console.log('Sidebar::dropComplete');
    if ((_ref = Spine.dragItem.closest) != null) {
      _ref.removeClass('over nodrop');
    }
    source = (_ref2 = Spine.dragItem) != null ? _ref2.source : void 0;
    origin = ((_ref3 = Spine.dragItem) != null ? _ref3.origin : void 0) || Gallery.record;
    if (!this.validateDrop(target, source, origin)) {
      return;
    }
    albums = [];
    Album.each(__bind(function(record) {
      if (this.clonedSelection.indexOf(record.id) !== -1) {
        return albums.push(record);
      }
    }, this));
    Spine.trigger('create:albumJoin', target, albums);
    if (!this.isCtrlClick(e)) {
      return Spine.trigger('destroy:albumJoin', origin, albums);
    }
  };
  SidebarView.prototype.validateDrop = function(target, source, origin) {
    var item, items, _i, _len;
    if (!(source instanceof Album)) {
      return false;
    }
    if (!(target instanceof Gallery)) {
      return false;
    }
    if (!(origin.id !== target.id)) {
      return false;
    }
    items = GalleriesAlbum.filter(target.id);
    for (_i = 0, _len = items.length; _i < _len; _i++) {
      item = items[_i];
      if (item.album_id === source.id) {
        return false;
      }
    }
    return true;
  };
  SidebarView.prototype.newAttributes = function() {
    if (User.first()) {
      return {
        name: this.galleryName(),
        author: User.first().name,
        user_id: User.first().id
      };
    } else {
      return User.ping();
    }
  };
  SidebarView.prototype.galleryName = function(proposal) {
    if (proposal == null) {
      proposal = 'Gallery ' + Number(Gallery.count() + 1);
    }
    Gallery.each(__bind(function(record) {
      if (record.name === proposal) {
        return this.galleryName(proposal + '_1');
      }
    }, this));
    return proposal;
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
    if (Gallery.record) {
      Gallery.record.destroy();
    }
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