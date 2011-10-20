var $, AlbumView;
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
AlbumView = (function() {
  __extends(AlbumView, Spine.Controller);
  AlbumView.prototype.elements = {
    '.item': 'item',
    '.editAlbum': 'editEl'
  };
  AlbumView.prototype.events = {
    "click .item": "click",
    'keydown': 'saveOnEnter'
  };
  AlbumView.prototype.template = function(item) {
    console.log('Album::template');
    console.log(item.id);
    return $('#editAlbumTemplate').tmpl(item);
  };
  function AlbumView() {
    this.saveOnEnter = __bind(this.saveOnEnter, this);    AlbumView.__super__.constructor.apply(this, arguments);
    Spine.bind('change:selectedAlbum', this.proxy(this.change));
    Spine.bind('change:selectedGallery', this.proxy(this.change));
  }
  AlbumView.prototype.change = function(item, mode) {
    console.log('Album::change');
    if (item instanceof Album) {
      this.current = item;
    } else {
      this.current = null;
    }
    return this.render(this.current, mode);
  };
  AlbumView.prototype.render = function(item, mode) {
    var selection;
    console.log('Album::render');
    selection = Gallery.selectionList();
    if ((selection != null ? selection.length : void 0) === 0) {
      this.item.html($("#noSelectionTemplate").tmpl({
        type: 'Select or Create an Album!'
      }));
    } else if ((selection != null ? selection.length : void 0) > 1) {
      this.item.html($("#noSelectionTemplate").tmpl({
        type: 'Multiple Selection'
      }));
    } else if (!item) {
      this.item.html($("#noSelectionTemplate").tmpl({
        type: 'Select an Gallery!'
      }));
    } else {
      this.item.html(this.template(item));
    }
    return this;
  };
  AlbumView.prototype.save = function(el) {
    var atts;
    console.log('Album::save');
    if (this.current) {
      atts = (typeof el.serializeForm === "function" ? el.serializeForm() : void 0) || this.editEl.serializeForm();
      return this.current.updateChangedAttributes(atts);
    }
  };
  AlbumView.prototype.saveOnEnter = function(e) {
    if (e.keyCode !== 13) {
      return;
    }
    return this.save(this.editEl);
  };
  AlbumView.prototype.click = function() {
    return console.log('click');
  };
  return AlbumView;
})();
if (typeof module !== "undefined" && module !== null) {
  module.exports = AlbumView;
}