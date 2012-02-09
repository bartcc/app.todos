var $, PhotosView;
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
PhotosView = (function() {
  __extends(PhotosView, Spine.Controller);
  PhotosView.extend(Spine.Controller.Drag);
  PhotosView.prototype.elements = {
    '.hoverinfo': 'infoEl',
    '.items': 'items'
  };
  PhotosView.prototype.events = {
    'dragstart  .items .thumbnail': 'dragstart'
  };
  PhotosView.prototype.template = function(items) {
    return $('#photosTemplate').tmpl(items);
  };
  PhotosView.prototype.preloaderTemplate = function() {
    return $('#preloaderTemplate').tmpl();
  };
  PhotosView.prototype.headerTemplate = function(items) {
    return $("#headerPhotosTemplate").tmpl(items);
  };
  PhotosView.prototype.infoTemplate = function(item) {
    return $('#photoInfoTemplate').tmpl(item);
  };
  function PhotosView() {
    PhotosView.__super__.constructor.apply(this, arguments);
    this.el.data({
      current: Album
    });
    this.info = new Info({
      el: this.infoEl,
      template: this.infoTemplate
    });
    this.list = new PhotosList({
      el: this.items,
      template: this.template,
      info: this.info,
      parent: this.parent
    });
    this.header.template = this.headerTemplate;
    AlbumsPhoto.bind('change', this.proxy(this.renderHeader));
    AlbumsPhoto.bind('destroy', this.proxy(this.remove));
    AlbumsPhoto.bind('create', this.proxy(this.add));
    Album.bind('change', this.proxy(this.renderHeader));
    Photo.bind('refresh', this.proxy(this.refresh));
    Photo.bind('destroy', this.proxy(this.remove));
    Photo.bind("create:join", this.proxy(this.createJoin));
    Photo.bind("destroy:join", this.proxy(this.destroyJoin));
    Photo.bind("ajaxError", Photo.errorHandler);
    Spine.bind('change:selectedAlbum', this.proxy(this.renderHeader));
    Spine.bind('destroy:photo', this.proxy(this.destroy));
    Spine.bind('show:photos', this.proxy(this.show));
    Spine.bind('change:selectedAlbum', this.proxy(this.change));
    Gallery.bind('change', this.proxy(this.renderHeader));
  }
  PhotosView.prototype.change = function(item, mode, changed) {
    var filterOptions, items;
    filterOptions = {
      key: 'album_id',
      joinTable: 'AlbumsPhoto'
    };
    items = Photo.filterRelated(item != null ? item.id : void 0, filterOptions);
    return this.render(items);
  };
  PhotosView.prototype.render = function(items, mode) {
    var list;
    if (!this.isActive()) {
      return;
    }
    console.log('PhotosView::render');
    if (!this.list.children('li').length) {
      this.items.empty();
    }
    if (list = this.list.render(items, mode || 'html')) {
      if (Album.record) {
        list.sortable('photo');
      }
    }
    return this.refreshElements();
  };
  PhotosView.prototype.renderHeader = function() {
    console.log('PhotosView::renderHeader');
    return this.header.change(Album.record);
  };
  PhotosView.prototype.clearPhotoCache = function() {
    return Photo.clearCache();
  };
  PhotosView.prototype.clearAlbumCache = function(record, mode) {
    return Album.clearCache(record.album_id);
  };
  PhotosView.prototype.remove = function(record) {
    var photo, photoEl;
    console.log('PhotosView::remove');
    if (!record.destroyed) {
      return;
    }
    photo = (Photo.exists(record.photo_id) ? Photo.find(record.photo_id) : void 0) || record;
    if (photo) {
      photoEl = this.items.children().forItem(photo, true);
      photoEl.remove();
    }
    if (!this.items.children().length) {
      return this.render([]);
    }
  };
  PhotosView.prototype.add = function(ap) {
    var photo, _ref;
    console.log('PhotosView::add');
    if (ap.album_id === ((_ref = Album.record) != null ? _ref.id : void 0)) {
      photo = Photo.find(ap.photo_id);
      return this.render([photo], 'append');
    }
  };
  PhotosView.prototype.next = function(album) {
    return album.last();
  };
  PhotosView.prototype.destroy = function(e) {
    var album, ap, aps, list, photo, photos, _i, _j, _k, _len, _len2, _len3, _results;
    console.log('PhotosView::destroy');
    list = Album.selectionList().slice(0);
    photos = [];
    Photo.each(__bind(function(record) {
      if (list.indexOf(record.id) !== -1) {
        return photos.push(record);
      }
    }, this));
    if (Album.record) {
      Album.emptySelection();
      return Photo.trigger('destroy:join', Album.record, photos);
    } else {
      for (_i = 0, _len = photos.length; _i < _len; _i++) {
        photo = photos[_i];
        aps = AlbumsPhoto.filter(photo.id, {
          key: 'photo_id'
        });
        for (_j = 0, _len2 = aps.length; _j < _len2; _j++) {
          ap = aps[_j];
          album = Album.find(ap.album_id);
          Spine.Ajax.disable(function() {
            return Photo.trigger('destroy:join', album, photo);
          });
        }
      }
      _results = [];
      for (_k = 0, _len3 = photos.length; _k < _len3; _k++) {
        photo = photos[_k];
        Album.removeFromSelection(photo.id);
        _results.push(photo.destroy());
      }
      return _results;
    }
  };
  PhotosView.prototype.show = function() {
    if (this.isActive()) {
      return;
    }
    Spine.trigger('gallery:activate');
    Spine.trigger('change:toolbarOne', ['Default', 'Photos'], App.showView.initSlider);
    Spine.trigger('change:canvas', this);
    return this.renderHeader();
  };
  PhotosView.prototype.save = function(item) {};
  PhotosView.prototype.refresh = function(photos) {
    this.clearPhotoCache();
    if (Album.record) {
      return this.createJoin(Album.record, photos);
    } else {
      return this.render(photos);
    }
  };
  PhotosView.prototype.createJoin = function(target, photos) {
    var ap, record, records, _i, _len, _results;
    console.log('PhotosView::createJoin');
    if (!(target && target.constructor.className === 'Album')) {
      return;
    }
    if (!Photo.isArray(photos)) {
      records = [];
      records.push(photos);
    } else {
      records = photos;
    }
    _results = [];
    for (_i = 0, _len = records.length; _i < _len; _i++) {
      record = records[_i];
      ap = new AlbumsPhoto({
        album_id: target.id,
        photo_id: record.id,
        order: 9999
      });
      _results.push(ap.save());
    }
    return _results;
  };
  PhotosView.prototype.destroyJoin = function(target, photos) {
    var ap, aps, records, _i, _len, _results;
    console.log('PhotosView::destroyJoin');
    if (!(target && target.constructor.className === 'Album')) {
      return;
    }
    if (!Photo.isArray(photos)) {
      records = [];
      records.push(photos);
    } else {
      records = photos;
    }
    photos = Photo.toID(records);
    aps = AlbumsPhoto.filter(target.id, {
      key: 'album_id'
    });
    _results = [];
    for (_i = 0, _len = aps.length; _i < _len; _i++) {
      ap = aps[_i];
      _results.push(photos.indexOf(ap.photo_id) !== -1 ? (Album.removeFromSelection(ap.photo_id), ap.destroy()) : void 0);
    }
    return _results;
  };
  return PhotosView;
})();
if (typeof module !== "undefined" && module !== null) {
  module.exports = PhotosView;
}
