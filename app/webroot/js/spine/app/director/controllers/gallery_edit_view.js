var $, GalleryEditView;
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
GalleryEditView = (function() {
  __extends(GalleryEditView, Spine.Controller);
  GalleryEditView.prototype.elements = {
    '.editGallery': 'editEl',
    '.optCreate': 'createGalleryEl'
  };
  GalleryEditView.prototype.events = {
    'click': 'click',
    'keydown': 'saveOnEnter',
    'click .optCreate': 'createGallery'
  };
  GalleryEditView.prototype.template = function(item) {
    return $('#editGalleryTemplate').tmpl(item);
  };
  function GalleryEditView() {
    GalleryEditView.__super__.constructor.apply(this, arguments);
    Spine.bind('change:selectedGallery', this.proxy(this.change));
    Gallery.bind("refresh change", this.proxy(this.change));
  }
  GalleryEditView.prototype.change = function(item, mode) {
    console.log('GalleryEditView::change');
    return this.render();
  };
  GalleryEditView.prototype.render = function() {
    console.log('GalleryEditView::render');
    if (Gallery.record) {
      this.editEl.html(this.template(Gallery.record));
    } else {
      if (!Gallery.count()) {
        this.editEl.html($("#noSelectionTemplate").tmpl({
          type: '<label class="invite"><span class="dimmed invite">Director has no gallery yet &nbsp;</span><button class="optCreate dark invite">New Gallery</button></label>'
        }));
      } else {
        this.editEl.html($("#noSelectionTemplate").tmpl({
          type: '<label><span class="dimmed">Select a gallery!</span></label>'
        }));
      }
    }
    return this;
  };
  GalleryEditView.prototype.saveOnEnter = function(e) {
    console.log('GalleryEditView::saveOnEnter');
    console.log(e.keyCode);
    if (e.keyCode !== 13) {
      return;
    }
    return Spine.trigger('save:gallery', this.editEl);
  };
  GalleryEditView.prototype.createGallery = function() {
    return Spine.trigger('create:gallery');
  };
  GalleryEditView.prototype.click = function(e) {
    console.log('click');
    e.stopPropagation();
    e.preventDefault();
    return false;
  };
  return GalleryEditView;
})();
if (typeof module !== "undefined" && module !== null) {
  module.exports = GalleryEditView;
}