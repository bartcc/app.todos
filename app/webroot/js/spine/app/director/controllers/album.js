var $, AlbumView;
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
    return $('#editAlbumTemplate').tmpl(item);
  };
  function AlbumView() {
    this.saveOnEnter = __bind(this.saveOnEnter, this);    AlbumView.__super__.constructor.apply(this, arguments);
    Album.bind('change', this.proxy(this.change));
    Spine.App.bind('change:album', this.proxy(this.change));
  }
  AlbumView.prototype.change = function(item) {
    return this.render();
  };
  AlbumView.prototype.render = function() {
    var album, albumid, noalbum, nogallery;
    albumid = this.albumid();
    if (Album.exists(albumid)) {
      album = Album.find(albumid);
    }
    if (album) {
      this.current = album;
      this.item.html(this.template(album));
      this.focusFirstInput(this.editEl);
    } else {
      nogallery = 'a Gallery and an Album!';
      noalbum = 'an Album!';
      this.item.html($("#noSelectionTemplate").tmpl({
        type: Gallery.record ? noalbum : nogallery
      }));
    }
    return this;
  };
  AlbumView.prototype.albumid = function() {
    var albid, gal;
    gal = Gallery.selected();
    albid = gal.selectedAlbumId;
    return gal.selectedAlbumId;
  };
  AlbumView.prototype.selected = function() {
    return App.sidebar;
  };
  AlbumView.prototype.save = function(el) {
    var atts;
    atts = (typeof el.serializeForm === "function" ? el.serializeForm() : void 0) || this.editEl.serializeForm();
    this.current.updateChangedAttributes(atts);
    return this.change();
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