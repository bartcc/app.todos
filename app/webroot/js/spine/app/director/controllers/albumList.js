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
    "dblclick .item": "preserveEditorOpen"
  };
  AlbumList.prototype.selectFirst = true;
  function AlbumList() {
    this.change = __bind(this.change, this);    AlbumList.__super__.constructor.apply(this, arguments);
    this.bind("change", this.change);
    this.record = Gallery.record;
  }
  AlbumList.prototype.template = function() {
    return arguments[0];
  };
  AlbumList.prototype.change = function(item, mode) {
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
  AlbumList.prototype.render = function(items, selected) {
    console.log('AlbumList::render');
    if (!selected) {
      selected = this.record.selectedAlbumId;
    }
    this.items = items;
    this.html(this.template(this.items));
    this.change(selected);
    return this;
  };
  AlbumList.prototype.children = function(sel) {
    return this.el.children(sel);
  };
  AlbumList.prototype.click = function(e) {
    var item;
    console.log('AlbumList::click');
    item = $(e.target).item();
    if (App.hmanager.hasActive()) {
      this.preserveEditorOpen('albums', e.target);
    }
    return this.change(item);
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