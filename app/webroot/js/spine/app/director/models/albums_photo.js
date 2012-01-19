var AlbumsPhoto;
var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
AlbumsPhoto = (function() {
  __extends(AlbumsPhoto, Spine.Model);
  function AlbumsPhoto() {
    AlbumsPhoto.__super__.constructor.apply(this, arguments);
  }
  AlbumsPhoto.configure("AlbumsPhoto", "album_id", 'photo_id', 'order');
  AlbumsPhoto.extend(Spine.Model.Local);
  AlbumsPhoto.extend(Spine.Model.Filter);
  AlbumsPhoto.prototype.select = function(id, options) {
    if (this[options.key] === id && this.constructor.records[this.id]) {
      return true;
    }
    return false;
  };
  AlbumsPhoto.prototype.selectPhoto = function(query) {
    if (this.photo_id === query) {
      return true;
    }
  };
  return AlbumsPhoto;
})();
Spine.Model.AlbumsPhoto = AlbumsPhoto;