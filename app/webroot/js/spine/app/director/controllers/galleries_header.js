var $, GalleriesHeader;
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
GalleriesHeader = (function() {
  __extends(GalleriesHeader, Spine.Controller);
  GalleriesHeader.prototype.elements = {
    '.closeView': 'closeViewEl'
  };
  GalleriesHeader.prototype.events = {
    'click .closeView': 'closeView'
  };
  function GalleriesHeader() {
    GalleriesHeader.__super__.constructor.apply(this, arguments);
  }
  GalleriesHeader.prototype.render = function() {
    return this.html(this.template({
      count: this.count()
    }));
  };
  GalleriesHeader.prototype.count = function() {
    return Gallery.all().length;
  };
  GalleriesHeader.prototype.closeView = function() {
    console.log('GalleriesHeader::closeView');
    return Spine.trigger('show:overview');
  };
  return GalleriesHeader;
})();
if (typeof module !== "undefined" && module !== null) {
  module.exports = GalleriesHeader;
}