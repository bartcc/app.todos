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
    'dragover   .items': 'dragover',
    'drop       .items': 'drop'
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
      joinTable: 'GalleriesAlbum',
      sorted: true
    };
    Spine.bind('show:albums', this.proxy(this.show));
    Spine.bind('create:album', this.proxy(this.create));
    Spine.bind('destroy:album', this.proxy(this.destroy));
    Spine.bind('change:selectedGallery', this.proxy(this.changeSelection));
    Album.bind('ajaxError', Album.errorHandler);
    Album.bind('destroy:join', this.proxy(this.destroyJoin));
    Album.bind('create:join', this.proxy(this.createJoin));
    Album.bind('update destroy', this.proxy(this.change));
    Album.bind('destroy', this.proxy(this.destroyCache));
    GalleriesAlbum.bind('change', this.proxy(this.change));
    GalleriesAlbum.bind('change', this.proxy(this.renderHeader));
    Spine.bind('change:selectedGallery', this.proxy(this.renderHeader));
    Gallery.bind('refresh change', this.proxy(this.renderHeader));
    $(this.views).queue('fx');
  }
  AlbumsView.prototype.change = function(item, mode) {
    var gallery, _ref;
    console.log('AlbumsView::change');
    if (mode === 'update') {
      return;
    }
    this.gallery = gallery = Gallery.record;
    if (item.constructor.className === 'GalleriesAlbum' && item.destroyed) {
      this.navigate('/gallery/' + ((_ref = this.gallery) != null ? _ref.id : void 0));
    }
    if ((!gallery) || gallery.destroyed) {
      this.current = Album.filter();
    } else {
      this.current = Album.filterRelated(gallery.id, this.filterOptions);
    }
    return this.render(this.current);
  };
  AlbumsView.prototype.changeSelection = function(item, changed) {
    if (changed) {
      return this.change(item);
    }
  };
  AlbumsView.prototype.render = function(items) {
    var it, itm, list, _i, _len;
    console.log('AlbumsView::render');
    itm = [];
    for (_i = 0, _len = items.length; _i < _len; _i++) {
      it = items[_i];
      itm.push(it.title);
    }
    list = this.list.render(items);
    list.sortable('album');
    this.header.render();
    if (items && items.constructor.className === 'GalleriesAlbum' && item.destroyed) {
      this.show();
    }
    Spine.trigger('render:galleryAllSublist');
    return Spine.trigger('album:activate');
  };
  AlbumsView.prototype.renderHeader = function() {
    console.log('AlbumsView::renderHeader');
    return this.header.change(Gallery.record);
  };
  AlbumsView.prototype.destroyCache = function(album) {
    return album.destroyCache();
  };
  AlbumsView.prototype.show = function() {
    var alb, albums, _i, _len, _results;
    Spine.trigger('album:activate');
    App.showView.trigger('change:toolbarOne', ['Default']);
    App.showView.trigger('change:toolbarTwo', ['Slideshow']);
    App.showView.trigger('canvas', this);
    albums = GalleriesAlbum.albums(Gallery.record.id);
    _results = [];
    for (_i = 0, _len = albums.length; _i < _len; _i++) {
      alb = albums[_i];
      _results.push(alb.invalid ? (Album.clearCache(alb.id), this.list.refreshBackgrounds(alb), alb.invalid = false, alb.save({
        ajax: false
      })) : void 0);
    }
    return _results;
  };
  AlbumsView.prototype.newAttributes = function() {
    if (User.first()) {
      return {
        title: 'New Album',
        invalid: false,
        user_id: User.first().id,
        order: Album.all().length
      };
    } else {
      return User.ping();
    }
  };
  AlbumsView.prototype.create = function(e) {
    var album;
    console.log('AlbumsView::create');
    album = new Album(this.newAttributes());
    album.save({
      success: this.createCallback
    });
    Gallery.updateSelection([album.id]);
    return Album.current(album);
  };
  AlbumsView.prototype.createCallback = function() {
    if (Gallery.record) {
      Album.trigger('create:join', Gallery.record, this);
    }
    Gallery.updateSelection([this.id]);
    return Spine.trigger('album:activate');
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
        album.clearCache();
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
        album_id: record.id,
        order: GalleriesAlbum.next()
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
