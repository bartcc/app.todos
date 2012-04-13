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
  AlbumEditView.extend(Spine.Controller.KeyEnhancer);
  AlbumEditView.prototype.elements = {
    '.content': 'item',
    '.editAlbum': 'editEl',
    'form': 'formEl'
  };
  AlbumEditView.prototype.events = {
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
  AlbumEditView.prototype.changeSelected = function(e) {
    var album, el, id;
    el = $(e.currentTarget);
    id = el.val();
    album = Album.find(id);
    album.updateSelection([album.id]);
    return Spine.trigger('album:activate');
  };
  AlbumEditView.prototype.change = function(item, mode) {
    var firstID;
    console.log('AlbumEditView::change');
    if ((item != null ? item.constructor.className : void 0) === 'Album') {
      this.current = item;
    } else {
      firstID = Gallery.selectionList()[0];
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
    console.log('AlbumEditView::render');
    selection = Gallery.selectionList();
    if (item && (selection != null ? selection.length : void 0) === 1) {
      this.item.html(this.template(item));
    } else {
      if (!(selection != null ? selection.length : void 0)) {
        this.item.html($("#noSelectionTemplate").tmpl({
          type: '<label><span class="enlightened">Select or create an album</span></label>'
        }));
      } else if ((selection != null ? selection.length : void 0) > 1) {
        this.item.html($("#noSelectionTemplate").tmpl({
          type: '<label><span class="enlightened">Multiple selection</span></label>'
        }));
      }
    }
    return this.el;
  };
  AlbumEditView.prototype.save = function(el) {
    var atts;
    console.log('AlbumEditView::save');
    if (this.current) {
      atts = (typeof el.serializeForm === "function" ? el.serializeForm() : void 0) || this.editEl.serializeForm();
      this.current.updateChangedAttributes(atts);
      Gallery.updateSelection([this.current.id]);
      return Spine.trigger('expose:sublistSelection', Gallery.record);
    }
  };
  AlbumEditView.prototype.saveOnEnter = function(e) {
    if (e.keyCode === 13) {
      this.save(this.editEl);
    }
    if (e.keyCode === 9) {
      return e.stopPropagation();
    }
  };
  AlbumEditView.prototype.click = function(e) {
    e.stopPropagation();
    return e.preventDefault();
  };
  return AlbumEditView;
})();
if (typeof module !== "undefined" && module !== null) {
  module.exports = AlbumEditView;
}
