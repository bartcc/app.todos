var $, EditorView;
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
EditorView = (function() {
  __extends(EditorView, Spine.Controller);
  EditorView.prototype.elements = {
    '.editEditor': 'editEl'
  };
  EditorView.prototype.events = {
    "keydown": "save"
  };
  EditorView.prototype.template = function(item) {
    return $('#editGalleryTemplate').tmpl(item);
  };
  function EditorView() {
    EditorView.__super__.constructor.apply(this, arguments);
    Spine.App.bind('change:gallery', this.proxy(this.change));
  }
  EditorView.prototype.render = function() {
    var _base;
    if (this.current && (typeof (_base = this.current).reload === "function" ? _base.reload() : void 0)) {
      this.current.reload();
      this.editEl.html(this.template(this.current));
    } else {
      this.editEl.html($("#noSelectionTemplate").tmpl({
        type: 'a gallery!'
      }));
    }
    return this;
  };
  EditorView.prototype.change = function(item) {
    this.current = item;
    return this.render();
  };
  EditorView.prototype.save = function(e) {
    if (e.keyCode !== 13) {
      return;
    }
    return Spine.App.trigger('save:gallery', this.editEl);
  };
  return EditorView;
})();
if (typeof module !== "undefined" && module !== null) {
  module.exports = EditorView;
}