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
Spine.List = (function() {
  __extends(List, Spine.Controller);
  List.prototype.events = {
    "click .item": "click",
    "dblclick .item": "preserveEditorOpen"
  };
  List.prototype.selectFirst = true;
  function List() {
    this.change = __bind(this.change, this);    List.__super__.constructor.apply(this, arguments);
    this.bind("change", this.change);
    this.record = Gallery.record;
  }
  List.prototype.template = function() {
    return arguments[0];
  };
  List.prototype.change = function(item, mode) {
    var changed, newId, oldId, _ref;
    console.log('AlbumList::change');
    if (item && !item.destroyed) {
      oldId = (_ref = this.current) != null ? _ref.id : void 0;
      newId = item.id;
      changed = !(oldId === newId) || !oldId;
      this.current = item;
      this.children().removeClass("active");
      this.children().forItem(this.current).addClass("active");
      if (changed) {
        return Spine.App.trigger('change:selectedAlbum', this.current, mode);
      }
    }
  };
  List.prototype.render = function(items, selected) {
    console.log('AlbumList::render');
    if (!selected) {
      selected = this.record.selectedAlbumId;
    }
    this.items = items;
    this.html(this.template(this.items));
    this.change(selected);
    return this;
  };
  List.prototype.children = function(sel) {
    return this.el.children(sel);
  };
  List.prototype.click = function(e) {
    var item;
    console.log('AlbumList::click');
    item = $(e.target).item();
    if (App.hmanager.hasActive()) {
      this.preserveEditorOpen();
    }
    return this.change(item);
  };
  List.prototype.edit = function(e) {
    var item;
    console.log('AlbumList::edit');
    item = $(e.target).item();
    return this.change(item, 'edit');
  };
  List.prototype.preserveEditorOpen = function() {
    console.log('AlbumList::dblclick');
    App.album.deactivate();
    return App.albums.albumBtn.click();
  };
  return List;
})();
if (typeof module !== "undefined" && module !== null) {
  module.exports = Spine.AlbumList;
}