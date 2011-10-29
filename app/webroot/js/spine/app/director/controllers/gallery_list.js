var $, GalleryList;
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
GalleryList = (function() {
  __extends(GalleryList, Spine.Controller);
  GalleryList.extend(Spine.Controller.Drag);
  GalleryList.prototype.elements = {
    '.gal.item': 'item',
    '.expander': 'expander'
  };
  GalleryList.prototype.events = {
    "dblclick   .gal.item": "edit",
    "click      .gal.item": "click",
    "click      .alb.item": "clickAlb",
    "click      .expander": "expand",
    'dragstart  .sublist-item': 'dragstart',
    'dragenter  .sublist-item': 'dragenter',
    'dragover   .sublist-item': 'dragover',
    'dragleave  .sublist-item': 'dragleave',
    'drop       .sublist-item': 'drop',
    'dragend    .sublist-item': 'dragend'
  };
  GalleryList.prototype.selectFirst = false;
  function GalleryList() {
    this.change = __bind(this.change, this);    GalleryList.__super__.constructor.apply(this, arguments);
    Spine.bind('drag:timeout', this.proxy(this.expandExpander));
  }
  GalleryList.prototype.template = function() {
    return arguments[0];
  };
  GalleryList.prototype.change = function(item, mode, e) {
    var cmdKey, dblclick;
    console.log('GalleryList::change');
    if (e) {
      cmdKey = this.isCtrlClick(e);
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
    Spine.trigger('change:selectedGallery', this.current, mode);
    return App.showView.trigger('change:toolbar', 'Gallery');
  };
  GalleryList.prototype.render = function(items, item, mode) {
    var new_content, old_content, record, _i, _len;
    console.log('GalleryList::render');
    if (!item) {
      for (_i = 0, _len = items.length; _i < _len; _i++) {
        record = items[_i];
        record.count = Album.filter(record.id).length;
      }
      this.items = items;
      this.html(this.template(this.items));
    } else if (mode === 'update') {
      old_content = $('.item-content', '#' + item.id);
      new_content = $('.item-content', this.template(item)).html();
      old_content.html(new_content);
    } else if (mode === 'create') {
      this.append(this.template(item));
    } else if (mode === 'destroy') {
      $('#' + item.id).remove();
    }
    this.change(item, mode);
    if ((!this.current || this.current.destroyed) && !(mode === 'update')) {
      if (!this.children(".active").length) {
        return this.children(":first").click();
      }
    }
  };
  GalleryList.prototype.children = function(sel) {
    return this.el.children(sel);
  };
  GalleryList.prototype.clickAlb = function(e) {
    console.log('GalleryList::albclick');
    return false;
  };
  GalleryList.prototype.click = function(e) {
    var item;
    console.log('GalleryList::click');
    item = $(e.target).item();
    this.change(item, 'show', e);
    return false;
  };
  GalleryList.prototype.edit = function(e) {
    var item;
    console.log('GalleryList::edit');
    item = $(e.target).item();
    this.change(item, 'edit', e);
    return false;
  };
  GalleryList.prototype.expandExpander = function(e) {
    var closest, el, expander;
    el = $(e.target);
    closest = (el.closest('.item')) || [];
    if (closest.length) {
      expander = $('.expander', closest);
      if (expander.length) {
        return this.expand(e, true);
      }
    }
  };
  GalleryList.prototype.expand = function(e, force) {
    var content, gallery, icon, parent;
    if (force == null) {
      force = false;
    }
    parent = $(e.target).parents('li');
    gallery = parent.item();
    icon = $('.expander', parent);
    content = $('.sublist', parent);
    if (force) {
      icon.toggleClass('expand', force);
    } else {
      icon.toggleClass('expand');
    }
    if ($('.expand', parent).length) {
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
  module.exports = GalleryList;
}