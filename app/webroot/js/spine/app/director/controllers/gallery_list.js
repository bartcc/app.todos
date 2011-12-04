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
  function GalleryList() {
    this.change = __bind(this.change, this);    GalleryList.__super__.constructor.apply(this, arguments);
    Spine.bind('drag:timeout', this.proxy(this.expandExpander));
    Spine.bind('expose:sublistSelection', this.proxy(this.exposeSublistSelection));
    Spine.bind('close:album', this.proxy(this.change));
    this.filterOptions = {
      key: 'gallery_id',
      joinTable: 'GalleriesAlbum'
    };
  }
  GalleryList.prototype.template = function() {
    return arguments[0];
  };
  GalleryList.prototype.change = function(item, mode, e) {
    var cmdKey, dblclick, previous, _ref;
    console.log('GalleryList::change');
    previous = this.current;
    if (e) {
      cmdKey = this.isCtrlClick(e);
      dblclick = e.type === 'dblclick';
    }
    this.children().removeClass("active");
    if (!cmdKey && item) {
      switch (mode) {
        case 'destroy':
          this.current = false;
          break;
        default:
          if (mode !== 'update') {
            this.current = item;
          }
          this.children().forItem(this.current).addClass("active");
      }
    } else {
      this.current = false;
    }
    Gallery.current(this.current);
    if ((previous != null ? previous.id : void 0) !== ((_ref = this.current) != null ? _ref.id : void 0) || cmdKey) {
      Spine.trigger('change:selectedGallery', this.current, mode);
    }
    if (mode === 'edit') {
      return App.showView.btnEditGallery.click();
    } else if (mode === 'show') {
      return Spine.trigger('show:albums');
    }
  };
  GalleryList.prototype.render = function(galleries, gallery, mode) {
    var galleryContentEl, galleryEl, tmplItem;
    console.log('GalleryList::render');
    if (gallery && mode) {
      switch (mode) {
        case 'update':
          galleryEl = this.children().forItem(gallery);
          galleryContentEl = $('.item-content', galleryEl);
          tmplItem = galleryContentEl.tmplItem();
          tmplItem.tmpl = $("#galleriesContentTemplate").template();
          if (Gallery.record.id !== gallery.id) {
            tmplItem.update();
          }
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
  GalleryList.prototype.renderSublist = function(gallery) {
    var albums, galleryEl, gallerySublist;
    console.log('GalleryList::renderSublist');
    albums = Album.filter(gallery.id, this.filterOptions);
    if (!albums.length) {
      albums.push({
        flash: 'no albums'
      });
    }
    galleryEl = this.children().forItem(gallery);
    gallerySublist = $('ul', galleryEl);
    gallerySublist.html(this.sublistTemplate(albums));
    return this.renderCounts(galleryEl, gallery, albums);
  };
  GalleryList.prototype.renderCounts = function(el, gallery, albums) {
    var album, total, _i, _len;
    total = 0;
    for (_i = 0, _len = albums.length; _i < _len; _i++) {
      album = albums[_i];
      total += album.count = AlbumsPhoto.filter(album.id, {
        key: 'album_id'
      }).length;
    }
    return $('.item-header .cta', el).html(albums.length + ' <span style="font-size: 0.5em;">(' + total + ')</span>');
  };
  GalleryList.prototype.exposeSublistSelection = function(gallery) {
    var album, albums, galleryEl, id, _i, _len, _ref, _results;
    console.log('GalleryList::exposeSublistSelection');
    galleryEl = this.children().forItem(gallery);
    albums = galleryEl.find('li');
    albums.removeClass('active');
    _ref = Gallery.selectionList();
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      id = _ref[_i];
      if (Album.exists(id)) {
        album = Album.find(id);
      }
      _results.push(albums.forItem(album).addClass('active'));
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
    Gallery.current(gallery);
    if (!this.isCtrlClick(e)) {
      previous = Album.record;
      Album.current(album);
      Gallery.updateSelection([album.id]);
      if (App.hmanager.hasActive()) {
        this.openPanel('album', App.showView.btnAlbum);
      }
    } else {
      Album.current();
      Gallery.emptySelection();
      Album.emptySelection();
    }
    this.change(gallery);
    this.exposeSublistSelection(gallery);
    App.showView.trigger('change:toolbar', 'Album');
    Spine.trigger('show:photos');
    if (album.id !== (previous != null ? previous.id : void 0)) {
      Spine.trigger('change:selectedAlbum', album);
    }
    e.stopPropagation();
    e.preventDefault();
    return false;
  };
  GalleryList.prototype.click = function(e) {
    var item;
    console.log('GalleryList::click');
    item = $(e.target).item();
    this.change(item, 'show', e);
    this.exposeSublistSelection(item);
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
      this.renderSublist(gallery);
      this.exposeSublistSelection(gallery);
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