var $, GalleryEditorView;
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
GalleryEditorView = (function() {
  __extends(GalleryEditorView, Spine.Controller);
  GalleryEditorView.extend(Spine.Controller.KeyEnhancer);
  GalleryEditorView.prototype.elements = {
    ".content": "editContent",
    '.optDestroy': 'destroyBtn',
    '.optSave': 'saveBtn',
    '.toolbar': 'toolbarEl'
  };
  GalleryEditorView.prototype.events = {
    "click .optDestroy": "destroy",
    "click .optSave": "save",
    "keydown": "saveOnEnter"
  };
  GalleryEditorView.prototype.template = function(item) {
    return $("#editGalleryTemplate").tmpl(item);
  };
  GalleryEditorView.prototype.toolsTemplate = function(items) {
    return $("#toolsTemplate").tmpl(items);
  };
  function GalleryEditorView() {
    this.saveOnEnter = __bind(this.saveOnEnter, this);    GalleryEditorView.__super__.constructor.apply(this, arguments);
    this.toolbar = new ToolbarView({
      el: this.toolbarEl,
      template: this.toolsTemplate
    });
    Gallery.bind("change", this.proxy(this.change));
    Spine.bind('save:gallery', this.proxy(this.save));
    Spine.bind('change:selectedGallery', this.proxy(this.change));
    Spine.bind('change:toolbar', this.proxy(this.changeToolbar));
    this.bind('change', this.proxy(this.changed));
    this.bind('active', this.proxy(this.changed));
  }
  GalleryEditorView.prototype.changed = function() {
    return alert('changed to galleries\' edit view');
  };
  GalleryEditorView.prototype.change = function(item, mode) {
    console.log('GalleryEditView::change');
    if (!(item != null ? item.destroyed : void 0)) {
      this.current = item;
    }
    return this.render(this.current);
  };
  GalleryEditorView.prototype.render = function(item) {
    console.log('GalleryEditorView::render');
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
    this.changeToolbar(['GalleryEdit']);
    return this.el;
  };
  GalleryEditorView.prototype.changeToolbar = function(list) {
    this.toolbar.change(list);
    return this.refreshElements();
  };
  GalleryEditorView.prototype.renderToolbar = function(el) {
    var _ref;
    if ((_ref = this[el]) != null) {
      _ref.html(this.toolsTemplate(this.currentToolbar));
    }
    return this.refreshElements();
  };
  GalleryEditorView.prototype.destroy = function(e) {
    return Spine.trigger('destroy:gallery');
  };
  GalleryEditorView.prototype.save = function(el) {
    var atts;
    if (this.current && Gallery.record) {
      atts = (typeof el.serializeForm === "function" ? el.serializeForm() : void 0) || this.el.serializeForm();
      this.current.updateChangedAttributes(atts);
    }
    return App.contentManager.change(App.showView);
  };
  GalleryEditorView.prototype.saveOnEnter = function(e) {
    console.log('GalleryEditorView::saveOnEnter');
    if (e.keyCode !== 13) {
      return;
    }
    return Spine.trigger('save:gallery', this);
  };
  return GalleryEditorView;
})();
if (typeof module !== "undefined" && module !== null) {
  module.exports = GalleryEditorView;
}
