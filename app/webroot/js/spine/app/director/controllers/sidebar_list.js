var $, SidebarList;
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
SidebarList = (function() {
  __extends(SidebarList, Spine.Controller);
  SidebarList.extend(Spine.Controller.Drag);
  SidebarList.prototype.elements = {
    '.gal.item': 'item',
    '.expander': 'expander'
  };
  SidebarList.prototype.events = {
    'click': 'show',
    "click      .gal.item": "click",
    "dblclick   .gal.item": "dblclick",
    "click      .alb.item": "clickAlb",
    "click      .expander": "expand",
    'dragstart  .sublist-item': 'dragstart',
    'dragenter  .sublist-item': 'dragenter',
    'dragleave  .sublist-item': 'dragleave',
    'drop       .sublist-item': 'drop',
    'dragend    .sublist-item': 'dragend'
  };
  SidebarList.prototype.selectFirst = false;
  SidebarList.prototype.contentTemplate = function(items) {
    return $('#sidebarContentTemplate').tmpl(items);
  };
  SidebarList.prototype.sublistTemplate = function(items) {
    return $('#albumsSublistTemplate').tmpl(items);
  };
  SidebarList.prototype.ctaTemplate = function(item) {
    return $('#ctaTemplate').tmpl(item);
  };
  function SidebarList() {
    this.change = __bind(this.change, this);    SidebarList.__super__.constructor.apply(this, arguments);
    AlbumsPhoto.bind('change', this.proxy(this.renderItemFromAlbumsPhoto));
    GalleriesAlbum.bind('change', this.proxy(this.renderItemFromGalleriesAlbum));
    Album.bind('change', this.proxy(this.renderItemFromAlbum));
    Spine.bind('render:galleryAllSublist', this.proxy(this.renderAllSublist));
    Spine.bind('drag:timeout', this.proxy(this.expandExpander));
    Spine.bind('expose:sublistSelection', this.proxy(this.exposeSublistSelection));
    Spine.bind('gallery:activate', this.proxy(this.activate));
  }
  SidebarList.prototype.template = function() {
    return arguments[0];
  };
  SidebarList.prototype.change = function(item, mode, e) {
    var ctrlClick;
    console.log('SidebarList::change');
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
    } else {
      this.current = false;
      switch (mode) {
        case 'show':
          Spine.trigger('show:albums');
      }
    }
    Gallery.current(this.current);
    return this.exposeSelection();
  };
  SidebarList.prototype.render = function(galleries, gallery, mode) {
    console.log('SidebarList::render');
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
  SidebarList.prototype.renderAllSublist = function() {
    var gal, _i, _len, _ref, _results;
    _ref = Gallery.records;
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      gal = _ref[_i];
      _results.push(this.renderOneSublist(gal));
    }
    return _results;
  };
  SidebarList.prototype.renderOneSublist = function(gallery) {
    var album, albums, filterOptions, galleryEl, gallerySublist, _i, _len;
    if (gallery == null) {
      gallery = Gallery.record;
    }
    console.log('SidebarList::renderSublist');
    if (!gallery) {
      return;
    }
    filterOptions = {
      key: 'gallery_id',
      joinTable: 'GalleriesAlbum'
    };
    albums = Album.filterRelated(gallery.id, filterOptions);
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
  SidebarList.prototype.activate = function() {
    var active, first, selectedAlbums, selectedPhotos;
    selectedAlbums = Gallery.selectionList();
    if (selectedAlbums.length === 1) {
      if (Album.exists(selectedAlbums[0])) {
        first = Album.find(selectedAlbums[0]);
      }
      if (first && !first.destroyed) {
        Album.current(first);
      } else {
        Album.current();
      }
    } else {
      Album.current();
    }
    selectedPhotos = Album.selectionList();
    if (selectedPhotos.length === 1) {
      if (Photo.exists(selectedPhotos[0])) {
        active = Photo.find(selectedPhotos[0]);
      }
      if (active && !active.destroyed) {
        Photo.current(active);
      } else {
        Photo.current();
      }
    } else {
      Photo.current();
    }
    return this.exposeSelection();
  };
  SidebarList.prototype.updateTemplate = function(gallery) {
    var galleryContentEl, galleryEl, tmplItem;
    galleryEl = this.children().forItem(gallery);
    galleryContentEl = $('.item-content', galleryEl);
    tmplItem = galleryContentEl.tmplItem();
    tmplItem.tmpl = $("#sidebarContentTemplate").template();
    tmplItem.update();
    return this.exposeSublistSelection(gallery);
  };
  SidebarList.prototype.renderItemFromGalleriesAlbum = function(ga, mode) {
    var gallery;
    if (Gallery.exists(ga.gallery_id)) {
      gallery = Gallery.find(ga.gallery_id);
    }
    return this.renderOneSublist(gallery);
  };
  SidebarList.prototype.renderItemFromAlbum = function(album) {
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
  SidebarList.prototype.renderItemFromAlbumsPhoto = function(ap) {
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
  SidebarList.prototype.exposeSelection = function() {
    var gallery;
    console.log('SidebarList::exposeSelection');
    gallery = Gallery.record;
    this.deselect();
    if (gallery) {
      this.children().forItem(gallery).addClass("active");
    }
    return this.exposeSublistSelection();
  };
  SidebarList.prototype.exposeSublistSelection = function() {
    var album, albums, galleryEl, id, removeAlbumSelection, _i, _len, _ref, _ref2;
    console.log('SidebarList::exposeSublistSelection');
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
        _results.push(albums.removeClass('selected').removeClass('active'));
      }
      return _results;
    }, this);
    if (Gallery.record) {
      removeAlbumSelection();
      galleryEl = this.children().forItem(Gallery.record);
      albums = galleryEl.find('li');
      _ref = Gallery.selectionList();
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        id = _ref[_i];
        if (Album.exists(id)) {
          album = Album.find(id);
        }
        albums.forItem(album).addClass('selected');
      }
      if (Album.exists((_ref2 = Album.activeRecord) != null ? _ref2.id : void 0)) {
        album = Album.find(Album.activeRecord.id);
        return albums.forItem(album).addClass('active');
      }
    } else {
      return removeAlbumSelection();
    }
  };
  SidebarList.prototype.clickAlb = function(e) {
    var album, albumEl, gallery, galleryEl;
    console.log('SidebarList::albclick');
    albumEl = $(e.currentTarget);
    galleryEl = $(e.currentTarget).closest('li.gal');
    album = Album.activeRecord = albumEl.item();
    gallery = galleryEl.item();
    if (!this.isCtrlClick(e)) {
      Gallery.current(gallery);
      Album.current(album);
      Gallery.updateSelection([album.id]);
      this.exposeSublistSelection(Gallery.record);
      Spine.trigger('show:photos');
      this.change(Gallery.record, 'photo', e);
    } else {
      Spine.trigger('show:allPhotos', true);
    }
    e.stopPropagation();
    return e.preventDefault();
  };
  SidebarList.prototype.click = function(e) {
    var item;
    console.log('SidebarList::click');
    item = $(e.currentTarget).item();
    this.change(item, 'show', e);
    Spine.trigger('change:toolbar', ['Gallery']);
    App.contentManager.change(App.showView);
    e.stopPropagation();
    return e.preventDefault();
  };
  SidebarList.prototype.dblclick = function(e) {
    var item;
    console.log('SidebarList::dblclick');
    item = $(e.target).item();
    this.change(item, 'edit', e);
    e.stopPropagation();
    return e.preventDefault();
  };
  SidebarList.prototype.expandExpander = function(e) {
    var closest, el, expander;
    clearTimeout(Spine.timer);
    el = $(e.target);
    closest = (el.closest('.item')) || [];
    if (closest.length) {
      expander = $('.expander', closest);
      if (expander.length) {
        return this.expand(e, true);
      }
    }
  };
  SidebarList.prototype.expand = function(e, force) {
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
    return e.preventDefault();
  };
  SidebarList.prototype.show = function(e) {
    App.contentManager.change(App.showView);
    e.stopPropagation();
    return e.preventDefault();
  };
  return SidebarList;
})();
if (typeof module !== "undefined" && module !== null) {
  module.exports = SidebarList;
}