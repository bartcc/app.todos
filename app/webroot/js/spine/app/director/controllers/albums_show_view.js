var $, AlbumsShowView;
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
AlbumsShowView = (function() {
  __extends(AlbumsShowView, Spine.Controller);
  AlbumsShowView.extend(Spine.Controller.Drag);
  AlbumsShowView.prototype.elements = {
    ".content": "showContent",
    "#views .views": "views",
    ".content .sortable": "sortable",
    '.optEditGallery': 'btnEditGallery',
    '.optCreateGallery': 'btnCreateGallery',
    '.optDestroyGallery': 'btnDestroyGallery',
    '.optGallery': 'btnGallery',
    '.optAlbum': 'btnAlbum',
    '.optUpload': 'btnUpload',
    '.optGrid': 'btnGrid',
    '.content .items': 'items',
    '.content .items .item': 'item',
    '.header': 'header',
    '.toolbar': 'toolBar'
  };
  AlbumsShowView.prototype.events = {
    "click .optCreateAlbum": "createAlbum",
    "click .optDestroyAlbum": "destroyAlbum",
    "click .optEditGallery": "editGallery",
    "click .optCreateGallery": "createGallery",
    "click .optDestroyGallery": "destroyGallery",
    "click .optEmail": "email",
    "click .optGallery": "toggleGallery",
    "click .optAlbum": "toggleAlbum",
    "click .optUpload": "toggleUpload",
    "click .optGrid": "toggleGrid",
    'dblclick .draghandle': 'toggleDraghandle',
    'sortupdate         .items': 'sortupdate',
    'dragstart          .items .item': 'dragstart',
    'dragenter          .items .item': 'dragenter',
    'dragover           .items .item': 'dragover',
    'dragleave          .items .item': 'dragleave',
    'drop               .items .item': 'drop',
    'dragend            .items .item': 'dragend'
  };
  AlbumsShowView.prototype.albumsTemplate = function(items) {
    return $("#albumsTemplate").tmpl(items);
  };
  AlbumsShowView.prototype.toolsTemplate = function(items) {
    return $("#toolsTemplate").tmpl(items);
  };
  AlbumsShowView.prototype.headerTemplate = function(items) {
    return $("#headerTemplate").tmpl(items);
  };
  function AlbumsShowView() {
    AlbumsShowView.__super__.constructor.apply(this, arguments);
    this.list = new Spine.AlbumList({
      el: this.items,
      template: this.albumsTemplate
    });
    Spine.bind('create:album', this.proxy(this.create));
    Spine.bind('destroy:album', this.proxy(this.destroy));
    Spine.bind("destroy:albumJoin", this.proxy(this.destroyJoin));
    Spine.bind("create:albumJoin", this.proxy(this.createJoin));
    Album.bind("change", this.proxy(this.render));
    Spine.bind('change:selectedGallery', this.proxy(this.change));
    Spine.bind('change:selectedAlbum', this.proxy(this.renderToolbar));
    Spine.bind('change:selection', this.proxy(this.changeSelection));
    GalleriesAlbum.bind("change", this.proxy(this.render));
    this.bind("toggle:view", this.proxy(this.toggleView));
    this.activeControl = this.btnGallery;
    this.create = this.edit = this.editGallery;
    $(this.views).queue("fx");
  }
  AlbumsShowView.prototype.children = function(sel) {
    return this.el.children(sel);
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
  AlbumsShowView.prototype.render = function(item) {
    var items;
    console.log('AlbumsShowView::render');
    Spine.trigger('render:galleryItem');
    if (this.current) {
      items = Album.filter(this.current.id);
    } else {
      items = Album.filter();
    }
    this.renderHeader(items);
    this.renderToolbar();
    return this.list.render(items, item);
  };
  AlbumsShowView.prototype.renderHeader = function(items) {
    var values;
    console.log('AlbumsShowView::renderHeader');
    values = {
      record: Gallery.record,
      count: items.length
    };
    if (Gallery.record) {
      return this.header.html(this.headerTemplate(values));
    } else {
      return this.header.html('<h3>Album Originals</h3><h2>All Albums</h2>');
    }
  };
  AlbumsShowView.prototype.renderToolbar = function() {
    console.log('AlbumsShowView::renderToolbar');
    this.toolBar.html(this.toolsTemplate(this.toolBarList()));
    return this.refreshElements();
  };
  AlbumsShowView.prototype.toolBarList = function() {
    return arguments[0];
  };
  AlbumsShowView.prototype.initSortables = function() {
    var sortOptions;
    sortOptions = {};
    return this.items.sortable(sortOptions);
  };
  AlbumsShowView.prototype.newAttributes = function() {
    return {
      title: 'New Title',
      name: 'New Album'
    };
  };
  AlbumsShowView.prototype.create = function() {
    var album;
    console.log('AlbumList::create');
    this.openPanel('album', App.albumsShowView.btnAlbum);
    album = new Album(this.newAttributes());
    album.save();
    return Spine.trigger('create:albumJoin', Gallery.record, album);
  };
  AlbumsShowView.prototype.destroy = function() {
    var album, albums, list, _i, _len, _results;
    console.log('AlbumList::destroy');
    list = Gallery.selectionList().slice(0);
    albums = [];
    Album.each(__bind(function(record) {
      if (list.indexOf(record.id) !== -1) {
        return albums.push(record);
      }
    }, this));
    if (Gallery.record) {
      return Spine.trigger('destroy:albumJoin', Gallery.record, albums);
    } else {
      _results = [];
      for (_i = 0, _len = albums.length; _i < _len; _i++) {
        album = albums[_i];
        _results.push(Album.exists(album.id) ? album.destroy() : void 0);
      }
      return _results;
    }
  };
  AlbumsShowView.prototype.createJoin = function(target, albums) {
    var ga, record, records, _i, _len;
    console.log('AlbumsShowView::createJoin');
    if (!(target && target instanceof Gallery)) {
      return;
    }
    if (!Album.isArray(albums)) {
      records = [];
      records.push(albums);
    } else {
      records = albums;
    }
    for (_i = 0, _len = records.length; _i < _len; _i++) {
      record = records[_i];
      ga = new GalleriesAlbum({
        gallery_id: target.id,
        album_id: record.id
      });
      ga.save();
    }
    return target.save();
  };
  AlbumsShowView.prototype.destroyJoin = function(target, albums) {
    var ga, gas, records, _i, _len;
    console.log('AlbumsShowView::destroyJoin');
    if (!(target && target instanceof Gallery)) {
      return;
    }
    if (!Album.isArray(albums)) {
      records = [];
      records.push(albums);
    } else {
      records = albums;
    }
    albums = Album.toID(records);
    gas = GalleriesAlbum.filter(target.id);
    for (_i = 0, _len = gas.length; _i < _len; _i++) {
      ga = gas[_i];
      if (albums.indexOf(ga.album_id) !== -1) {
        Album.removeFromSelection(Gallery, ga.album_id);
        ga.destroy();
      }
    }
    return target.save();
  };
  AlbumsShowView.prototype.createAlbum = function(e) {
    if ($(e.currentTarget).hasClass('disabled')) {
      return;
    }
    return Spine.trigger('create:album');
  };
  AlbumsShowView.prototype.destroyAlbum = function(e) {
    if ($(e.currentTarget).hasClass('disabled')) {
      return;
    }
    return Spine.trigger('destroy:album');
  };
  AlbumsShowView.prototype.editGallery = function(e) {
    if ($(e.currentTarget).hasClass('disabled')) {
      return;
    }
    App.albumsEditView.render();
    App.albumsManager.change(App.albumsEditView);
    return this.focusFirstInput(App.albumsEditView.el);
  };
  AlbumsShowView.prototype.createGallery = function(e) {
    if ($(e.currentTarget).hasClass('disabled')) {
      return;
    }
    return Spine.trigger('create:gallery');
  };
  AlbumsShowView.prototype.destroyGallery = function(e) {
    if ($(e.currentTarget).hasClass('disabled')) {
      return;
    }
    return Spine.trigger('destroy:gallery');
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
    return $(".options .opt").each(function() {
      if (this === controlEl) {
        return $(this).toggleClass("active", active);
      } else {
        return $(this).removeClass("active");
      }
    });
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
  AlbumsShowView.prototype.changeSelection = function(instanceName) {
    console.log('AlbumsShowView::changeSelection');
    switch (instanceName) {
      case 'Gallery':
        console.log('instanceof Gallery');
        this.toolBarList = function() {
          return [
            {
              name: 'Edit Gallery',
              klass: 'optEditGallery',
              disabled: !Gallery.record
            }, {
              name: 'New Gallery',
              klass: 'optCreateGallery'
            }, {
              name: 'Delete Gallery',
              klass: 'optDestroyGallery',
              disabled: !Gallery.record
            }
          ];
        };
        break;
      case 'Album':
        console.log('instanceof Album');
        this.toolBarList = function() {
          return [
            {
              name: 'New Album',
              klass: 'optCreateAlbum'
            }, {
              name: 'Delete Album',
              klass: 'optDestroyAlbum ',
              disabled: !Gallery.selectionList().length
            }
          ];
        };
    }
    return this.renderToolbar();
  };
  AlbumsShowView.prototype.toggleGallery = function(e) {
    Spine.trigger('change:selection', 'Gallery');
    return this.trigger("toggle:view", App.gallery, e.target);
  };
  AlbumsShowView.prototype.toggleAlbum = function(e) {
    Spine.trigger('change:selection', 'Album');
    return this.trigger("toggle:view", App.album, e.target);
  };
  AlbumsShowView.prototype.toggleUpload = function(e) {
    this.toolBarList = function() {
      return [
        {
          name: 'Show Upload',
          klass: ''
        }, {
          name: 'Edit Upload',
          klass: ''
        }
      ];
    };
    return this.trigger("toggle:view", App.upload, e.target);
  };
  AlbumsShowView.prototype.toggleGrid = function(e) {
    this.toolBarList = function() {
      return [
        {
          name: 'Show Grid',
          klass: ''
        }, {
          name: 'Edit Grid',
          klass: ''
        }
      ];
    };
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