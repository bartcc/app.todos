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
      count: this.albumCount()
    }));
  };
  AlbumsHeader.prototype.albumCount = function() {
    var _ref;
    return GalleriesAlbum.filter((_ref = Gallery.record) != null ? _ref.id : void 0, {
      key: 'gallery_id'
    }).length;
  };
  return AlbumsHeader;
})();
if (typeof module !== "undefined" && module !== null) {
  module.exports = AlbumsHeader;
}