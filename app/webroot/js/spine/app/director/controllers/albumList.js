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
    if (newAlbum) {
      newAlbum.addRemoveSelection(Gallery);
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
    return album.save();
  };
  AlbumList.prototype.destroy = function() {
    var alb, gallery, id, list, _i, _j, _len, _len2, _results, _results2;
    console.log('AlbumList::destroy');
    list = Gallery.selectionList().slice();
    if (Gallery.record) {
      _results = [];
      for (_i = 0, _len = list.length; _i < _len; _i++) {
        id = list[_i];
        alb = GalleriesAlbum.findByAttribute('album_id', id);
        console.log(alb);
        Gallery.removeFromList(id);
        if (alb) {
          alb.destroy();
        }
        gallery = Gallery.find(Gallery.record.id);
        _results.push(gallery.save());
      }
      return _results;
    } else {
      _results2 = [];
      for (_j = 0, _len2 = list.length; _j < _len2; _j++) {
        id = list[_j];
        if (Album.exists(id)) {
          alb = Album.find(id);
        }
        Gallery.removeFromList(id);
        console.log(alb);
        _results2.push(alb ? alb.destroy() : void 0);
      }
      return _results2;
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