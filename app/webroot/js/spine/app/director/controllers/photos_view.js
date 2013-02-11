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
    'dragstart  .items .thumbnail': 'dragstart',
    'dragover   .items .thumbnail': 'dragover'
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
    GalleriesAlbum.bind('destroy', this.proxy(this.redirect));
    Gallery.bind('change', this.proxy(this.renderHeader));
    Album.bind('change', this.proxy(this.renderHeader));
    Photo.bind('refresh destroy', this.proxy(this.renderHeader));
    Photo.bind('refresh', this.proxy(this.refresh));
    Photo.bind('beforeDestroy', this.proxy(this.remove));
    Photo.bind('create:join', this.proxy(this.createJoin));
    Photo.bind('destroy:join', this.proxy(this.destroyJoin));
    Photo.bind('ajaxError', Photo.errorHandler);
    Spine.bind('destroy:photo', this.proxy(this.destroy));
    Spine.bind('show:photos', this.proxy(this.show));
    Spine.bind('change:selectedAlbum', this.proxy(this.renderHeader));
    Spine.bind('change:selectedAlbum', this.proxy(this.change));
    Spine.bind('start:slideshow', this.proxy(this.slideshow));
    Spine.bind('album:updateBuffer', this.proxy(this.updateBuffer));
    Spine.bind('slideshow:ready', this.proxy(this.play));
  }
  PhotosView.prototype.change = function(item, changed) {
    if (changed) {
      this.updateBuffer(item);
    }
    if (this.buffer) {
      return this.render(this.buffer);
    }
  };
  PhotosView.prototype.updateBuffer = function(album) {
    var filterOptions;
    filterOptions = {
      key: 'album_id',
      joinTable: 'AlbumsPhoto',
      sorted: true
    };
    return this.buffer = Photo.filterRelated(album != null ? album.id : void 0, filterOptions);
  };
  PhotosView.prototype.render = function(items, mode) {
    var list;
    console.log('PhotosView::render');
    if (!this.isActive()) {
      return;
    }
    list = this.list.render(items, mode);
    list.sortable('photo');
    return delete this.buffer;
  };
  PhotosView.prototype.renderHeader = function() {
    console.log('PhotosView::renderHeader');
    return this.header.change();
  };
  PhotosView.prototype.clearPhotoCache = function() {
    return Photo.clearCache();
  };
  PhotosView.prototype.remove = function(record) {
    var photoEl;
    console.log('PhotosView::remove');
    if (record.constructor.className !== 'Photo') {
      record = Photo.exists(record.photo_id);
    }
    photoEl = this.items.children().forItem(record, true);
    return photoEl.remove();
  };
  PhotosView.prototype.redirect = function(ga) {
    if (ga.destroyed) {
      return this.navigate('/gallery', Gallery.record.id);
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
      return Photo.trigger('destroy:join', photos, Album.record);
    } else {
      for (_i = 0, _len = photos.length; _i < _len; _i++) {
        photo = photos[_i];
        aps = AlbumsPhoto.filter(photo.id, {
          key: 'photo_id'
        });
        for (_j = 0, _len2 = aps.length; _j < _len2; _j++) {
          ap = aps[_j];
          album = Album.exists(ap.album_id);
          Spine.Ajax.disable(function() {
            if (album) {
              return Photo.trigger('destroy:join', photo, album);
            }
          });
        }
      }
      _results = [];
      for (_k = 0, _len3 = photos.length; _k < _len3; _k++) {
        photo = photos[_k];
        Album.removeFromSelection(photo.id);
        photo.destroyCache();
        _results.push(photo.destroy());
      }
      return _results;
    }
  };
  PhotosView.prototype.show = function() {
    App.showView.trigger('change:toolbarOne', ['Default', 'Slider', App.showView.initSlider]);
    App.showView.trigger('change:toolbarTwo', ['Slideshow']);
    return App.showView.trigger('canvas', this);
  };
  PhotosView.prototype.save = function(item) {};
  PhotosView.prototype.refresh = function(photos) {
    return;
    if (Album.record) {
      this.createJoin(photos, Album.record);
    } else {
      this.render(photos);
    }
    return this.renderHeader();
  };
  PhotosView.prototype.refresh = function(photos) {
    return this.renderHeader();
  };
  PhotosView.prototype.add = function(ap) {
    var photo, _ref;
    console.log('PhotosView::add');
    if (ap.album_id === ((_ref = Album.record) != null ? _ref.id : void 0)) {
      photo = Photo.exists(ap.photo_id);
      if (photo) {
        return this.render([photo], 'append');
      }
    }
  };
  PhotosView.prototype.createJoin = function(photos, target) {
    var ap, record, records, _i, _len, _results;
    console.log('PhotosView::createJoin');
    if (!(target && target.constructor.className === 'Album')) {
      return;
    }
    console.log(target.id);
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
        order: AlbumsPhoto.photos(target.id).length
      });
      _results.push(ap.save());
    }
    return _results;
  };
  PhotosView.prototype.destroyJoin = function(photos, target) {
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
