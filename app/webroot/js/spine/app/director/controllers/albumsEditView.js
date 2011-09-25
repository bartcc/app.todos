var $, AlbumsEditView;
var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; }, __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
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
AlbumsEditView = (function() {
  __extends(AlbumsEditView, Spine.Controller);
  AlbumsEditView.prototype.elements = {
    ".content": "editContent"
  };
  AlbumsEditView.prototype.events = {
    "click .optEdit": "edit",
    "click .optEmail": "email",
    "click .optDestroy": "destroy",
    "click .optSave": "save",
    "keydown": "saveOnEnter"
  };
  AlbumsEditView.prototype.template = function(item) {
    return $("#editGalleryTemplate").tmpl(item);
  };
  function AlbumsEditView() {
    this.saveOnEnter = __bind(this.saveOnEnter, this);    AlbumsEditView.__super__.constructor.apply(this, arguments);
    Gallery.bind("change", this.proxy(this.change));
    Spine.App.bind('save:gallery', this.proxy(this.save));
    this.bind('save:gallery', this.proxy(this.save));
    Spine.App.bind('change:selectedGallery', this.proxy(this.change));
    this.create = this.edit;
  }
  AlbumsEditView.prototype.change = function(item, mode) {
    console.log('AlbumsEditView::change');
    if (!(item != null ? item.destroyed : void 0)) {
      this.current = item;
    }
    return this.render(this.current);
  };
  AlbumsEditView.prototype.render = function(item) {
    console.log('AlbumsEditView::render');
    if (item) {
      this.current = item;
    }
    if (this.current && !this.current.destroyed) {
      this.editContent.html($("#editGalleryTemplate").tmpl(this.current));
      this.focusFirstInput(this.el);
    } else {
      if (Gallery.count()) {
        this.editContent.html($("#noSelectionTemplate").tmpl({
          type: 'Select a Gallery!'
        }));
      } else {
        this.editContent.html($("#noSelectionTemplate").tmpl({
          type: 'Create a Gallery!'
        }));
      }
    }
    return this;
  };
  AlbumsEditView.prototype.destroy = function() {
    console.log('AlbumsEditView::destroy');
    this.current.destroy();
    if (!Gallery.count()) {
      return Gallery.record = false;
    }
  };
  AlbumsEditView.prototype.email = function() {
    if (!this.current.email) {
      return;
    }
    return window.location = "mailto:" + this.current.email;
  };
  AlbumsEditView.prototype.save = function(el) {
    var atts;
    console.log('AlbumsEditView::save');
    if (this.current) {
      atts = (typeof el.serializeForm === "function" ? el.serializeForm() : void 0) || this.el.serializeForm();
      this.current.updateChangedAttributes(atts);
    }
    return App.albumsManager.change(App.albumsShowView);
  };
  AlbumsEditView.prototype.saveOnEnter = function(e) {
    if (e.keyCode !== 13) {
      return;
    }
    return this.trigger('save:gallery', this);
  };
  return AlbumsEditView;
})();
if (typeof module !== "undefined" && module !== null) {
  module.exports = AlbumsView;
}