var $, GalleryEditView;
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
GalleryEditView = (function() {
  __extends(GalleryEditView, Spine.Controller);
  GalleryEditView.extend(Spine.Controller.Toolbars);
  GalleryEditView.prototype.elements = {
    ".content": "editContent",
    '.optDestroy': 'destroyBtn',
    '.optSave': 'saveBtn',
    '.toolbar': 'toolBar'
  };
  GalleryEditView.prototype.events = {
    "click .optEdit": "edit",
    "click .optEmail": "email",
    "click .optDestroy": "destroy",
    "click .optSave": "save",
    "keydown": "saveOnEnter"
  };
  GalleryEditView.prototype.template = function(item) {
    return $("#editGalleryTemplate").tmpl(item);
  };
  GalleryEditView.prototype.toolsTemplate = function(items) {
    return $("#toolsTemplate").tmpl(items);
  };
  function GalleryEditView() {
    this.saveOnEnter = __bind(this.saveOnEnter, this);    GalleryEditView.__super__.constructor.apply(this, arguments);
    Gallery.bind("change", this.proxy(this.change));
    Spine.bind('save:gallery', this.proxy(this.save));
    Spine.bind('change:selectedGallery', this.proxy(this.change));
    this.bind('save:gallery', this.proxy(this.save));
    this.bind('render:toolbar', this.proxy(this.renderToolbar));
  }
  GalleryEditView.prototype.change = function(item, mode) {
    console.log('GalleryEditView::change');
    if (!(item != null ? item.destroyed : void 0)) {
      this.current = item;
    }
    return this.render(this.current);
  };
  GalleryEditView.prototype.render = function(item) {
    console.log('GalleryEditView::render');
    if (item) {
      this.current = item;
    }
    if (this.current && !this.current.destroyed) {
      this.destroyBtn.removeClass('disabled');
      this.editContent.html($("#editGalleryTemplate").tmpl(this.current));
    } else {
      this.destroyBtn.addClass('disabled');
      this.destroyBtn.unbind('click');
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
    this.changeToolbar('GalleryEdit');
    return this;
  };
  GalleryEditView.prototype.renderToolbar = function() {
    console.log('GalleryEditView::renderToolbar');
    this.toolBar.html(this.toolsTemplate(this.currentToolbar));
    return this.refreshElements();
  };
  GalleryEditView.prototype.destroy = function(e) {
    console.log('GalleryEditView::destroy');
    if ($(e.currentTarget).hasClass('disabled')) {
      return;
    }
    return Spine.trigger('destroy:gallery');
  };
  GalleryEditView.prototype.save = function(el) {
    var atts;
    console.log('GalleryEditView::save');
    if ($(el.currentTarget).hasClass('disabled')) {
      return;
    }
    if (this.current && Gallery.record) {
      atts = (typeof el.serializeForm === "function" ? el.serializeForm() : void 0) || this.el.serializeForm();
      this.current.updateChangedAttributes(atts);
    }
    return App.contentManager.change(App.showView);
  };
  GalleryEditView.prototype.saveOnEnter = function(e) {
    console.log('GalleryEditView::saveOnEnter');
    if (e.keyCode !== 13) {
      return;
    }
    return this.trigger('save:gallery', this);
  };
  return GalleryEditView;
})();
if (typeof module !== "undefined" && module !== null) {
  module.exports = GalleryEditView;
}