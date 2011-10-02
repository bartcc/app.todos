var $, Editor;
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
Editor = (function() {
  __extends(Editor, Spine.Controller);
  Editor.prototype.elements = {
    '.editEditor': 'editEl'
  };
  Editor.prototype.events = {
    "keydown": "save"
  };
  Editor.prototype.template = function(item) {
    return $('#editContactTemplate').tmpl(item);
  };
  function Editor() {
    Editor.__super__.constructor.apply(this, arguments);
    Spine.bind('change', this.proxy(this.change));
  }
  Editor.prototype.render = function() {
    var _base;
    if (this.current && (typeof (_base = this.current).reload === "function" ? _base.reload() : void 0)) {
      this.current.reload();
      this.editEl.html(this.template(this.current));
      return this;
    }
  };
  Editor.prototype.change = function(item) {
    this.current = item;
    return this.render();
  };
  Editor.prototype.save = function(e) {
    if (e.keyCode !== 13) {
      return;
    }
    return Spine.trigger('save', this.editEl);
  };
  return Editor;
})();
if (typeof module !== "undefined" && module !== null) {
  module.exports = Editor;
}