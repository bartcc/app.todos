var AlbumsBitmap;
var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
AlbumsBitmap = (function() {
  __extends(AlbumsBitmap, Spine.Model);
  function AlbumsBitmap() {
    AlbumsBitmap.__super__.constructor.apply(this, arguments);
  }
  AlbumsBitmap.configure("AlbumsBitmap", "album_id", 'image_id');
  AlbumsBitmap.extend(Spine.Model.Local);
  AlbumsBitmap.extend(Spine.Model.Filter);
  AlbumsBitmap.prototype.select = function(query) {
    if (this.album_id === query) {
      return true;
    }
  };
  return AlbumsBitmap;
})();
Spine.Model.AlbumsBitmap = AlbumsBitmap;