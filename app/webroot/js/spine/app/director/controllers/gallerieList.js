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
Spine.GalleryList = (function() {
  __extends(GalleryList, Spine.Controller);
  GalleryList.prototype.events = {
    "dblclick .item": "edit",
    "click .item": "click",
    "click .item-expander": "expand"
  };
  GalleryList.prototype.elements = {
    '.item': 'item'
  };
  GalleryList.prototype.selectFirst = false;
  function GalleryList() {
    this.change = __bind(this.change, this);    GalleryList.__super__.constructor.apply(this, arguments);
  }
  GalleryList.prototype.template = function() {
    return arguments[0];
  };
  GalleryList.prototype.change = function(item, mode, e) {
    var cmdKey, dblclick;
    console.log('GalleryList::change');
    if (e) {
      cmdKey = e.metaKey || e.ctrlKey;
    }
    if (e) {
      dblclick = e.type === 'dblclick';
    }
    this.children().removeClass("active");
    if (!cmdKey && item) {
      if (mode !== 'update') {
        this.current = item;
      }
      this.children().forItem(this.current).addClass("active");
    } else {
      this.current = false;
    }
    Gallery.current(this.current);
    return Spine.trigger('change:selectedGallery', this.current, mode);
  };
  GalleryList.prototype.render = function(items, item, mode) {
    var data, record, _i, _len;
    console.log('GalleryList::render');
    if (!item) {
      for (_i = 0, _len = items.length; _i < _len; _i++) {
        record = items[_i];
        record.count = Album.filter(record.id).length;
      }
      this.items = items;
      this.html(this.template(this.items));
    } else if (mode === 'update') {
      data = $('#' + item.id).item();
      $('.item-content .name', '#' + item.id).html(data.name);
    } else if (mode === 'create') {
      this.append(this.template(item));
    } else if (mode === 'destroy') {
      $('#sub-' + item.id).remove();
      $('#' + item.id).remove();
    }
    this.change(item, mode);
    if ((!this.current || this.current.destroyed) && !(mode === 'update')) {
      if (!this.children(".active").length) {
        return this.children(":first").click();
      }
    }
  };
  GalleryList.prototype.renderAlbumSubList = function(id) {
    var albums;
    albums = Album.filter(id);
    return $('#sub-' + id).html(this.subListTemplate(albums));
  };
  GalleryList.prototype.children = function(sel) {
    return this.el.children(sel);
  };
  GalleryList.prototype.click = function(e) {
    var item;
    console.log('GalleryList::click');
    item = $(e.target).item();
    return this.change(item, 'show', e);
  };
  GalleryList.prototype.edit = function(e) {
    var item;
    console.log('GalleryList::edit');
    item = $(e.target).item();
    return this.change(item, 'edit', e);
  };
  GalleryList.prototype.expand = function(e) {
    var content, gallery, icon;
    gallery = $(e.target).parent().next().item();
    icon = $('.item-expander', '#' + gallery.id);
    content = $('#sub-' + gallery.id);
    icon.toggleClass('expand');
    if ($('#' + gallery.id + ' .expand').length) {
      Spine.trigger('render:subList', gallery.id);
      content.show();
    } else {
      content.hide();
    }
    e.stopPropagation();
    e.preventDefault();
    return false;
  };
  return GalleryList;
})();
if (typeof module !== "undefined" && module !== null) {
  module.exports = Spine.GalleryList;
}