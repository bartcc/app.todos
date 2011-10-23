var $, AlbumList;
var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
if (typeof Spine !== "undefined" && Spine !== null) {
  Spine;
} else {
  Spine = require("spine");
};
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
    this.record = Gallery.record;
    Spine.bind('exposeSelection', this.proxy(this.exposeSelection));
  }
  AlbumList.prototype.template = function() {
    return arguments[0];
  };
  AlbumList.prototype.change = function() {
    var list, selected;
    console.log('AlbumList::change');
    list = Gallery.selectionList();
    this.children().removeClass("active");
    if (list) {
      this.exposeSelection(list);
      if (Album.exists(list[0])) {
        selected = Album.find(list[0]);
      }
      if (selected && !selected.destroyed) {
        Album.current(selected);
      }
    }
    Spine.trigger('change:selectedAlbum', selected);
    return Spine.trigger('change:toolbar', 'Album');
  };
  AlbumList.prototype.exposeSelection = function(list) {
    var id, item, _i, _len, _results;
    _results = [];
    for (_i = 0, _len = list.length; _i < _len; _i++) {
      id = list[_i];
      _results.push(Album.exists(id) ? (item = Album.find(id), this.children().forItem(item).addClass("active")) : void 0);
    }
    return _results;
  };
  AlbumList.prototype.render = function(items, newAlbum) {
    console.log('AlbumList::render');
    if (items.length) {
      this.html(this.template(items));
    } else {
      this.html('<span class="enlightened">Time to create a new album.&nbsp;</span><button class="optCreateAlbum dark">New Album</button>');
    }
    this.change();
    return this.el;
  };
  AlbumList.prototype.children = function(sel) {
    return this.el.children(sel);
  };
  AlbumList.prototype.create = function() {
    return Spine.trigger('create:album');
  };
  AlbumList.prototype.click = function(e) {
    var item, list;
    console.log('AlbumList::click');
    item = $(e.target).item();
    if (App.hmanager.hasActive()) {
      this.openPanel('album', App.albumsShowView.btnAlbum);
    }
    item.addRemoveSelection(Gallery, this.isCtrlClick(e));
    list = Gallery.selectionList();
    if (!this.isCtrlClick(e)) {
      Spine.trigger('change:selected', item.constructor.className);
    }
    Spine.trigger('change:toolbar', item.constructor.className);
    return this.change(item);
  };
  AlbumList.prototype.dblclick = function(e) {
    return this.openPanel('album', App.albumsShowView.btnAlbum);
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