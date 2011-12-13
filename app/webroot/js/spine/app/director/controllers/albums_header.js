var $, AlbumsHeader;
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
AlbumsHeader = (function() {
  __extends(AlbumsHeader, Spine.Controller);
  AlbumsHeader.prototype.events = {
    'click .closeView .gal': 'backToGalleries'
  };
  function AlbumsHeader() {
    AlbumsHeader.__super__.constructor.apply(this, arguments);
  }
  AlbumsHeader.prototype.change = function(item) {
    this.current = item;
    return this.render();
  };
  AlbumsHeader.prototype.render = function() {
    return this.html(this.template({
      record: this.current,
      count: this.count()
    }));
  };
  AlbumsHeader.prototype.count = function() {
    if (Gallery.record) {
      return GalleriesAlbum.filter(Gallery.record.id, {
        key: 'gallery_id'
      }).length;
    } else {
      return Album.all().length;
    }
  };
  AlbumsHeader.prototype.backToGalleries = function() {
    Spine.trigger('gallery:exposeSelection', Gallery.record);
    return Spine.trigger('show:galleries');
  };
  return AlbumsHeader;
})();
if (typeof module !== "undefined" && module !== null) {
  module.exports = AlbumsHeader;
}