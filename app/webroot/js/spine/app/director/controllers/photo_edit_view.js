var $, PhotoEditView;
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
PhotoEditView = (function() {
  __extends(PhotoEditView, Spine.Controller);
  PhotoEditView.prototype.elements = {
    '.content': 'item',
    '.editPhoto': 'editEl'
  };
  PhotoEditView.prototype.events = {
    'click': 'click',
    'keydown': 'saveOnEnter'
  };
  PhotoEditView.prototype.template = function(item) {
    return $('#editPhotoTemplate').tmpl(item);
  };
  function PhotoEditView() {
    this.saveOnEnter = __bind(this.saveOnEnter, this);    PhotoEditView.__super__.constructor.apply(this, arguments);
    Spine.bind('change:selectedPhoto', this.proxy(this.change));
    Spine.bind('change:selectedAlbum', this.proxy(this.change));
  }
  PhotoEditView.prototype.change = function(item) {
    if ((item != null ? item.constructor.className : void 0) === 'Photo') {
      this.current = item;
    }
    return this.render(this.current);
  };
  PhotoEditView.prototype.render = function(item) {
    var selection;
    selection = Album.selectionList();
    if (!(selection != null ? selection.length : void 0)) {
      this.item.html($("#noSelectionTemplate").tmpl({
        type: '<label><span class="enlightened">No photo selected</span></label>'
      }));
    } else if ((selection != null ? selection.length : void 0) > 1) {
      this.item.html($("#noSelectionTemplate").tmpl({
        type: '<label><span class="enlightened">Multiple selection</span></label>'
      }));
    } else if (!item) {
      if (!Album.count()) {
        this.item.html($("#noSelectionTemplate").tmpl({
          type: '<label><span class="enlightened">Create a album!</span></label>'
        }));
      } else {
        this.item.html($("#noSelectionTemplate").tmpl({
          type: '<label><span class="enlightened">Select a album!</span></label>'
        }));
      }
    } else {
      this.item.html(this.template(item));
    }
    return this.el;
  };
  PhotoEditView.prototype.save = function(el) {
    var atts;
    console.log('PhotoView::save');
    if (this.current) {
      atts = (typeof el.serializeForm === "function" ? el.serializeForm() : void 0) || this.editEl.serializeForm();
      this.current.updateChangedAttributes(atts);
      return Album.updateSelection([this.current.id]);
    }
  };
  PhotoEditView.prototype.saveOnEnter = function(e) {
    if (e.keyCode !== 13) {
      return;
    }
    return this.save(this.editEl);
  };
  PhotoEditView.prototype.click = function(e) {
    e.stopPropagation();
    e.preventDefault();
    return false;
  };
  return PhotoEditView;
})();
if (typeof module !== "undefined" && module !== null) {
  module.exports = PhotoEditView;
}
