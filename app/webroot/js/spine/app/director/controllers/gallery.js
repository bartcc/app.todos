var $, GalleryView;
var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
if (typeof Spine !== "undefined" && Spine !== null) {
  Spine;
} else {
  Spine = require("spine");
};
$ = Spine.$;
GalleryView = (function() {
  __extends(GalleryView, Spine.Controller);
  GalleryView.prototype.elements = {
    '.editGallery': 'editEl'
  };
  GalleryView.prototype.events = {
    "keydown": "save"
  };
  GalleryView.prototype.template = function(item) {
    return $('#editGalleryTemplate').tmpl(item);
  };
  function GalleryView() {
    GalleryView.__super__.constructor.apply(this, arguments);
    Spine.App.bind('change:selectedGallery', this.proxy(this.change));
  }
  GalleryView.prototype.change = function(item) {
    console.log('Gallery::change');
    this.current = item;
    return this.render();
  };
  GalleryView.prototype.render = function() {
    var missing, missingGallery, _base;
    if (this.current && (typeof (_base = this.current).reload === "function" ? _base.reload() : void 0)) {
      this.current.reload();
      this.editEl.html(this.template(this.current));
    } else {
      missing = 'Select a Gallery and an Album!';
      missingGallery = 'Select a Gallery!';
      this.editEl.html($("#noSelectionTemplate").tmpl({
        type: Gallery.record ? missing : missingGallery
      }));
    }
    return this;
  };
  GalleryView.prototype.save = function(e) {
    if (e.keyCode !== 13) {
      return;
    }
    return Spine.App.trigger('save:gallery', this.editEl);
  };
  return GalleryView;
})();
if (typeof module !== "undefined" && module !== null) {
  module.exports = EditorView;
}