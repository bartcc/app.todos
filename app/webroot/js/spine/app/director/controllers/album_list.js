var $, AlbumList;
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
AlbumList = (function() {
  __extends(AlbumList, Spine.Controller);
  AlbumList.prototype.elements = {
    '.optCreate': 'btnCreate'
  };
  AlbumList.prototype.events = {
    'click .item': "click",
    'dblclick .item': 'dblclick',
    'click .optCreate': 'create'
  };
  AlbumList.prototype.selectFirst = true;
  function AlbumList() {
    AlbumList.__super__.constructor.apply(this, arguments);
    Spine.bind('album:exposeSelection', this.proxy(this.exposeSelection));
  }
  AlbumList.prototype.template = function() {
    return arguments[0];
  };
  AlbumList.prototype.albumPhotosTemplate = function(items) {
    return $('#albumPhotosTemplate').tmpl(items);
  };
  AlbumList.prototype.change = function(item) {
    var list, selected;
    console.log('AlbumList::change');
    list = Gallery.selectionList();
    this.children().removeClass("active");
    this.exposeSelection(list);
    if (Album.exists(list[0])) {
      selected = Album.find(list[0]);
    }
    if (selected && !selected.destroyed) {
      Album.current(selected);
    }
    return Spine.trigger('change:selectedAlbum', selected);
  };
  AlbumList.prototype.exposeSelection = function(list) {
    var id, item, _i, _len;
    for (_i = 0, _len = list.length; _i < _len; _i++) {
      id = list[_i];
      if (Album.exists(id)) {
        item = Album.find(id);
        this.children().forItem(item).addClass("active");
      }
    }
    if (Gallery.record) {
      return Spine.trigger('expose:sublistSelection', Gallery.record);
    }
  };
  AlbumList.prototype.render = function(items, newAlbum) {
    var options;
    console.log('AlbumList::render');
    if (items.length) {
      options = {
        photos: this.albumPhotos
      };
      this.html(this.template(items));
      this.renderThumbnails(items);
    } else {
      if (Album.count()) {
        this.html('<label class="invite"><span class="enlightened">This Gallery has no albums. &nbsp;</span></label><div class="invite"><button class="optCreateAlbum dark invite">New Album</button><button class="optShowAllAlbums dark invite">Show available Albums</button></div>');
      } else {
        this.html('<label class="invite"><span class="enlightened">Time to create a new album. &nbsp;</span></label><div class="invite"><button class="optCreateAlbum dark invite">New Album</button></div>');
      }
    }
    this.change();
    return this.el;
  };
  AlbumList.prototype.renderThumbnails = function(albums) {
    var album, callback, _i, _len, _results;
    _results = [];
    for (_i = 0, _len = albums.length; _i < _len; _i++) {
      album = albums[_i];
      callback = __bind(function(uri) {
        return this.albumPhotos(album, uri);
      }, this);
      _results.push(Photo.uri(album, {
        width: 50,
        height: 50
      }, callback));
    }
    return _results;
  };
  AlbumList.prototype.albumPhotos = function(album, uris) {
    var css, el, uri;
    css = (function() {
      var _i, _len, _results;
      _results = [];
      for (_i = 0, _len = uris.length; _i < _len; _i++) {
        uri = uris[_i];
        _results.push('url(' + uri + ')');
      }
      return _results;
    })();
    el = this.children().forItem(album);
    return el.css('backgroundImage', css);
  };
  AlbumList.prototype.children = function(sel) {
    return this.el.children(sel);
  };
  AlbumList.prototype.create = function() {
    return Spine.trigger('create:album');
  };
  AlbumList.prototype.click = function(e) {
    var item;
    console.log('AlbumList::click');
    item = $(e.target).item();
    if (App.hmanager.hasActive()) {
      this.openPanel('album', App.showView.btnAlbum);
    }
    item.addRemoveSelection(Gallery, this.isCtrlClick(e));
    this.change(item);
    App.showView.trigger('change:toolbar', 'Album');
    e.stopPropagation();
    e.preventDefault();
    return false;
  };
  AlbumList.prototype.dblclick = function(e) {
    var item;
    item = $(e.currentTarget).item();
    this.change(item);
    Spine.trigger('show:photos', item);
    e.stopPropagation();
    e.preventDefault();
    return false;
  };
  AlbumList.prototype.edit = function(e) {
    var item;
    console.log('AlbumList::edit');
    item = $(e.target).item();
    return this.change(item);
  };
  return AlbumList;
})();
if (typeof module !== "undefined" && module !== null) {
  module.exports = AlbumList;
}