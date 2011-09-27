var $;
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
Spine.AlbumList = (function() {
  __extends(AlbumList, Spine.Controller);
  AlbumList.prototype.elements = {
    '.optCreateAlbum': 'btnCreateAlbum'
  };
  AlbumList.prototype.events = {
    "click .item": "click",
    "dblclick .item": "dblclick",
    'click .optCreateAlbum': 'create'
  };
  AlbumList.prototype.selectFirst = true;
  function AlbumList() {
    AlbumList.__super__.constructor.apply(this, arguments);
    this.bind("change", this.change);
    this.record = Gallery.record;
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
        this.children().forItem(item).addClass("active");
      }
      if (Album.exists(list[0])) {
        selected = Album.find(list[0]);
      }
      if (selected && !selected.destroyed) {
        item = selected;
      }
    }
    return Spine.App.trigger('change:selectedAlbum', item);
  };
  AlbumList.prototype.render = function(items, newAlbum) {
    console.log('AlbumList::render');
    if (items.length) {
      this.html(this.template(items));
    } else {
      this.html('This Gallery has no Albums&nbsp;<button class="optCreateAlbum">CreateAlbum</button>');
      this.refreshElements();
    }
    if (newAlbum) {
      newAlbum.addToSelection(Gallery);
    }
    this.change();
    return this;
  };
  AlbumList.prototype.children = function(sel) {
    return this.el.children(sel);
  };
  AlbumList.prototype.create = function() {
    var album;
    this.preserveEditorOpen('album', App.albumsShowView.btnAlbum);
    album = new Album();
    return album.save();
  };
  AlbumList.prototype.click = function(e) {
    var item;
    console.log('AlbumList::click');
    item = $(e.target).item();
    if (App.hmanager.hasActive()) {
      this.preserveEditorOpen('album', App.albumsShowView.btnAlbum);
    }
    item.addToSelection(Gallery, this.isCtrlClick(e));
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