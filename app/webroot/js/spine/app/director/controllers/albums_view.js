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
    '.hoverinfo': 'infoEl',
    '.items': 'items'
  };
  AlbumsView.prototype.events = {
    'dragstart  .items .thumbnail': 'dragstart',
    'drop .items': 'drop'
  };
  AlbumsView.prototype.albumsTemplate = function(items, options) {
    return $("#albumsTemplate").tmpl(items, options);
  };
  AlbumsView.prototype.headerTemplate = function(items) {
    return $("#headerAlbumTemplate").tmpl(items);
  };
  AlbumsView.prototype.infoTemplate = function(item) {
    return $('#albumInfoTemplate').tmpl(item);
  };
  function AlbumsView() {
    AlbumsView.__super__.constructor.apply(this, arguments);
    this.el.data({
      current: Gallery
    });
    this.info = new Info({
      el: this.infoEl,
      template: this.infoTemplate
    });
    this.list = new AlbumsList({
      el: this.items,
      template: this.albumsTemplate,
      info: this.info
    });
    this.header.template = this.headerTemplate;
    this.filterOptions = {
      key: 'gallery_id',
      joinTable: 'GalleriesAlbum'
    };
    Album.bind('ajaxError', Album.errorHandler);
    Spine.bind('create:album', this.proxy(this.create));
    Spine.bind('destroy:album', this.proxy(this.destroy));
    Album.bind('destroy:join', this.proxy(this.destroyJoin));
    Album.bind('create:join', this.proxy(this.createJoin));
    Album.bind('update destroy', this.proxy(this.change));
    Album.bind('destroy', this.proxy(this.clearCache));
    Spine.bind('change:selectedGallery', this.proxy(this.change));
    Spine.bind('show:albums', this.proxy(this.show));
    GalleriesAlbum.bind("change", this.proxy(this.change));
    GalleriesAlbum.bind('change', this.proxy(this.renderHeader));
    Spine.bind('change:selectedGallery', this.proxy(this.renderHeader));
    Gallery.bind('refresh change', this.proxy(this.renderHeader));
    $(this.views).queue('fx');
  }
  AlbumsView.prototype.change = function(item) {
    var gallery;
    console.log('AlbumsView::change');
    gallery = Gallery.record;
    if ((!gallery) || gallery.destroyed) {
      this.current = Album.filter();
    } else {
      this.current = Album.filterRelated(gallery.id, this.filterOptions);
    }
    return this.render(this.current);
  };
  AlbumsView.prototype.clearCache = function(album) {
    return album.clearCache();
  };
  AlbumsView.prototype.render = function(item) {
    var list;
    console.log('AlbumsView::render');
    list = this.list.render(this.current);
    this.header.render();
    if (item && item.constructor.className === 'GalleriesAlbum' && item.destroyed) {
      this.show();
    }
    Spine.trigger('render:galleryAllSublist');
    return Spine.trigger('album:activate');
  };
  AlbumsView.prototype.renderHeader = function() {
    console.log('AlbumsView::renderHeader');
    return this.header.change(Gallery.record);
  };
  AlbumsView.prototype.show = function() {
    Spine.trigger('change:toolbarOne', ['Album']);
    Spine.trigger('gallery:exposeSelection', Gallery.record);
    return Spine.trigger('change:canvas', this);
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
    album = new Album(this.newAttributes());
    album.save();
    Gallery.updateSelection([album.id]);
    if (Gallery.record) {
      Album.trigger('create:join', Gallery.record, album);
    }
    Album.current(album);
    this.show();
    this.change(album);
    return this.openPanel('album', App.showView.btnAlbum);
  };
  AlbumsView.prototype.destroy = function(e) {
    var album, albums, ga, gallery, gas, list, photos, _i, _j, _k, _len, _len2, _len3, _results;
    console.log('AlbumsView::destroy');
    list = Gallery.selectionList().slice(0);
    albums = [];
    Album.each(__bind(function(record) {
      if (list.indexOf(record.id) !== -1) {
        return albums.push(record);
      }
    }, this));
    if (Gallery.record) {
      Gallery.emptySelection();
      return Album.trigger('destroy:join', Gallery.record, albums);
    } else {
      for (_i = 0, _len = albums.length; _i < _len; _i++) {
        album = albums[_i];
        gas = GalleriesAlbum.filter(album.id, {
          key: 'album_id'
        });
        for (_j = 0, _len2 = gas.length; _j < _len2; _j++) {
          ga = gas[_j];
          if (Gallery.exists(ga.gallery_id)) {
            gallery = Gallery.find(ga.gallery_id);
          }
          photos = AlbumsPhoto.photos(album.id);
          Spine.Ajax.disable(function() {
            return Photo.trigger('destroy:join', album, photos);
          });
          Spine.Ajax.disable(function() {
            if (gallery) {
              return Album.trigger('destroy:join', gallery, album);
            }
          });
        }
      }
      _results = [];
      for (_k = 0, _len3 = albums.length; _k < _len3; _k++) {
        album = albums[_k];
        Gallery.removeFromSelection(album.id);
        _results.push(album.destroy());
      }
      return _results;
    }
  };
  AlbumsView.prototype.createJoin = function(target, albums) {
    var ga, record, records, _i, _len, _results;
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
    _results = [];
    for (_i = 0, _len = records.length; _i < _len; _i++) {
      record = records[_i];
      ga = new GalleriesAlbum({
        gallery_id: target.id,
        album_id: record.id
      });
      _results.push(ga.save());
    }
    return _results;
  };
  AlbumsView.prototype.destroyJoin = function(target, albums) {
    var ga, gas, records, _i, _len, _results;
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
    _results = [];
    for (_i = 0, _len = gas.length; _i < _len; _i++) {
      ga = gas[_i];
      _results.push(albums.indexOf(ga.album_id) !== -1 ? (Gallery.removeFromSelection(ga.album_id), ga.destroy()) : void 0);
    }
    return _results;
  };
  return AlbumsView;
})();
if (typeof module !== "undefined" && module !== null) {
  module.exports = AlbumsView;
}
