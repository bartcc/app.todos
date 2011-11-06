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
    Photo.bind('uri', this.proxy(this.develop));
  }
  PhotoList.prototype.template = function() {
    return arguments[0];
  };
  PhotoList.prototype.render = function(items) {
    console.log('PhotoList::render');
    console.log(items);
    this.items = items;
    return Photo.develop(items);
  };
  PhotoList.prototype.change = function(item) {
    var list;
    list = Album.selectionList();
    this.children().removeClass("active");
    return this.exposeSelection(list);
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
  PhotoList.prototype.develop = function(json) {
    var src, _i, _len, _ref, _ref2;
    _ref = this.items;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      src = _ref[_i];
      if ((_ref2 = this.items[_i]) != null) {
        _ref2.src = json[_i];
      }
    }
    this.html(this.template(this.items));
    this.change();
    return this.el;
  };
  return PhotoList;
})();
if (typeof module !== "undefined" && module !== null) {
  module.exports = PhotoList;
}