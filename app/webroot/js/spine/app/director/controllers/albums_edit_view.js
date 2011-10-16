var $, AlbumsEditView;
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
AlbumsEditView = (function() {
  __extends(AlbumsEditView, Spine.Controller);
  AlbumsEditView.prototype.elements = {
    ".content": "editContent",
    '.optDestroy': 'btnDestroy'
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
    Spine.bind('save:gallery', this.proxy(this.save));
    this.bind('save:gallery', this.proxy(this.save));
    Spine.bind('change:selectedGallery', this.proxy(this.change));
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
      this.btnDestroy.removeClass('disabled');
      this.editContent.html($("#editGalleryTemplate").tmpl(this.current));
    } else {
      this.btnDestroy.addClass('disabled');
      this.btnDestroy.unbind('click');
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
    if (!Gallery.record) {
      return;
    }
    return Spine.trigger('destroy:gallery');
  };
  AlbumsEditView.prototype.save = function(el) {
    var atts;
    console.log('AlbumsEditView::save');
    if (this.current) {
      atts = (typeof el.serializeForm === "function" ? el.serializeForm() : void 0) || this.el.serializeForm();
      this.current.updateChangedAttributes(atts);
    }
    App.albumsManager.change(App.albumsShowView);
    return this.openPanel('album', App.albumsShowView.btnAlbum);
  };
  AlbumsEditView.prototype.saveOnEnter = function(e) {
    console.log('AlbumsEditView::saveOnEnter');
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