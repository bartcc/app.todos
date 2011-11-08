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
    '.header': 'header',
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
    Photo.bind('refresh', this.proxy(this.prepareJoin));
    Spine.bind('destroy:photo', this.proxy(this.destroy));
    Spine.bind('show:photos', this.proxy(this.show));
    Spine.bind('change:selectedAlbum', this.proxy(this.change));
    Photo.bind("create:join", this.proxy(this.createJoin));
    Photo.bind("destroy:join", this.proxy(this.destroyJoin));
    this.bind("render:header", this.proxy(this.renderHeader));
  }
  PhotosView.prototype.change = function(item) {
    var items;
    this.current = item || Album.record;
    if (!GalleriesAlbum.galleryHasAlbum(Gallery.record.id, Album.record.id)) {
      Album.record = false;
      App.showView.trigger('render:toolbar');
    }
    items = Photo.filter(item != null ? item.id : void 0);
    return this.render(items);
  };
  PhotosView.prototype.render = function(items) {
    console.log('PhotosView::render');
    this.el.data(Album.record || {});
    this.items.html(this.preloaderTemplate());
    this.list.render(items);
    this.refreshElements();
    return this.trigger('render:header', items);
  };
  PhotosView.prototype.renderHeader = function(items) {
    var values;
    console.log('PhotosView::renderHeader');
    values = {
      record: Album.record,
      count: items.length
    };
    return this.header.html(this.headerTemplate(values));
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
      return Spine.trigger('destroy:photoJoin', Album.record, photos);
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
    console.log(target);
    console.log(photos);
    if (!Photo.isArray(photos)) {
      records = [];
      records.push(photos);
    } else {
      records = photos;
    }
    console.log(records);
    for (_i = 0, _len = records.length; _i < _len; _i++) {
      record = records[_i];
      ap = new AlbumsPhoto({
        album_id: target.id,
        photo_id: record.id
      });
      console.log(ap);
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
    aps = AlbumsPhoto.filter(target.id);
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