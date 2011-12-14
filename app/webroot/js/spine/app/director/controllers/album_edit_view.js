var $, AlbumEditView;
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
AlbumEditView = (function() {
  __extends(AlbumEditView, Spine.Controller);
  AlbumEditView.prototype.elements = {
    '.content': 'item',
    '.editAlbum': 'editEl'
  };
  AlbumEditView.prototype.events = {
    "click": "click",
    'keydown': 'saveOnEnter'
  };
  AlbumEditView.prototype.template = function(item) {
    return $('#editAlbumTemplate').tmpl(item);
  };
  function AlbumEditView() {
    this.saveOnEnter = __bind(this.saveOnEnter, this);    AlbumEditView.__super__.constructor.apply(this, arguments);
    Spine.bind('change:selectedAlbum', this.proxy(this.change));
    Spine.bind('change:selectedGallery', this.proxy(this.change));
  }
  AlbumEditView.prototype.change = function(item, mode) {
    var firstID;
    console.log('Album::change');
    if ((item != null ? item.constructor.className : void 0) === 'Album') {
      this.current = item;
    } else {
      firstID = Gallery.selectionList(Gallery.record.id)[0];
      if (Album.exists(firstID)) {
        this.current = Album.find(firstID);
      } else {
        this.current = false;
      }
    }
    return this.render(this.current, mode);
  };
  AlbumEditView.prototype.render = function(item, mode) {
    var selection;
    console.log('AlbumView::render');
    selection = Gallery.selectionList();
    if (!(selection != null ? selection.length : void 0)) {
      this.item.html($("#noSelectionTemplate").tmpl({
        type: '<label><span class="disabled">Select or create an album!</span></label>'
      }));
    } else if ((selection != null ? selection.length : void 0) > 1) {
      this.item.html($("#noSelectionTemplate").tmpl({
        type: '<label><span class="disabled">Multiple selection</span></label>'
      }));
    } else if (!item) {
      if (!Gallery.count()) {
        this.item.html($("#noSelectionTemplate").tmpl({
          type: '<label><span class="disabled">Create a gallery!</span></label>'
        }));
      } else {
        this.item.html($("#noSelectionTemplate").tmpl({
          type: '<label><span class="disabled">Select a gallery!</span></label>'
        }));
      }
    } else {
      this.item.html(this.template(item));
    }
    return this.el;
  };
  AlbumEditView.prototype.save = function(el) {
    var atts;
    console.log('AlbumView::save');
    if (this.current) {
      atts = (typeof el.serializeForm === "function" ? el.serializeForm() : void 0) || this.editEl.serializeForm();
      this.current.updateChangedAttributes(atts);
      Gallery.updateSelection([this.current.id]);
      return Spine.trigger('expose:sublistSelection', Gallery.record);
    }
  };
  AlbumEditView.prototype.saveOnEnter = function(e) {
    if (e.keyCode !== 13) {
      return;
    }
    return this.save(this.editEl);
  };
  AlbumEditView.prototype.click = function(e) {
    console.log('click');
    e.stopPropagation();
    e.preventDefault();
    return false;
  };
  return AlbumEditView;
})();
if (typeof module !== "undefined" && module !== null) {
  module.exports = AlbumEditView;
}