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
    '.editGallery': 'editEl',
    '.optCreate': 'createGalleryEl'
  };
  GalleryView.prototype.events = {
    "keydown": "saveOnEnter",
    'click .optCreate': 'createGallery'
  };
  GalleryView.prototype.template = function(item) {
    return $('#editGalleryTemplate').tmpl(item);
  };
  function GalleryView() {
    GalleryView.__super__.constructor.apply(this, arguments);
    Spine.bind('change:selectedGallery', this.proxy(this.change));
    Gallery.bind("change", this.proxy(this.change));
  }
  GalleryView.prototype.change = function(item, mode) {
    console.log('Gallery::change');
    return this.render();
  };
  GalleryView.prototype.render = function() {
    console.log('Gallery::render');
    if (Gallery.record) {
      this.editEl.html(this.template(Gallery.record));
    } else {
      if (!Gallery.count()) {
        this.editEl.html($("#noSelectionTemplate").tmpl({
          type: '<label><span class="dimmed">Director has no gallery yet &nbsp;<button class="optCreate dark">New Gallery</button></span></label>'
        }));
      } else {
        this.editEl.html($("#noSelectionTemplate").tmpl({
          type: '<label><span class="dimmed">Select a gallery!</span></label>'
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
  GalleryView.prototype.createGallery = function() {
    return Spine.trigger('create:gallery');
  };
  return GalleryView;
})();
if (typeof module !== "undefined" && module !== null) {
  module.exports = GalleryView;
}