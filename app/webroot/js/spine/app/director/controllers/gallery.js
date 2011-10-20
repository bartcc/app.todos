var $, GalleryView;
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
GalleryView = (function() {
  __extends(GalleryView, Spine.Controller);
  GalleryView.prototype.elements = {
    '.editGallery': 'editEl'
  };
  GalleryView.prototype.events = {
    "keydown": "saveOnEnter"
  };
  GalleryView.prototype.template = function(item) {
    return $('#editGalleryTemplate').tmpl(item);
  };
  function GalleryView() {
    GalleryView.__super__.constructor.apply(this, arguments);
    Spine.bind('change:selectedGallery', this.proxy(this.change));
    Gallery.bind("change", this.proxy(this.change));
  }
  GalleryView.prototype.change = function(item) {
    console.log('Gallery::change');
    this.current = item;
    return this.render();
  };
  GalleryView.prototype.render = function() {
    console.log('Gallery::render');
    if (this.current && !this.current.destroyed) {
      this.editEl.html(this.template(this.current));
    } else {
      if (!Gallery.count()) {
        this.editEl.html($("#noSelectionTemplate").tmpl({
          type: 'Create a Gallery!'
        }));
      } else {
        this.editEl.html($("#noSelectionTemplate").tmpl({
          type: 'Select a Gallery!'
        }));
      }
    }
    return this;
  };
  GalleryView.prototype.saveOnEnter = function(e) {
    if (e.keyCode !== 13) {
      return;
    }
    return Spine.trigger('save:gallery', this.editEl);
  };
  return GalleryView;
})();
if (typeof module !== "undefined" && module !== null) {
  module.exports = EditorView;
}