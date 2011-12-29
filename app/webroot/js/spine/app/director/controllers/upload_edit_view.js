var $, UploadEditView;
var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
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
UploadEditView = (function() {
  __extends(UploadEditView, Spine.Controller);
  UploadEditView.prototype.events = {
    'click': 'click',
    'fileuploadadd': 'add',
    'fileuploaddone': 'done',
    'fileuploadsubmit': 'submit'
  };
  UploadEditView.prototype.template = function(item) {
    return $('#fileuploadTemplate').tmpl(item);
  };
  function UploadEditView() {
    UploadEditView.__super__.constructor.apply(this, arguments);
    this.bind("change", this.change);
    Album.bind('change', this.proxy(this.render));
    Spine.bind('change:selectedAlbum', this.proxy(this.render));
    Spine.bind('change:selectedGallery', this.proxy(this.render));
    Gallery.bind('refresh', this.proxy(this.render));
  }
  UploadEditView.prototype.render = function() {
    var album, gallery, selection;
    console.log('UploadView::render');
    selection = Gallery.selectionList();
    gallery = Gallery.record;
    album = Album.record;
    return this.html(this.template({
      gallery: gallery,
      album: album
    }));
  };
  UploadEditView.prototype.add = function(e, data) {
    return console.log('UploadView::add');
  };
  UploadEditView.prototype.done = function(e, data) {
    var photos;
    console.log('UploadView::done');
    photos = $.parseJSON(data.jqXHR.responseText);
    return Photo.refresh(photos, {
      clear: false
    });
  };
  UploadEditView.prototype.submit = function(e, data) {
    return console.log('UploadView::submit');
  };
  UploadEditView.prototype.click = function(e) {
    console.log('click');
    e.stopPropagation();
    e.preventDefault();
    return false;
  };
  return UploadEditView;
})();
if (typeof module !== "undefined" && module !== null) {
  module.exports = UploadEditView;
}