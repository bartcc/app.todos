var $;
var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
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
Spine.AlbumList = (function() {
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
        Album.current(selected);
      }
    }
    return Spine.trigger('change:selectedAlbum', selected);
  };
  AlbumList.prototype.render = function(items, newAlbum) {
    console.log('AlbumList::render');
    if (items.length) {
      this.html(this.template(items));
    } else {
      this.html('This Gallery has no Albums&nbsp;<button class="optCreateAlbum">New Album</button>');
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
    var item;
    console.log('AlbumList::click');
    item = $(e.target).item();
    if (!this.isCtrlClick(e)) {
      Spine.trigger('change:selection', item.constructor.className);
    }
    if (App.hmanager.hasActive()) {
      this.openPanel('album', App.albumsShowView.btnAlbum);
    }
    item.addRemoveSelection(Gallery, this.isCtrlClick(e));
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
  module.exports = Spine.AlbumList;
}