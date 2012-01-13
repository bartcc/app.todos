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
    'click .item': "click",
    'dblclick .item': 'dblclick',
    'mousemove .item .thumbnail': 'infoUp',
    'mouseleave .item .thumbnail': 'infoBye',
    'dragstart .item .thumbnail': 'infoBye'
  };
  function AlbumsList() {
    this.infoBye = __bind(this.infoBye, this);
    this.infoUp = __bind(this.infoUp, this);
    this.closeInfo = __bind(this.closeInfo, this);
    this.callback = __bind(this.callback, this);    AlbumsList.__super__.constructor.apply(this, arguments);
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
    console.log('AlbumsList::change');
    if (items.length) {
      return this.renderBackgrounds(items);
    }
  };
  AlbumsList.prototype.select = function(item, e) {
    console.log('AlbumsList::select');
    return this.activate();
  };
  AlbumsList.prototype.exposeSelection = function() {
    var el, id, item, list, _i, _len;
    console.log('AlbumsList::exposeSelection');
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
  AlbumsList.prototype.activate = function(album) {
    var alb, gal, newActive, sameAlbum, selection, _ref;
    alb = Album.record;
    gal = Gallery.record;
    selection = Gallery.selectionList();
    if (selection.length === 1) {
      if (Album.exists(selection[0])) {
        newActive = Album.find(selection[0]);
      }
      if (!(newActive != null ? newActive.destroyed : void 0)) {
        this.current = newActive;
        Album.current(newActive);
      }
    } else {
      Album.current(album);
    }
    sameAlbum = ((_ref = Album.record) != null ? typeof _ref.eql === "function" ? _ref.eql(alb) : void 0 : void 0) && !!alb;
    if (!sameAlbum) {
      Spine.trigger('change:selectedAlbum', Album.record);
    }
    Spine.trigger('change:selectedPhoto', Photo.record);
    return this.exposeSelection();
  };
  AlbumsList.prototype.render = function(items) {
    console.log('AlbumsList::render');
    if (items.length) {
      this.html(this.template(items));
    } else {
      if (Album.count()) {
        this.html('<div class="invite"><span class="enlightened invite">This Gallery has no albums. &nbsp;<button class="optCreateAlbum dark invite">New Album</button><button class="optShowAllAlbums dark invite">Show available Albums</button></span></div>');
      } else {
        this.html('<div class="invite"><span class="enlightened invite">Time to create a new album. &nbsp;<button class="optCreateAlbum dark invite">New Album</button></span></div>');
      }
    }
    this.change(items);
    return this.el;
  };
  AlbumsList.prototype.renderBackgrounds = function(albums) {
    var album, _i, _len, _results;
    console.log('AlbumsList::renderBackgrounds');
    if (!App.ready) {
      return;
    }
    _results = [];
    for (_i = 0, _len = albums.length; _i < _len; _i++) {
      album = albums[_i];
      _results.push(album.uri({
        width: 50,
        height: 50
      }, 'html', __bind(function(xhr, album) {
        return this.callback(xhr, album);
      }, this), 3));
    }
    return _results;
  };
  AlbumsList.prototype.callback = function(json, item) {
    var css, el, itm, o, searchJSON;
    console.log('AlbumsList::callback');
    el = this.children().forItem(item);
    searchJSON = function(itm) {
      var key, res, value;
      return res = (function() {
        var _results;
        _results = [];
        for (key in itm) {
          value = itm[key];
          _results.push(value);
        }
        return _results;
      })();
    };
    css = (function() {
      var _i, _len, _results;
      _results = [];
      for (_i = 0, _len = json.length; _i < _len; _i++) {
        itm = json[_i];
        o = searchJSON(itm);
        _results.push('url(' + o[0].src + ')');
      }
      return _results;
    })();
    return el.css('backgroundImage', css);
  };
  AlbumsList.prototype.create = function() {
    return Spine.trigger('create:album');
  };
  AlbumsList.prototype.click = function(e) {
    var item, list;
    console.log('AlbumsList::click');
    item = $(e.currentTarget).item();
    list = item.addRemoveSelection(this.isCtrlClick(e));
    this.select(item, e);
    Spine.trigger('change:toolbarOne', ['Album']);
    e.stopPropagation();
    return e.preventDefault();
  };
  AlbumsList.prototype.dblclick = function(e) {
    Spine.trigger('change:toolbarOne', ['Photos'], App.showView.initSlider);
    Spine.trigger('show:photos');
    e.stopPropagation();
    e.preventDefault();
    return false;
  };
  AlbumsList.prototype.edit = function(e) {
    var item;
    console.log('AlbumsList::edit');
    item = $(e.target).item();
    return this.change(item);
  };
  AlbumsList.prototype.closeInfo = function(e) {
    this.el.click();
    e.stopPropagation();
    return e.preventDefault();
  };
  AlbumsList.prototype.infoUp = function(e) {
    e.stopPropagation();
    e.preventDefault();
    return this.info.up(e);
  };
  AlbumsList.prototype.infoBye = function(e) {
    return this.info.bye();
  };
  return AlbumsList;
})();
if (typeof module !== "undefined" && module !== null) {
  module.exports = AlbumsList;
}