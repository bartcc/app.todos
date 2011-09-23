var $;
var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; }, __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
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
  AlbumList.prototype.events = {
    "click .item": "click",
    "dblclick .item": "dblclick"
  };
  AlbumList.prototype.selectFirst = true;
  function AlbumList() {
    this.change = __bind(this.change, this);    AlbumList.__super__.constructor.apply(this, arguments);
    this.bind("change", this.change);
  }
  AlbumList.prototype.template = function() {
    return arguments[0];
  };
  AlbumList.prototype.change = function(item, mode) {
    var album;
    console.log('AlbumList::change');
    album = this.selectedAlbum(item != null ? item.id : void 0);
    if (album && !album.destroyed) {
      this.current = album;
      this.children().removeClass("active");
      this.children().forItem(this.current).addClass("active");
      return Spine.App.trigger('change:album', this.current, mode);
    }
  };
  AlbumList.prototype.render = function(items) {
    console.log('AlbumList::render');
    if (items) {
      this.items = items;
    }
    this.html(this.template(this.items));
    this.change();
    return this;
  };
  AlbumList.prototype.selectedAlbum = function(id) {
    var alb, albumid, gal;
    gal = Gallery.selected();
    albumid = id || gal.selectedAlbumId;
    if (!albumid) {
      return;
    }
    alb = Album.find(albumid);
    try {
      Gallery.record.updateAttribute('selectedAlbumId', albumid, {
        silent: true
      });
    } catch (e) {
      alert('Select a Gallery or drag Album into a Gallery !');
      return;
    }
    return alb;
  };
  AlbumList.prototype.children = function(sel) {
    return this.el.children(sel);
  };
  AlbumList.prototype.click = function(e) {
    var item;
    item = $(e.target).item();
    console.log('AlbumList::click');
    if (App.hmanager.hasActive()) {
      this.dblclick();
    }
    return this.change(item);
  };
  AlbumList.prototype.dblclick = function() {
    App.album.deactivate();
    return App.albums.albumBtn.click();
  };
  AlbumList.prototype.edit = function(e) {
    var item;
    console.log('AlbumList::edit');
    item = $(e.target).item();
    return this.change(item, 'edit');
  };
  return AlbumList;
})();
if (typeof module !== "undefined" && module !== null) {
  module.exports = Spine.AlbumList;
}