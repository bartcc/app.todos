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
  SidebarList.extend(Spine.Controller.KeyEnhancer);
  SidebarList.prototype.elements = {
    '.gal.item': 'item',
    '.expander': 'expander'
  };
  SidebarList.prototype.events = {
    'click': 'show',
    "click      .gal.item": "click",
    "dblclick   .gal.item": "dblclick",
    "click      .alb.item": "clickAlbum",
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
    Gallery.bind('change', this.proxy(this.change));
    Spine.bind('render:galleryAllSublist', this.proxy(this.renderAllSublist));
    Spine.bind('drag:timeout', this.proxy(this.expandAfterTimeout));
    Spine.bind('expose:sublistSelection', this.proxy(this.exposeSublistSelection));
    Spine.bind('gallery:exposeSelection', this.proxy(this.exposeSelection));
    Spine.bind('gallery:activate', this.proxy(this.activate));
  }
  SidebarList.prototype.template = function() {
    return arguments[0];
  };
  SidebarList.prototype.change = function(item, mode, e) {
    var ctrlClick, _ref, _ref2, _ref3;
    console.log('SidebarList::change');
    ctrlClick = this.isCtrlClick(e != null);
    if (!ctrlClick) {
      switch (mode) {
        case 'create':
          this.current = item;
          this.create(item);
          break;
        case 'update':
          this.current = item;
          break;
        case 'destroy':
          this.current = false;
          this.destroy(item);
          break;
        case 'edit':
          Spine.trigger('edit:gallery');
          break;
        case 'show':
          this.current = item;
          this.navigate('/gallery/' + ((_ref = Gallery.record) != null ? _ref.id : void 0));
          break;
        case 'photo':
          this.current = item;
      }
    } else {
      this.current = false;
      switch (mode) {
        case 'show':
          this.navigate('/gallery/' + ((_ref2 = Gallery.record) != null ? _ref2.id : void 0) + '/' + ((_ref3 = Album.record) != null ? _ref3.id : void 0));
      }
    }
    if (this.current) {
      return this.activate(this.current);
    }
  };
  SidebarList.prototype.create = function(item) {
    this.append(this.template(item));
    return this.reorder(item);
  };
  SidebarList.prototype.update = function(item) {
    this.updateTemplate(item);
    return this.reorder(item);
  };
  SidebarList.prototype.destroy = function(item) {
    return this.children().forItem(item, true).remove();
  };
  SidebarList.prototype.checkChange = function(item, mode) {};
  SidebarList.prototype.render = function(items, mode) {
    console.log('SidebarList::render');
    this.html(this.template(items.sort(Gallery.nameSort)));
    if ((!this.current || this.current.destroyed) && !(mode === 'update')) {
      if (!this.children(".active").length) {
        return App.ready = true;
      }
    }
  };
  SidebarList.prototype.reorder = function(item) {
    var children, id, idxAfterSort, idxBeforeSort, index, newEl, oldEl;
    id = item.id;
    index = function(id, list) {
      var i, itm, _len;
      for (i = 0, _len = list.length; i < _len; i++) {
        itm = list[i];
        if (itm.id === id) {
          return i;
        }
      }
      return i;
    };
    children = this.children();
    oldEl = this.children().forItem(item);
    idxBeforeSort = this.children().index(oldEl);
    idxAfterSort = index(id, Gallery.all().sort(Gallery.nameSort));
    newEl = $(children[idxAfterSort]);
    if (idxBeforeSort < idxAfterSort) {
      return newEl.after(oldEl);
    } else if (idxBeforeSort > idxAfterSort) {
      return newEl.before(oldEl);
    }
  };
  SidebarList.prototype.renderOne = function(item, mode) {
    return console.log('SidebarList::renderOne');
  };
  SidebarList.prototype.renderAll = function(items) {
    return this.html(this.template(items.sort(Gallery.nameSort)));
  };
  SidebarList.prototype.renderAllSublist = function() {
    var gal, _i, _len, _ref, _results;
    console.log('SidebarList::renderAllSublist');
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
    console.log('SidebarList::renderOneSublist');
    if (!gallery) {
      return;
    }
    filterOptions = {
      key: 'gallery_id',
      joinTable: 'GalleriesAlbum',
      sorted: true
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
  SidebarList.prototype.exposeSelection = function(item) {
    if (item == null) {
      item = Gallery.record;
    }
    console.log('SidebarList::exposeSelection');
    this.deselect();
    alert('deselect');
    if (item) {
      this.children().forItem(item).addClass("active");
    }
    return this.exposeSublistSelection();
  };
  SidebarList.prototype.exposeSublistSelection = function() {
    var album, albums, galleryEl, id, removeAlbumSelection, _i, _len, _ref, _ref2, _results;
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
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        id = _ref[_i];
        if (Album.exists(id)) {
          album = Album.find(id);
        }
        _results.push(album ? (albums.forItem(album).addClass('selected'), id === ((_ref2 = Album.record) != null ? _ref2.id : void 0) ? (album = Album.exists(Album.record.id), albums.forItem(album).addClass('active')) : void 0) : void 0);
      }
      return _results;
    } else {
      return removeAlbumSelection();
    }
  };
  SidebarList.prototype.updateTemplate = function(item) {
    var galleryContentEl, galleryEl, tmplItem;
    galleryEl = this.children().forItem(item);
    galleryContentEl = $('.item-content', galleryEl);
    tmplItem = galleryContentEl.tmplItem();
    if (tmplItem) {
      tmplItem.tmpl = $("#sidebarContentTemplate").template();
      return tmplItem.update();
    }
  };
  SidebarList.prototype.renderItemFromGalleriesAlbum = function(ga, mode) {
    var gallery;
    if (Gallery.exists(ga.gallery_id)) {
      gallery = Gallery.find(ga.gallery_id);
    }
    return this.renderOneSublist(gallery);
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
  SidebarList.prototype.exposeSelection_ = function(e) {
    var albumEl, galleryEl;
    this.children().removeClass('active');
    $('.alb', this.el).removeClass('active');
    galleryEl = $(e.target).parents('.gal').addClass('active');
    return albumEl = $(e.target).parents('.alb').addClass('active');
  };
  SidebarList.prototype.activate = function(idOrRecord) {
    var diff, item, _ref;
    item = Gallery.current(idOrRecord);
    diff = (item != null ? item.id : void 0) === !((_ref = Gallery.record) != null ? _ref.id : void 0);
    if (diff) {
      this.navigate('/gallery', item.id);
    }
    return this.exposeSelection();
  };
  SidebarList.prototype.exposeSelection = function(item) {
    if (item == null) {
      item = Gallery.record;
    }
    this.children().removeClass('active');
    if (item) {
      this.children().forItem(item).addClass("active");
    }
    return this.exposeSublistSelection();
  };
  SidebarList.prototype.exposeSublistSelection = function() {
    var album, albums, galleryEl, id, removeAlbumSelection, _i, _len, _ref, _ref2, _results;
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
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        id = _ref[_i];
        if (Album.exists(id)) {
          album = Album.find(id);
        }
        _results.push(album ? (albums.forItem(album).addClass('selected'), id === ((_ref2 = Album.record) != null ? _ref2.id : void 0) ? (album = Album.exists(Album.record.id), albums.forItem(album).addClass('active')) : void 0) : void 0);
      }
      return _results;
    } else {
      return removeAlbumSelection();
    }
  };
  SidebarList.prototype.clickAlbum = function(e) {
    var album, albumEl, gallery, galleryEl;
    galleryEl = $(e.target).parents('.gal').addClass('active');
    albumEl = $(e.currentTarget);
    galleryEl = $(e.currentTarget).closest('.gal');
    album = albumEl.item();
    gallery = galleryEl.item();
    if (!this.isCtrlClick(e)) {
      album.updateSelection([album.id]);
      this.navigate('/gallery', gallery.id + '/' + album.id);
    } else {
      this.navigate('/photos/');
    }
    this.exposeSelection_(e);
    e.stopPropagation();
    return e.preventDefault();
  };
  SidebarList.prototype.click = function(e) {
    var item;
    console.log('SidebarList::click');
    $(e.currentTarget).closest('.gal').addClass('active');
    item = $(e.target).closest('.data').item();
    App.contentManager.change(App.showView);
    this.navigate('/gallery', (item != null ? item.id : void 0) || '');
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
  SidebarList.prototype.expandAfterTimeout = function(e) {
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
  SidebarList.prototype.close = function() {};
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
