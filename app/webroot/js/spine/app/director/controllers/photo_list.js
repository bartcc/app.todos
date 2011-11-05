var $, PhotoList;
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
PhotoList = (function() {
  __extends(PhotoList, Spine.Controller);
  PhotoList.prototype.events = {
    'click .item': "click",
    'dblclick .item': 'dblclick'
  };
  PhotoList.prototype.selectFirst = true;
  function PhotoList() {
    PhotoList.__super__.constructor.apply(this, arguments);
    Spine.bind('photo:exposeSelection', this.proxy(this.exposeSelection));
  }
  PhotoList.prototype.template = function() {
    return arguments[0];
  };
  PhotoList.prototype.render = function(items) {
    console.log('PhotoList::render');
    this.html(this.template(items));
    this.change();
    return this.el;
  };
  PhotoList.prototype.change = function(item) {
    var list;
    list = Album.selectionList();
    this.children().removeClass("active");
    this.exposeSelection(list);
    return App.showView.trigger('change:toolbar', 'Photo');
  };
  PhotoList.prototype.exposeSelection = function(list) {
    var id, item, _i, _len, _results;
    console.log('PhotoList::exposeSelection');
    _results = [];
    for (_i = 0, _len = list.length; _i < _len; _i++) {
      id = list[_i];
      _results.push(Photo.exists(id) ? (item = Photo.find(id), this.children().forItem(item).addClass("active")) : void 0);
    }
    return _results;
  };
  PhotoList.prototype.children = function(sel) {
    return this.el.children(sel);
  };
  PhotoList.prototype.click = function(e) {
    var item;
    console.log('PhotoList::click');
    item = $(e.currentTarget).item();
    item.addRemoveSelection(Album, this.isCtrlClick(e));
    if (App.hmanager.hasActive()) {
      this.openPanel('photo', App.showView.btnPhoto);
    }
    this.change(item);
    e.stopPropagation();
    e.preventDefault();
    return false;
  };
  PhotoList.prototype.dblclick = function(e) {
    var item;
    console.log('PhotoList::dblclick');
    item = $(e.currentTarget).item();
    this.change(item);
    Spine.trigger('show:photo', item);
    e.stopPropagation();
    e.preventDefault();
    return false;
  };
  return PhotoList;
})();
if (typeof module !== "undefined" && module !== null) {
  module.exports = PhotoList;
}