var $;
var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
}, __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
if (typeof Spine !== "undefined" && Spine !== null) {
  Spine;
} else {
  Spine = require("spine");
};
$ = Spine.$;
Spine.AlbumList = (function() {
  __extends(AlbumList, Spine.Controller);
  AlbumList.prototype.elements = {
    '.optCreate': 'btnCreateAlbum'
  };
  AlbumList.prototype.events = {
    "click .item": "click",
    "dblclick .item": "dblclick",
    'click .optCreate': 'create'
  };
  AlbumList.prototype.selectFirst = true;
  function AlbumList() {
    AlbumList.__super__.constructor.apply(this, arguments);
    this.bind("change", this.change);
    this.record = Gallery.record;
    Spine.bind('createAlbum', this.proxy(this.create));
    Spine.bind('destroyAlbum', this.proxy(this.destroy));
  }
  AlbumList.prototype.template = function() {
    return arguments[0];
  };
  AlbumList.prototype.change = function() {
    var id, item, list, selected, _i, _len;
    console.log('AlbumList::change');
    list = Gallery.selectionList();
    this.children().removeClass("active");
    if (list) {
      for (_i = 0, _len = list.length; _i < _len; _i++) {
        id = list[_i];
        if (Album.exists(id)) {
          item = Album.find(id);
        }
        if (item) {
          this.children().forItem(item).addClass("active");
        }
      }
      if (Album.exists(list[0])) {
        selected = Album.find(list[0]);
      }
      if (selected && !selected.destroyed) {
        item = selected;
      }
    }
    return Spine.trigger('change:selectedAlbum', item);
  };
  AlbumList.prototype.render = function(items, newAlbum) {
    console.log('AlbumList::render');
    if (items.length) {
      this.html(this.template(items));
    } else {
      this.html('This Gallery has no Albums&nbsp;<button class="optCreate">New Album</button>');
      this.refreshElements();
    }
    if (newAlbum && newAlbum instanceof Album) {
      Gallery.updateSelection([newAlbum.id]);
    }
    this.change();
    return this;
  };
  AlbumList.prototype.children = function(sel) {
    return this.el.children(sel);
  };
  AlbumList.prototype.newAttributes = function() {
    return {
      title: 'New Title',
      name: 'New Album'
    };
  };
  AlbumList.prototype.create = function() {
    var album;
    console.log('AlbumList::create');
    this.preserveEditorOpen('album', App.albumsShowView.btnAlbum);
    album = new Album(this.newAttributes());
    album.save();
    return Spine.trigger('create:albumJoin', Gallery.record, album);
  };
  AlbumList.prototype.destroy = function() {
    var album, albums, id, list, _i, _j, _len, _len2, _results;
    console.log('AlbumList::destroy');
    list = Gallery.selectionList().slice(0);
    for (_i = 0, _len = list.length; _i < _len; _i++) {
      id = list[_i];
      Gallery.removeFromSelection(id);
    }
    albums = [];
    Album.each(__bind(function(record) {
      if (list.indexOf(record.id) !== -1) {
        return albums.push(record);
      }
    }, this));
    if (Gallery.record) {
      return Spine.trigger('destroy:albumJoin', Gallery.record, albums);
    } else {
      _results = [];
      for (_j = 0, _len2 = albums.length; _j < _len2; _j++) {
        album = albums[_j];
        _results.push(Album.exists(album.id) ? album.destroy() : void 0);
      }
      return _results;
    }
  };
  AlbumList.prototype.click = function(e) {
    var item;
    console.log('AlbumList::click');
    item = $(e.target).item();
    if (App.hmanager.hasActive()) {
      this.preserveEditorOpen('album', App.albumsShowView.btnAlbum);
    }
    item.addRemoveSelection(Gallery, this.isCtrlClick(e));
    return this.change(item);
  };
  AlbumList.prototype.dblclick = function(e) {
    return this.preserveEditorOpen('album', App.albumsShowView.btnAlbum);
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
  module.exports = Spine.AlbumList;
}