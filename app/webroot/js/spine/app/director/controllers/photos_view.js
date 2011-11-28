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
    '.items': 'items'
  };
  PhotosView.prototype.events = {
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
  PhotosView.prototype.template = function(items) {
    return $('#photosTemplate').tmpl(items);
  };
  PhotosView.prototype.preloaderTemplate = function() {
    return $('#preloaderTemplate').tmpl();
  };
  PhotosView.prototype.headerTemplate = function(items) {
    items.gallery = Gallery.record;
    return $("#headerAlbumTemplate").tmpl(items);
  };
  function PhotosView() {
    PhotosView.__super__.constructor.apply(this, arguments);
    this.list = new PhotoList({
      el: this.items,
      template: this.template
    });
    AlbumsPhoto.bind('beforeDestroy beforeCreate', this.proxy(this.emptyCache));
    AlbumsPhoto.bind('change', this.proxy(this.renderHeader));
    AlbumsPhoto.bind('destroy', this.proxy(this.remove));
    AlbumsPhoto.bind('create', this.proxy(this.add));
    Album.bind('change', this.proxy(this.renderHeader));
    Spine.bind('change:selectedAlbum', this.proxy(this.renderHeader));
    Spine.bind('destroy:photo', this.proxy(this.destroy));
    Spine.bind('show:photos', this.proxy(this.show));
    Spine.bind('change:selectedAlbum', this.proxy(this.change));
    Photo.bind('refresh', this.proxy(this.prepareJoin));
    Photo.bind("create:join", this.proxy(this.createJoin));
    Photo.bind("destroy:join", this.proxy(this.destroyJoin));
    this.filterOptions = {
      key: 'album_id',
      joinTable: 'AlbumsPhoto'
    };
  }
  PhotosView.prototype.change = function(item) {
    var items;
    if (!GalleriesAlbum.galleryHasAlbum(Gallery.record.id, Album.record.id)) {
      Album.record = false;
    }
    items = Photo.filter(item != null ? item.id : void 0, this.filterOptions);
    this.current = items;
    return this.render(items);
  };
  PhotosView.prototype.render = function(items, mode) {
    var album;
    console.log('PhotosView::render');
    album = Album.record;
    if (album) {
      this.el.data(album);
    } else {
      this.el.removeData();
    }
    if (!this.list.children('li').length) {
      this.items.empty();
    }
    this.list.render(items, album, mode || 'html');
    return this.refreshElements();
  };
  PhotosView.prototype.renderHeader = function() {
    var values, _ref;
    console.log('PhotosView::renderHeader');
    values = {
      record: Album.record,
      count: AlbumsPhoto.filter((_ref = Album.record) != null ? _ref.id : void 0, {
        key: 'album_id'
      }).length
    };
    return this.header.html(this.headerTemplate(values));
  };
  PhotosView.prototype.emptyCache = function(record, mode) {
    return Album.emptyCache(record.album_id);
  };
  PhotosView.prototype.remove = function(ap) {
    var photo, photoEl;
    console.log('PhotosView::remove');
    if (!ap.destroyed) {
      return;
    }
    photo = Photo.find(ap.photo_id);
    photoEl = this.items.children().forItem(photo);
    photoEl.remove();
    if (!this.items.children().length) {
      return this.render([]);
    }
  };
  PhotosView.prototype.add = function(ap) {
    var photo;
    console.log('PhotosView::add');
    photo = Photo.find(ap.photo_id);
    return this.render([photo], 'append');
  };
  PhotosView.prototype.destroy = function(e) {
    var list, photo, photos, _i, _len, _results;
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
      _results = [];
      for (_i = 0, _len = photos.length; _i < _len; _i++) {
        photo = photos[_i];
        _results.push(Photo.exists(photo.id) ? (Photo.removeFromSelection(Album, photo.id), photo.destroy()) : void 0);
      }
      return _results;
    }
  };
  PhotosView.prototype.show = function() {
    console.log('show');
    if (this.isActive()) {
      return;
    }
    this.renderHeader();
    return Spine.trigger('change:canvas', this);
  };
  PhotosView.prototype.save = function(item) {};
  PhotosView.prototype.prepareJoin = function(photos) {
    return this.createJoin(Album.record, photos);
  };
  PhotosView.prototype.createJoin = function(target, photos) {
    var ap, record, records, _i, _len;
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
    for (_i = 0, _len = records.length; _i < _len; _i++) {
      record = records[_i];
      ap = new AlbumsPhoto({
        album_id: target.id,
        photo_id: record.id
      });
      ap.save();
    }
    return target.save();
  };
  PhotosView.prototype.destroyJoin = function(target, photos) {
    var ap, aps, records, _i, _len;
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
    for (_i = 0, _len = aps.length; _i < _len; _i++) {
      ap = aps[_i];
      if (photos.indexOf(ap.photo_id) !== -1) {
        Photo.removeFromSelection(Album, ap.photo_id);
        ap.destroy();
      }
    }
    return target.save();
  };
  return PhotosView;
})();
if (typeof module !== "undefined" && module !== null) {
  module.exports = PhotosView;
}