var $, ImageList;
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
ImageList = (function() {
  __extends(ImageList, Spine.Controller);
  ImageList.prototype.events = {
    'click .item': "click",
    'dblclick .item': 'dblclick',
    'click .optCreate': 'create'
  };
  ImageList.prototype.selectFirst = true;
  function ImageList() {
    ImageList.__super__.constructor.apply(this, arguments);
    this.record = Gallery.record;
    Spine.bind('exposeSelection', this.proxy(this.exposeSelection));
  }
  ImageList.prototype.template = function() {
    return arguments[0];
  };
  ImageList.prototype.change = function() {
    return console.log('ImageList::change');
  };
  ImageList.prototype.render = function(items) {
    return console.log('ImageList::render');
  };
  return ImageList;
})();
if (typeof module !== "undefined" && module !== null) {
  module.exports = ImageList;
}