var $, PhotoView;
var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; }, __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
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
PhotoView = (function() {
  __extends(PhotoView, Spine.Controller);
  PhotoView.prototype.elements = {
    '.content': 'item',
    '.editPhoto': 'editEl'
  };
  PhotoView.prototype.events = {
    'click': 'click',
    'keydown': 'saveOnEnter'
  };
  PhotoView.prototype.template = function(item) {
    return $('#editPhotoTemplate').tmpl(item);
  };
  function PhotoView() {
    this.saveOnEnter = __bind(this.saveOnEnter, this);    PhotoView.__super__.constructor.apply(this, arguments);
    Spine.bind('change:selectedPhoto', this.proxy(this.change));
    Spine.bind('change:selectedAlbum', this.proxy(this.change));
    Spine.bind('change:selectedGallery', this.proxy(this.change));
  }
  PhotoView.prototype.change = function(item) {
    if ((item != null ? item.constructor.className : void 0) === 'Photo') {
      this.current = item;
    }
    return this.render(this.current);
  };
  PhotoView.prototype.render = function(item) {
    var selection;
    selection = Album.selectionList();
    if (!(selection != null ? selection.length : void 0)) {
      this.item.html($("#noSelectionTemplate").tmpl({
        type: '<label><span class="dimmed">Select or upload an photo!</span></label>'
      }));
    } else if ((selection != null ? selection.length : void 0) > 1) {
      this.item.html($("#noSelectionTemplate").tmpl({
        type: '<label><span class="dimmed">Multiple selection</span></label>'
      }));
    } else if (!item) {
      if (!Album.count()) {
        this.item.html($("#noSelectionTemplate").tmpl({
          type: '<label><span class="dimmed">Create a album!</span></label>'
        }));
      } else {
        this.item.html($("#noSelectionTemplate").tmpl({
          type: '<label><span class="dimmed">Select a album!</span></label>'
        }));
      }
    } else {
      this.item.html(this.template(item));
    }
    return this.el;
  };
  PhotoView.prototype.save = function(el) {
    var atts;
    console.log('PhotoView::save');
    if (this.current) {
      atts = (typeof el.serializeForm === "function" ? el.serializeForm() : void 0) || this.editEl.serializeForm();
      this.current.updateChangedAttributes(atts);
      return Album.updateSelection([this.current.id]);
    }
  };
  PhotoView.prototype.saveOnEnter = function(e) {
    if (e.keyCode !== 13) {
      return;
    }
    return this.save(this.editEl);
  };
  PhotoView.prototype.click = function(e) {
    e.stopPropagation();
    e.preventDefault();
    return false;
  };
  return PhotoView;
})();
if (typeof module !== "undefined" && module !== null) {
  module.exports = PhotoView;
}