var AlbumsImage;
var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
AlbumsImage = (function() {
  __extends(AlbumsImage, Spine.Model);
  function AlbumsImage() {
    AlbumsImage.__super__.constructor.apply(this, arguments);
  }
  AlbumsImage.configure("AlbumsImage", "album_id", 'image_id');
  AlbumsImage.extend(Spine.Model.Local);
  return AlbumsImage;
})();