var $, AlbumsList;
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
AlbumsList = (function() {
  __extends(AlbumsList, Spine.Controller);
  AlbumsList.prototype.events = {
    'click .item': 'click',
    'click .more-icon.delete': 'deleteAlbum',
    'dblclick .item': 'dblclick',
    'mouseenter .item': 'infoEnter',
    'mousemove': 'infoMove',
    'mousemove .item': 'infoUp',
    'mouseleave .item': 'infoBye',
    'dragstart .item': 'stopInfo'
  };
  function AlbumsList() {
    this.stopInfo = __bind(this.stopInfo, this);
    this.infoBye = __bind(this.infoBye, this);
    this.infoUp = __bind(this.infoUp, this);
    this.callback = __bind(this.callback, this);    AlbumsList.__super__.constructor.apply(this, arguments);
    Album.bind('sortupdate', this.proxy(this.sortupdate));
    Photo.bind('sortupdate', this.proxy(this.invalidateAlbum));
    GalleriesAlbum.bind('destroy', this.proxy(this.sortupdate));
    Photo.bind('refresh', this.proxy(this.refreshBackgrounds));
    AlbumsPhoto.bind('beforeDestroy beforeCreate', this.proxy(this.clearAlbumCache));
    AlbumsPhoto.bind('beforeDestroy', this.proxy(this.widowedAlbums));
    AlbumsPhoto.bind('destroy create', this.proxy(this.changeBackgrounds));
    Album.bind("ajaxError", Album.errorHandler);
    Spine.bind('album:activate', this.proxy(this.activate));
  }
  AlbumsList.prototype.template = function() {
    return arguments[0];
  };
  AlbumsList.prototype.albumPhotosTemplate = function(items) {
    return $('#albumPhotosTemplate').tmpl(items);
  };
  AlbumsList.prototype.change = function(items) {
    return this.renderBackgrounds(items);
  };
  AlbumsList.prototype.select = function(item, e) {
    return this.activate();
  };
  AlbumsList.prototype.exposeSelection = function() {
    var el, id, item, list, _i, _len;
    list = Gallery.selectionList();
    this.deselect();
    for (_i = 0, _len = list.length; _i < _len; _i++) {
      id = list[_i];
      if (Album.exists(id)) {
        item = Album.find(id);
        el = this.children().forItem(item);
        el.addClass("active");
      }
    }
    return Spine.trigger('expose:sublistSelection', Gallery.record);
  };
  AlbumsList.prototype.activate = function() {
    var first, selection;
    selection = Gallery.selectionList();
    if (selection.length === 1) {
      if (Album.exists(selection[0])) {
        first = Album.find(selection[0]);
      }
      if (!(first != null ? first.destroyed : void 0)) {
        this.current = first;
        Album.current(first);
      }
    } else {
      Album.current();
    }
    return this.exposeSelection();
  };
  AlbumsList.prototype.render = function(items, mode) {
    console.log('AlbumsList::render');
    this.el.toggleClass('all', !Gallery.record);
    if (items.length) {
      this.html(this.template(items));
    } else {
      if (Album.count()) {
        this.html('<label class="invite"><span class="enlightened">This Gallery has no albums. &nbsp;<button class="optCreateAlbum dark large">New Album</button><button class="optShowAllAlbums dark large">Show available Albums</button></span></label>');
      } else {
        this.html('<label class="invite"><span class="enlightened">Time to create a new album. &nbsp;<button class="optCreateAlbum dark large">New Album</button></span></label>');
      }
    }
    this.change(items, mode);
    return this.el;
  };
  AlbumsList.prototype.deleteAlbum = function(e) {
    var item;
    item = $(e.target).closest('.item').item();
    Gallery.updateSelection(item.id);
    Spine.trigger('destroy:album');
    this.stopInfo();
    return false;
  };
  AlbumsList.prototype.clearAlbumCache = function(record) {
    var id;
    id = (record != null ? record.album_id : void 0) || (record != null ? record.id : void 0);
    if (id) {
      return Album.clearCache(id);
    }
  };
  AlbumsList.prototype.invalidateAlbum = function() {
    if (Album.record) {
      return Album.record.clearCache();
    }
  };
  AlbumsList.prototype.refreshBackgrounds = function(alb) {
    var album;
    album = App.upload.album ||  alb;
    if (album) {
      this.renderBackgrounds([album]);
    }
    return album;
  };
  AlbumsList.prototype.changeBackgrounds = function(ap, mode) {
    var albums;
    console.log('AlbumsList::changeBackgrounds');
    albums = ap.albums();
    return this.renderBackgrounds(albums);
  };
  AlbumsList.prototype.widowedAlbums = function(ap) {
    return this.widows = ap.albums();
  };
  AlbumsList.prototype.renderBackgrounds = function(albums) {
    var album, _i, _j, _len, _len2, _ref, _ref2, _results;
    if (!App.ready) {
      return;
    }
    if (albums.length) {
      _results = [];
      for (_i = 0, _len = albums.length; _i < _len; _i++) {
        album = albums[_i];
        _results.push(this.processAlbum(album));
      }
      return _results;
    } else if ((_ref = this.widows) != null ? _ref.length : void 0) {
      _ref2 = this.widows;
      for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
        album = _ref2[_j];
        this.processAlbum(album);
      }
      return this.widows = [];
    }
  };
  AlbumsList.prototype.processAlbum = function(album) {
    return album.uri({
      width: 50,
      height: 50
    }, 'html', __bind(function(xhr, album) {
      return this.callback(xhr, album);
    }, this), 4);
  };
  AlbumsList.prototype.callback = function(json, item) {
    var arr, css, el, itm, searchJSON;
    el = this.children().forItem(item);
    searchJSON = function(itm) {
      var key, value, _results;
      _results = [];
      for (key in itm) {
        value = itm[key];
        _results.push(value);
      }
      return _results;
    };
    css = (function() {
      var _i, _len, _results;
      _results = [];
      for (_i = 0, _len = json.length; _i < _len; _i++) {
        itm = json[_i];
        arr = searchJSON(itm);
        _results.push(arr.length ? 'url(' + arr[0].src + ')' : void 0);
      }
      return _results;
    })();
    return el.css('backgroundImage', css);
  };
  AlbumsList.prototype.create = function() {
    return Spine.trigger('create:album');
  };
  AlbumsList.prototype.click = function(e) {
    var item;
    console.log('AlbumsList::click');
    item = $(e.currentTarget).item();
    item.addRemoveSelection(this.isCtrlClick(e));
    this.activate();
    App.showView.trigger('change:toolbarOne');
    e.stopPropagation();
    return e.preventDefault();
  };
  AlbumsList.prototype.dblclick = function(e) {
    Spine.trigger('show:photos');
    this.activate();
    e.stopPropagation();
    return e.preventDefault();
  };
  AlbumsList.prototype.edit = function(e) {
    var item;
    console.log('AlbumsList::edit');
    item = $(e.target).item();
    return this.change(item);
  };
  AlbumsList.prototype.sortupdate = function(e, item) {
    this.children().each(function(index) {
      var album, ga;
      item = $(this).item();
      if (item && Gallery.record) {
        ga = GalleriesAlbum.filter(item.id, {
          func: 'selectAlbum'
        })[0];
        if (ga && ga.order !== index) {
          ga.order = index;
          return ga.save();
        }
      } else if (item) {
        album = (Album.filter(item.id, {
          func: 'selectAlbum'
        }))[0];
        album.order = index;
        return album.save();
      }
    });
    return this.exposeSelection();
  };
  AlbumsList.prototype.infoUp = function(e) {
    this.info.up(e);
    return e.preventDefault();
  };
  AlbumsList.prototype.infoBye = function(e) {
    this.info.bye();
    return e.preventDefault();
  };
  AlbumsList.prototype.stopInfo = function(e) {
    return this.info.bye();
  };
  AlbumsList.prototype.infoEnter = function(e) {
    var el;
    el = $(e.target).find('.more-icon');
    return el.addClass('in');
  };
  AlbumsList.prototype.infoMove = function(e) {
    var el;
    if (!$(e.target).hasClass('items')) {
      return;
    }
    el = $(e.target).find('.more-icon');
    return el.removeClass('in');
  };
  return AlbumsList;
})();
if (typeof module !== "undefined" && module !== null) {
  module.exports = AlbumsList;
}
