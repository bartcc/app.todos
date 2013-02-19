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
    'click .icon-set .delete': 'deleteAlbum',
    'click .icon-set .zoom': 'zoom',
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
    Album.bind('change', this.proxy(this.change));
    Album.bind('sortupdate', this.proxy(this.sortupdate));
    Album.bind("ajaxError", Album.errorHandler);
    Photo.bind('refresh', this.proxy(this.refreshBackgrounds));
    AlbumsPhoto.bind('beforeDestroy', this.proxy(this.widowedAlbumsPhoto));
    AlbumsPhoto.bind('destroy create', this.proxy(this.updateBackgrounds));
    GalleriesAlbum.bind('destroy', this.proxy(this.sortupdate));
    GalleriesAlbum.bind('change', this.proxy(this.changeRelatedAlbum));
    Spine.bind('album:activate', this.proxy(this.activate));
  }
  AlbumsList.prototype.template = function() {
    return arguments[0];
  };
  AlbumsList.prototype.change = function(album, mode, options) {
    var active, css, el, tb, tmplItem;
    switch (mode) {
      case 'update':
        el = __bind(function() {
          try {
            return this.children().forItem(album);
          } catch (e) {
            return [];
          }
        }, this);
        tb = function() {
          return $('.thumbnail', el());
        };
        if (!el().length) {
          return;
        }
        active = el().hasClass('active');
        css = el().attr('style');
        tmplItem = el().tmplItem();
        tmplItem.tmpl = $("#albumsTemplate").template();
        tmplItem.update();
        el().toggleClass('active', active);
        el().attr('style', css);
        return this.refreshElements();
      case 'destroy':
        return this.children().forItem(album, true).remove();
    }
  };
  AlbumsList.prototype.render = function(items, mode) {
    if (items == null) {
      items = [];
    }
    console.log('AlbumsList::render');
    if (items.length) {
      this.html(this.template(items));
    } else {
      if (!Gallery.record) {
        this.navigate('/galleries');
      } else if (Album.count()) {
        this.html('<label class="invite"><span class="enlightened">This Gallery has no albums. &nbsp;<button class="optCreateAlbum dark large">New Album</button><button class="optShowAllAlbums dark large">Show existing Albums</button></span></label>');
      } else {
        this.html('<label class="invite"><span class="enlightened">This Gallery has no albums.<br>It\'s time to create one.<br><button class="optCreateAlbum dark large">New Album</button></span></label>');
      }
    }
    this.renderBackgrounds(items, mode);
    return this.el;
  };
  AlbumsList.prototype.changeRelatedAlbum = function(item, mode) {
    var album, albumEl, gallery, wipe, _ref;
    if (!(album = Album.exists(item['album_id']))) {
      return;
    }
    switch (mode) {
      case 'create':
        wipe = ((_ref = Gallery.record) != null ? _ref.contains() : void 0) === 1;
        if (wipe) {
          this.el.empty();
        }
        this.append(this.template(album));
        this.el.sortable('album');
        break;
      case 'destroy':
        albumEl = this.children().forItem(album, true);
        albumEl.remove();
        if (gallery = Gallery.record) {
          if (!this.el.children().length) {
            if (!gallery.contains()) {
              this.parent.render();
            }
          }
        }
    }
    this.exposeSelection();
    return this.el;
  };
  AlbumsList.prototype.updateTemplate = function(item) {};
  AlbumsList.prototype.exposeSelection = function() {
    var el, id, item, list, _i, _len;
    list = Gallery.selectionList();
    if (!list.length && Album.record) {
      list.push(Album.record.id);
    }
    this.deselect();
    for (_i = 0, _len = list.length; _i < _len; _i++) {
      id = list[_i];
      if (item = Album.exists(id)) {
        el = this.children().forItem(item, true);
        el.addClass("active");
      }
    }
    return Spine.trigger('expose:sublistSelection', Gallery.record);
  };
  AlbumsList.prototype.activate = function(id) {
    var last, selection;
    selection = Gallery.selectionList();
    if (!Spine.isArray(selection)) {
      return;
    }
    if (selection.length) {
      last = Album.exists(selection[selection.length - 1]);
      if (!(last != null ? last.destroyed : void 0)) {
        Album.current(last);
      }
    }
    if (id && Album.exists(id)) {
      Album.current(id);
    } else {
      Album.current();
    }
    return this.exposeSelection();
  };
  AlbumsList.prototype.select = function(item, lonely) {
    var it;
    it = item != null ? item.addRemoveSelection(lonely) : void 0;
    return Spine.trigger('album:activate');
  };
  AlbumsList.prototype.zoom = function(e) {
    var item, _ref;
    item = $(e.currentTarget).item();
    this.select(item, true);
    this.stopInfo();
    this.navigate('/gallery', ((_ref = Gallery.record) != null ? _ref.id : void 0) || '', item.id);
    e.stopPropagation();
    return e.preventDefault();
  };
  AlbumsList.prototype.updateBackgrounds = function(ap, mode) {
    var albums;
    console.log('AlbumsList::updateBackgrounds');
    albums = ap.albums();
    return this.renderBackgrounds(albums);
  };
  AlbumsList.prototype.refreshBackgrounds = function(photos) {
    var album;
    album = App.upload.album;
    if (album) {
      return this.renderBackgrounds([album]);
    }
  };
  AlbumsList.prototype.widowedAlbumsPhoto = function(ap) {
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
    var data;
    if (!(album != null ? typeof album.contains === "function" ? album.contains() : void 0 : void 0)) {
      return;
    }
    data = album.photos(4);
    return Photo.uri({
      width: 50,
      height: 50
    }, __bind(function(xhr, rec) {
      return this.callback(xhr, album);
    }, this), data);
  };
  AlbumsList.prototype.callback = function(json, album) {
    var css, el, itm, jsn, res, search, _i, _len;
    console.log('AlbumsList::callback');
    el = this.children().forItem(album);
    search = function(o) {
      var key, val;
      for (key in o) {
        val = o[key];
        return o[key].src;
      }
    };
    res = [];
    for (_i = 0, _len = json.length; _i < _len; _i++) {
      jsn = json[_i];
      res.push(search(jsn));
    }
    css = (function() {
      var _j, _len2, _results;
      _results = [];
      for (_j = 0, _len2 = res.length; _j < _len2; _j++) {
        itm = res[_j];
        _results.push('url(' + itm + ')');
      }
      return _results;
    })();
    return el.css('backgroundImage', css);
  };
  AlbumsList.prototype.click = function(e) {
    var item;
    console.log('AlbumsList::click');
    item = $(e.currentTarget).item();
    this.select(item, this.isCtrlClick(e));
    e.stopPropagation();
    return e.preventDefault();
  };
  AlbumsList.prototype.loadtest = function(t) {
    var test;
    return test = $('.item', this.el).each(function() {
      var len;
      len = $(this).data('queue');
      if (len && len.length) {
        return true;
      } else {
        return false;
      }
    });
  };
  AlbumsList.prototype.deleteAlbum = function(e) {
    var el, item, _ref;
    item = $(e.currentTarget).item();
    if ((item != null ? (_ref = item.constructor) != null ? _ref.className : void 0 : void 0) !== 'Album') {
      return;
    }
    Gallery.updateSelection(item.id);
    el = $(e.currentTarget).parents('.item');
    el.removeClass('in');
    this.stopInfo();
    window.setTimeout(__bind(function() {
      Spine.trigger('destroy:album');
      return el.remove();
    }, this), 200);
    e.stopPropagation();
    return e.preventDefault();
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
    var el;
    this.info.up(e);
    el = $('.icon-set', $(e.currentTarget)).addClass('in').removeClass('out');
    return e.preventDefault();
  };
  AlbumsList.prototype.infoBye = function(e) {
    var el;
    this.info.bye();
    el = $('.icon-set', $(e.currentTarget)).addClass('out').removeClass('in');
    return e.preventDefault();
  };
  AlbumsList.prototype.stopInfo = function(e) {
    return this.info.bye();
  };
  AlbumsList.prototype.infoEnter = function(e) {};
  AlbumsList.prototype.infoMove = function(e) {};
  return AlbumsList;
})();
if (typeof module !== "undefined" && module !== null) {
  module.exports = AlbumsList;
}
