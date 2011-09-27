var $, AlbumsShowView;
var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
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
AlbumsShowView = (function() {
  __extends(AlbumsShowView, Spine.Controller);
  AlbumsShowView.prototype.elements = {
    ".content": "showContent",
    "#views .views": "views",
    ".content .sortable": "sortable",
    '.optGallery': 'btnGallery',
    '.optAlbum': 'btnAlbum',
    '.optUpload': 'btnUpload',
    '.optGrid': 'btnGrid',
    '.content .items': 'items',
    '.header': 'header',
    '.toolbar': 'toolBar'
  };
  AlbumsShowView.prototype.events = {
    "click .optEdit": "edit",
    "click .optEmail": "email",
    "click .optGallery": "toggleGallery",
    "click .optAlbum": "toggleAlbum",
    "click .optUpload": "toggleUpload",
    "click .optGrid": "toggleGrid",
    'dblclick .draghandle': 'toggleDraghandle',
    'dragcreate .items': 'dragcreate',
    'drag .items': 'drag'
  };
  AlbumsShowView.prototype.albumsTemplate = function(items) {
    return $("#albumsTemplate").tmpl(items);
  };
  AlbumsShowView.prototype.toolsTemplate = function(items) {
    return $("#toolsTemplate").tmpl(items);
  };
  function AlbumsShowView() {
    AlbumsShowView.__super__.constructor.apply(this, arguments);
    this.list = new Spine.AlbumList({
      el: this.items,
      template: this.albumsTemplate
    });
    Album.bind("change", this.proxy(this.render));
    Gallery.bind("update", this.proxy(this.renderHeader));
    Spine.App.bind('save:gallery', this.proxy(this.save));
    Spine.App.bind('change:selectedGallery', this.proxy(this.change));
    this.bind('save:gallery', this.proxy(this.save));
    this.bind("toggle:view", this.proxy(this.toggleView));
    this.toolBarList = [];
    this.create = this.edit;
    $(this.views).queue("fx");
  }
  AlbumsShowView.prototype.children = function(sel) {
    return this.el.children(sel);
  };
  AlbumsShowView.prototype.loadJoinTables = function() {
    return AlbumsImage.records = Album.joinTableRecords;
  };
  AlbumsShowView.prototype.change = function(item, mode) {
    console.log('AlbumsShowView::change');
    if (mode) {
      console.log(mode);
    }
    this.current = item;
    this.render();
    return typeof this[mode] === "function" ? this[mode](item) : void 0;
  };
  AlbumsShowView.prototype.render = function(album) {
    var items, joinedItems, val;
    console.log('AlbumsShowView::render');
    if (this.current) {
      joinedItems = GalleriesAlbum.filter(this.current.id);
      items = (function() {
        var _i, _len, _results;
        _results = [];
        for (_i = 0, _len = joinedItems.length; _i < _len; _i++) {
          val = joinedItems[_i];
          _results.push(Album.find(val.album_id));
        }
        return _results;
      })();
    } else {
      items = Album.filter();
    }
    this.renderHeader();
    this.list.render(items, album);
    return this.initDraggables();
  };
  AlbumsShowView.prototype.renderHeader = function(item) {
    var gallery;
    console.log('AlbumsShowView::renderHeader');
    gallery = item || this.current;
    if (gallery) {
      return this.header.html('<h2>Albums for Gallery ' + gallery.name + '</h2>');
    } else {
      return this.header.html('<h2>Albums Overview</h2>');
    }
  };
  AlbumsShowView.prototype.renderToolBar = function() {
    this.toolBar.html(this.toolsTemplate(this.toolBarList));
    return this.refreshElements();
  };
  AlbumsShowView.prototype.initDraggables = function() {
    var dragOptions, dropOptions, sortOptions;
    sortOptions = {
      connectWith: '#sidebar .items'
    };
    dragOptions = {
      opacity: 0.35,
      revert: true,
      revertDuration: 1000,
      scope: 'albums',
      stack: '#sidebar',
      connectToSortable: '.show .content .sortable'
    };
    dropOptions = {};
    this.sortable.children().draggable(dragOptions);
    return console.log(this.droppable);
  };
  AlbumsShowView.prototype.drag = function(e, ui) {};
  AlbumsShowView.prototype.dragcreate = function(e, ui) {};
  AlbumsShowView.prototype.edit = function() {
    App.albumsEditView.render();
    return App.albumsManager.change(App.albumsEditView);
  };
  AlbumsShowView.prototype.email = function() {
    if (!this.current.email) {
      return;
    }
    return window.location = "mailto:" + this.current.email;
  };
  AlbumsShowView.prototype.renderViewControl = function(controller, controlEl) {
    var active;
    active = controller.isActive();
    $(".options .opt").each(function() {
      if (this === controlEl) {
        return $(this).toggleClass("active", active);
      } else {
        return $(this).removeClass("active");
      }
    });
    if (!App.hmanager.hasActive()) {
      return this.toolBar.empty();
    }
  };
  AlbumsShowView.prototype.animateView = function() {
    var hasActive, height;
    hasActive = function() {
      if (App.hmanager.hasActive()) {
        return App.hmanager.enableDrag();
      }
      return App.hmanager.disableDrag();
    };
    height = function() {
      if (hasActive()) {
        return parseInt(App.hmanager.currentDim) + "px";
      } else {
        return "7px";
      }
    };
    return this.views.animate({
      height: height()
    }, 400);
  };
  AlbumsShowView.prototype.toggleGallery = function(e) {
    this.toolBarList = [
      {
        name: 'Show Gallery',
        klass: 'optEdit'
      }, {
        name: 'Edit Gallery',
        klass: 'optEdit'
      }
    ];
    return this.trigger("toggle:view", App.gallery, e.target);
  };
  AlbumsShowView.prototype.toggleAlbum = function(e) {
    this.toolBarList = [
      {
        name: 'Show Album',
        klass: 'optEdit'
      }, {
        name: 'Edit Album',
        klass: 'optEdit'
      }
    ];
    return this.trigger("toggle:view", App.album, e.target);
  };
  AlbumsShowView.prototype.toggleUpload = function(e) {
    this.toolBarList = [
      {
        name: 'Show Upload',
        klass: 'optEdit'
      }, {
        name: 'Edit Upload',
        klass: 'optEdit'
      }
    ];
    return this.trigger("toggle:view", App.upload, e.target);
  };
  AlbumsShowView.prototype.toggleGrid = function(e) {
    this.toolBarList = [
      {
        name: 'Show Grid',
        klass: 'optEdit'
      }, {
        name: 'Edit Grid',
        klass: 'optEdit'
      }
    ];
    return this.trigger("toggle:view", App.grid, e.target);
  };
  AlbumsShowView.prototype.toggleView = function(controller, control) {
    var isActive;
    isActive = controller.isActive();
    if (isActive) {
      App.hmanager.trigger("change", false);
    } else {
      this.activeControl = $(control);
      App.hmanager.trigger("change", controller);
    }
    this.renderToolBar();
    this.renderViewControl(controller, control);
    return this.animateView();
  };
  AlbumsShowView.prototype.toggleDraghandle = function() {
    return this.activeControl.click();
  };
  return AlbumsShowView;
})();
if (typeof module !== "undefined" && module !== null) {
  module.exports = AlbumsView;
}