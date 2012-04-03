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
  UploadEditView.prototype.elements = {
    '#fileupload': 'uploader',
    '.files': 'filesEl',
    '.uploadinfo': 'uploadinfoEl'
  };
  UploadEditView.prototype.events = {
    'change select': 'changeSelected',
    'fileuploaddone': 'done',
    'fileuploadsubmit': 'submit',
    'fileuploadadd': 'add',
    'fileuploadpaste': 'paste'
  };
  UploadEditView.prototype.template = function(item) {
    return $('#fileuploadTemplate').tmpl(item);
  };
  function UploadEditView() {
    UploadEditView.__super__.constructor.apply(this, arguments);
    this.bind("change", this.change);
    Album.bind('change', this.proxy(this.change));
    Spine.bind('change:selectedAlbum', this.proxy(this.change));
  }
  UploadEditView.prototype.change = function(item) {
    return this.render();
  };
  UploadEditView.prototype.render = function() {
    var gallery, selection;
    console.log('UploadView::render');
    selection = Gallery.selectionList();
    gallery = Gallery.record;
    this.album = Album.record;
    this.uploadinfoEl.html(this.template({
      gallery: gallery,
      album: this.album
    }));
    this.refreshElements();
    return this.el;
  };
  UploadEditView.prototype.add = function(e, data) {
    if (data.files.length) {
      this.c = App.hmanager.hasActive();
      App.hmanager.change(this);
      if (!App.showView.isQuickUpload()) {
        return App.showView.openPanel('upload');
      }
    }
  };
  UploadEditView.prototype.done = function(e, data) {
    var photos;
    photos = $.parseJSON(data.jqXHR.responseText);
    Photo.refresh(photos, {
      clear: false
    });
    Spine.trigger('album:updateBuffer', this.album);
    if (App.showView.isQuickUpload()) {
      App.hmanager.change(this.c);
    }
    return e.preventDefault();
  };
  UploadEditView.prototype.paste = function(e, data) {};
  UploadEditView.prototype.submit = function(e, data) {
    console.log('UploadView::submit');
    return e.stopPropagation();
  };
  UploadEditView.prototype.changeSelected = function(e) {
    var album, el, id;
    el = $(e.currentTarget);
    id = el.val();
    album = Album.find(id);
    album.updateSelection([album.id]);
    return Spine.trigger('album:activate');
  };
  return UploadEditView;
})();
if (typeof module !== "undefined" && module !== null) {
  module.exports = UploadEditView;
}
