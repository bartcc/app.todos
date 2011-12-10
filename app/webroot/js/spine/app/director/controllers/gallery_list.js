var $, GalleryList;
var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; }, __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
if (typeof Spine === "undefined" || Spine === null) {
  Spine = require("spine");
}
$ = Spine.$;
GalleryList = (function() {
  __extends(GalleryList, Spine.Controller);
  GalleryList.extend(Spine.Controller.Drag);
  GalleryList.prototype.elements = {
    '.gal.item': 'item',
    '.expander': 'expander'
  };
  GalleryList.prototype.events = {
    'click': 'show',
    "click      .gal.item": "click",
    "dblclick   .gal.item": "dblclick",
    "click      .alb.item": "clickAlb",
    "click      .expander": "expand",
    'dragstart  .sublist-item': 'dragstart',
    'dragenter  .sublist-item': 'dragenter',
    'dragover   .sublist-item': 'dragover',
    'dragleave  .sublist-item': 'dragleave',
    'drop       .sublist-item': 'drop',
    'dragend    .sublist-item': 'dragend'
  };
  GalleryList.prototype.selectFirst = false;
  GalleryList.prototype.contentTemplate = function(items) {
    return $('#galleriesContentTemplate').tmpl(items);
  };
  GalleryList.prototype.sublistTemplate = function(items) {
    return $('#albumsSublistTemplate').tmpl(items);
  };
  GalleryList.prototype.ctaTemplate = function(item) {
    return $('#ctaTemplate').tmpl(item);
  };
  function GalleryList() {
    this.change = __bind(this.change, this);    GalleryList.__super__.constructor.apply(this, arguments);
    AlbumsPhoto.bind('change', this.proxy(this.renderItemFromAlbumsPhoto));
    GalleriesAlbum.bind('change', this.proxy(this.renderItemFromGalleriesAlbum));
    Album.bind('change', this.proxy(this.renderItemFromAlbum));
    Spine.bind('render:galleryAllSublist', this.proxy(this.renderAllSublist));
    Spine.bind('drag:timeout', this.proxy(this.expandExpander));
    Spine.bind('expose:sublistSelection', this.proxy(this.exposeSublistSelection));
    Spine.bind('gallery:exposeSelection', this.proxy(this.exposeSelection));
  }
  GalleryList.prototype.template = function() {
    return arguments[0];
  };
  GalleryList.prototype.change = function(item, mode, e) {
    var ctrlClick;
    console.log('GalleryList::change');
    this.deselect();
    if (e) {
      ctrlClick = this.isCtrlClick(e);
    }
    if (!ctrlClick) {
      switch (mode) {
        case 'destroy':
          this.current = false;
          break;
        case 'edit':
          Spine.trigger('edit:gallery');
          break;
        case 'show':
          this.current = item;
          Spine.trigger('show:albums');
          break;
        case 'photo':
          this.current = item;
          break;
        case 'create':
          this.current = item;
      }
      this.exposeSelection(this.current);
    } else {
      this.current = false;
      switch (mode) {
        case 'show':
          Spine.trigger('show:albums');
      }
    }
    Gallery.current(this.current);
    this.exposeSublistSelection(Gallery.record);
    return Spine.trigger('change:selectedGallery', this.current, mode);
  };
  GalleryList.prototype.render = function(galleries, gallery, mode) {
    console.log('GalleryList::render');
    if (gallery && mode) {
      switch (mode) {
        case 'update':
          this.updateTemplate(gallery);
          break;
        case 'create':
          this.append(this.template(gallery));
          break;
        case 'destroy':
          this.children().forItem(gallery, true).remove();
      }
    } else if (galleries) {
      this.items = galleries;
      this.html(this.template(this.items));
    }
    this.change(gallery, mode);
    if ((!this.current || this.current.destroyed) && !(mode === 'update')) {
      if (!this.children(".active").length) {
        App.ready = true;
        return this.children(":first").click();
      }
    }
  };
  GalleryList.prototype.renderAllSublist = function() {
    var gal, _i, _len, _ref, _results;
    _ref = Gallery.records;
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      gal = _ref[_i];
      _results.push(this.renderOneSublist(gal));
    }
    return _results;
  };
  GalleryList.prototype.renderOneSublist = function(gallery) {
    var album, albums, filterOptions, galleryEl, gallerySublist, _i, _len;
    if (gallery == null) {
      gallery = Gallery.record;
    }
    console.log('GalleryList::renderSublist');
    if (!gallery) {
      return;
    }
    filterOptions = {
      key: 'gallery_id',
      joinTable: 'GalleriesAlbum'
    };
    albums = Album.filter(gallery.id, filterOptions);
    for (_i = 0, _len = albums.length; _i < _len; _i++) {
      album = albums[_i];
      album.count = AlbumsPhoto.filter(album.id, {
        key: 'album_id'
      }).length;
    }
    if (!albums.length) {
      albums.push({
        flash: 'no albums'
      });
    }
    galleryEl = this.children().forItem(gallery);
    gallerySublist = $('ul', galleryEl);
    gallerySublist.html(this.sublistTemplate(albums));
    return this.updateTemplate(gallery);
  };
  GalleryList.prototype.updateTemplate = function(gallery) {
    var galleryContentEl, galleryEl, tmplItem;
    galleryEl = this.children().forItem(gallery);
    galleryContentEl = $('.item-content', galleryEl);
    tmplItem = galleryContentEl.tmplItem();
    tmplItem.tmpl = $("#galleriesContentTemplate").template();
    tmplItem.update();
    return this.exposeSublistSelection(gallery);
  };
  GalleryList.prototype.renderItemFromGalleriesAlbum = function(ga, mode) {
    var gallery;
    if (Gallery.exists(ga.gallery_id)) {
      gallery = Gallery.find(ga.gallery_id);
    }
    return this.renderOneSublist(gallery);
  };
  GalleryList.prototype.renderItemFromAlbum = function(album) {
    var ga, gas, _i, _len, _results;
    gas = GalleriesAlbum.filter(album.id, {
      key: 'album_id'
    });
    _results = [];
    for (_i = 0, _len = gas.length; _i < _len; _i++) {
      ga = gas[_i];
      _results.push(this.renderItemFromGalleriesAlbum(ga));
    }
    return _results;
  };
  GalleryList.prototype.renderItemFromAlbumsPhoto = function(ap) {
    var ga, gas, _i, _len, _results;
    gas = GalleriesAlbum.filter(ap.album_id, {
      key: 'album_id'
    });
    _results = [];
    for (_i = 0, _len = gas.length; _i < _len; _i++) {
      ga = gas[_i];
      _results.push(this.renderItemFromGalleriesAlbum(ga));
    }
    return _results;
  };
  GalleryList.prototype.exposeSelection = function(gallery) {
    console.log('GalleryList::exposeSelection');
    if (gallery) {
      return this.children().forItem(gallery).addClass("active");
    }
  };
  GalleryList.prototype.exposeSublistSelection = function(gallery) {
    var album, albums, galleryEl, id, item, list, removeAlbumSelection, val, _i, _len, _ref, _results;
    console.log('GalleryList::exposeSublistSelection');
    removeAlbumSelection = __bind(function() {
      var albums, galleries, galleryEl, item, val, _i, _len, _ref, _results;
      galleries = [];
      _ref = Gallery.records;
      for (item in _ref) {
        val = _ref[item];
        galleries.push(val);
      }
      _results = [];
      for (_i = 0, _len = galleries.length; _i < _len; _i++) {
        item = galleries[_i];
        galleryEl = this.children().forItem(item);
        albums = galleryEl.find('li');
        _results.push(albums.removeClass('active'));
      }
      return _results;
    }, this);
    list = [];
    if (!gallery) {
      removeAlbumSelection();
      _ref = Gallery.records;
      for (item in _ref) {
        val = _ref[item];
        list.push(val);
      }
    } else {
      removeAlbumSelection();
      list.push(gallery);
    }
    _results = [];
    for (_i = 0, _len = list.length; _i < _len; _i++) {
      item = list[_i];
      galleryEl = this.children().forItem(item);
      albums = galleryEl.find('li');
      _results.push((function() {
        var _j, _len2, _ref2, _results2;
        _ref2 = Gallery.selectionList();
        _results2 = [];
        for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
          id = _ref2[_j];
          if (Album.exists(id)) {
            album = Album.find(id);
          }
          _results2.push(albums.forItem(album).addClass('active'));
        }
        return _results2;
      })());
    }
    return _results;
  };
  GalleryList.prototype.clickAlb = function(e) {
    var album, albumEl, gallery, galleryEl, previous;
    console.log('GalleryList::albclick');
    albumEl = $(e.currentTarget);
    galleryEl = $(e.currentTarget).closest('li.gal');
    album = albumEl.item();
    gallery = galleryEl.item();
    if (!this.isCtrlClick(e)) {
      previous = Album.record;
      Gallery.current(gallery);
      Album.current(album);
      Gallery.updateSelection([album.id]);
      if (App.hmanager.hasActive()) {
        this.openPanel('album', App.showView.btnAlbum);
      }
      this.exposeSublistSelection(Gallery.record);
      App.showView.trigger('change:toolbar', 'Photo');
      Spine.trigger('change:selectedAlbum', album, !previous || !(album.id === previous.id));
      Spine.trigger('show:photos');
      this.change(Gallery.record, 'photo', e);
    } else {
      Spine.trigger('show:allPhotos', true);
    }
    e.stopPropagation();
    e.preventDefault();
    return false;
  };
  GalleryList.prototype.click = function(e) {
    var item;
    console.log('GalleryList::click');
    item = $(e.currentTarget).item();
    this.change(item, 'show', e);
    App.showView.trigger('change:toolbar', 'Gallery');
    e.stopPropagation();
    e.preventDefault();
    return false;
  };
  GalleryList.prototype.dblclick = function(e) {
    var item;
    console.log('GalleryList::edit');
    item = $(e.target).item();
    App.showView.lockToolbar();
    this.change(item, 'edit', e);
    App.showView.unlockToolbar();
    e.stopPropagation();
    e.preventDefault();
    return false;
  };
  GalleryList.prototype.expandExpander = function(e) {
    var closest, el, expander;
    el = $(e.target);
    closest = (el.closest('.item')) || [];
    if (closest.length) {
      expander = $('.expander', closest);
      if (expander.length) {
        return this.expand(e, true);
      }
    }
  };
  GalleryList.prototype.expand = function(e, force) {
    var content, gallery, icon, parent;
    if (force == null) {
      force = false;
    }
    parent = $(e.target).parents('li');
    gallery = parent.item();
    icon = $('.expander', parent);
    content = $('.sublist', parent);
    if (force) {
      icon.toggleClass('expand', force);
    } else {
      icon.toggleClass('expand');
    }
    if ($('.expand', parent).length) {
      this.renderOneSublist(gallery);
      this.exposeSublistSelection(Gallery.record);
      content.show();
    } else {
      content.hide();
    }
    e.stopPropagation();
    e.preventDefault();
    return false;
  };
  GalleryList.prototype.show = function(e) {
    App.contentManager.change(App.showView);
    e.stopPropagation();
    e.preventDefault();
    return false;
  };
  return GalleryList;
})();
if (typeof module !== "undefined" && module !== null) {
  module.exports = GalleryList;
}