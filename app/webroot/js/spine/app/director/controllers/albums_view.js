var $, AlbumsView;
var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
}, __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
if (typeof Spine === "undefined" || Spine === null) {
  Spine = require("spine");
}
$ = Spine.$;
AlbumsView = (function() {
  __extends(AlbumsView, Spine.Controller);
  AlbumsView.extend(Spine.Controller.Drag);
  AlbumsView.prototype.elements = {
    '.preview': 'previewEl',
    '.items': 'items',
    '.content .sortable': 'sortable'
  };
  AlbumsView.prototype.events = {
    'sortupdate .items .item': 'sortupdate',
    'dragstart  .items .thumbnail': 'dragstart',
    'dragenter  .items .thumbnail': 'dragenter',
    'dragover   .items .thumbnail': 'dragover',
    'drop       .items .thumbnail': 'drop',
    'dragend    .items .thumbnail': 'dragend',
    'dragenter': 'dragenter',
    'dragover': 'dragover',
    'drop': 'drop',
    'dragend': 'dragend'
  };
  AlbumsView.prototype.albumsTemplate = function(items, options) {
    return $("#albumsTemplate").tmpl(items, options);
  };
  AlbumsView.prototype.headerTemplate = function(items) {
    return $("#headerGalleryTemplate").tmpl(items);
  };
  AlbumsView.prototype.previewTemplate = function(item) {
    return $('#albumPreviewTemplate').tmpl(item);
  };
  function AlbumsView() {
    AlbumsView.__super__.constructor.apply(this, arguments);
    this.preview = new Preview({
      el: this.previewEl,
      template: this.previewTemplate
    });
    this.list = new AlbumList({
      el: this.items,
      template: this.albumsTemplate,
      preview: this.preview
    });
    Album.bind("ajaxError", Album.errorHandler);
    Spine.bind('create:album', this.proxy(this.create));
    Spine.bind('destroy:album', this.proxy(this.destroy));
    Album.bind("destroy:join", this.proxy(this.destroyJoin));
    Album.bind("create:join", this.proxy(this.createJoin));
    Album.bind("update destroy", this.proxy(this.change));
    Spine.bind('change:selectedGallery', this.proxy(this.change));
    Spine.bind('show:albums', this.proxy(this.show));
    GalleriesAlbum.bind("change", this.proxy(this.change));
    GalleriesAlbum.bind('change', this.proxy(this.renderHeader));
    Spine.bind('change:selectedGallery', this.proxy(this.renderHeader));
    Gallery.bind('refresh change', this.proxy(this.renderHeader));
    this.filterOptions = {
      key: 'gallery_id',
      joinTable: 'GalleriesAlbum'
    };
    $(this.views).queue("fx");
  }
  AlbumsView.prototype.children = function(sel) {
    return this.el.children(sel);
  };
  AlbumsView.prototype.change = function(item) {
    var gallery;
    console.log('AlbumsView::change');
    gallery = Gallery.record;
    if ((!gallery) || gallery.destroyed) {
      this.current = Album.filter();
    } else {
      this.current = Album.filter(gallery.id, this.filterOptions);
    }
    return this.render(item);
  };
  AlbumsView.prototype.render = function(item) {
    console.log('AlbumsView::render');
    if (Gallery.record) {
      this.el.data(Gallery.record);
      Spine.trigger('render:gallerySublist', Gallery.record);
    } else {
      this.el.removeData();
    }
    this.list.render(this.current);
    if (item && item.constructor.className === 'GalleriesAlbum' && item.destroyed) {
      this.show();
    }
    return Spine.trigger('album:exposeSelection');
  };
  AlbumsView.prototype.renderHeader = function() {
    var values, _ref;
    console.log('AlbumsView::renderHeader');
    values = {
      record: Gallery.record,
      count: GalleriesAlbum.filter((_ref = Gallery.record) != null ? _ref.id : void 0, this.filterOptions).length
    };
    return this.header.html(this.headerTemplate(values));
  };
  AlbumsView.prototype.show = function() {
    this.parent.trigger('change:toolbar', Album);
    return Spine.trigger('change:canvas', this);
  };
  AlbumsView.prototype.initSortables = function() {
    var dragOptions;
    dragOptions = {
      helper: 'clone'
    };
    return this.items.draggable(dragOptions);
  };
  AlbumsView.prototype.newAttributes = function() {
    if (User.first()) {
      return {
        title: 'New Title',
        user_id: User.first().id
      };
    } else {
      return User.ping();
    }
  };
  AlbumsView.prototype.create = function(e) {
    var album;
    console.log('AlbumsView::create');
    Gallery.emptySelection();
    album = new Album(this.newAttributes());
    album.save();
    Gallery.updateSelection([album.id]);
    this.render(album);
    if (Gallery.record) {
      Album.trigger('create:join', Gallery.record, album);
    }
    Spine.trigger('change:selectedAlbum', album);
    Spine.trigger('show:albums');
    return this.openPanel('album', App.showView.btnAlbum);
  };
  AlbumsView.prototype.destroy = function(e) {
    var album, albums, list, _i, _len, _results;
    console.log('AlbumsView::destroy');
    list = Gallery.selectionList().slice(0);
    albums = [];
    Album.each(__bind(function(record) {
      if (list.indexOf(record.id) !== -1) {
        return albums.push(record);
      }
    }, this));
    if (Gallery.record) {
      console.log(Gallery.record);
      Gallery.emptySelection();
      return Album.trigger('destroy:join', Gallery.record, albums);
    } else {
      _results = [];
      for (_i = 0, _len = albums.length; _i < _len; _i++) {
        album = albums[_i];
        _results.push(Album.exists(album.id) ? (Album.removeFromSelection(Gallery, album.id), album.destroy()) : void 0);
      }
      return _results;
    }
  };
  AlbumsView.prototype.createJoin = function(target, albums) {
    var ga, record, records, _i, _len;
    console.log('AlbumsView::createJoin');
    if (!(target && target.constructor.className === 'Gallery')) {
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
  AlbumsView.prototype.destroyJoin = function(target, albums) {
    var ga, gas, records, _i, _len;
    if (!(target && target.constructor.className === 'Gallery')) {
      return;
    }
    if (!Album.isArray(albums)) {
      records = [];
      records.push(albums);
    } else {
      records = albums;
    }
    albums = Album.toID(records);
    gas = GalleriesAlbum.filter(target.id, this.filterOptions);
    for (_i = 0, _len = gas.length; _i < _len; _i++) {
      ga = gas[_i];
      if (albums.indexOf(ga.album_id) !== -1) {
        Album.removeFromSelection(Gallery, ga.album_id);
        ga.destroy();
      }
    }
    return target.save();
  };
  AlbumsView.prototype.email = function() {
    if (!this.current.email) {
      return;
    }
    return window.location = "mailto:" + this.current.email;
  };
  return AlbumsView;
})();
if (typeof module !== "undefined" && module !== null) {
  module.exports = AlbumsView;
}