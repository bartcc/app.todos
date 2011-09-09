var $, Album;
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
Album = (function() {
  __extends(Album, Spine.Controller);
  Album.prototype.elements = {
    '.editAlbum': 'editEl'
  };
  Album.prototype.events = {
    "click .item": "click",
    "keydown": "save"
  };
  Album.prototype.template = function(item) {
    return $('#editContactTemplate').tmpl(item);
  };
  function Album() {
    Album.__super__.constructor.apply(this, arguments);
    Spine.App.bind('change', this.proxy(this.change));
  }
  Album.prototype.render = function() {
    if (!this.current.destroyed) {
      this.current.reload();
      this.editEl.html(this.template(this.current));
      return this.editEl;
    }
  };
  Album.prototype.change = function(item) {
    this.current = item;
    return this.render();
  };
  Album.prototype.save = function(e) {
    if (e.keyCode !== 13) {
      return;
    }
    return Spine.App.trigger('save', this.editEl);
  };
  return Album;
})();
if (typeof module !== "undefined" && module !== null) {
  module.exports = Album;
}