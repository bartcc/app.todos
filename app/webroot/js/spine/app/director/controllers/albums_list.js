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
    'mousemove .item .thumbnail': 'previewUp',
    'mouseleave .item .thumbnail': 'previewBye',
    'dragstart .item .thumbnail': 'stopPreview'
  };
  function AlbumsList() {
    this.stopPreview = __bind(this.stopPreview, this);
    this.previewBye = __bind(this.previewBye, this);
    this.previewUp = __bind(this.previewUp, this);
    this.closeInfo = __bind(this.closeInfo, this);
    this.callback = __bind(this.callback, this);    AlbumsList.__super__.constructor.apply(this, arguments);
    Spine.bind('album:exposeSelection', this.proxy(this.exposeSelection));
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
    var previous;
    console.log('AlbumsList::select');
    previous = Album.record;
    if (item && !item.destroyed) {
      this.current = item;
      Album.current(item);
    }
    this.exposeSelection();
    return Spine.trigger('change:selectedAlbum', item, Album.changed());
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
  AlbumsList.prototype.render = function(items) {
    console.log('AlbumsList::render');
    if (items.length) {
      this.html(this.template(items));
    } else {
      if (Album.count()) {
        this.html('<label class="invite"><span class="enlightened">This Gallery has no albums. &nbsp;</span></label><div class="invite"><button class="optCreateAlbum dark invite">New Album</button><button class="optShowAllAlbums dark invite">Show available Albums</button></div>');
      } else {
        this.html('<label class="invite"><span class="enlightened">Time to create a new album. &nbsp;</span></label><div class="invite"><button class="optCreateAlbum dark invite">New Album</button></div>');
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
    var item;
    console.log('AlbumsList::click');
    item = $(e.target).item();
    item.addRemoveSelection(this.isCtrlClick(e));
    this.select(item, e);
    App.showView.trigger('change:toolbar', 'Album');
    e.stopPropagation();
    e.preventDefault();
    return false;
  };
  AlbumsList.prototype.dblclick = function(e) {
    App.showView.trigger('change:toolbar', 'Photo');
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
    e.preventDefault();
    return false;
  };
  AlbumsList.prototype.previewUp = function(e) {
    e.stopPropagation();
    e.preventDefault();
    this.preview.up(e);
    return false;
  };
  AlbumsList.prototype.previewBye = function(e) {
    e.stopPropagation();
    e.preventDefault();
    this.preview.bye();
    return false;
  };
  AlbumsList.prototype.stopPreview = function(e) {
    return this.preview.bye();
  };
  return AlbumsList;
})();
if (typeof module !== "undefined" && module !== null) {
  module.exports = AlbumsList;
}