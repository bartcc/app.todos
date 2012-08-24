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
    '.files': 'filesEl',
    '.uploadinfo': 'uploadinfoEl'
  };
  UploadEditView.prototype.events = {
    'change select': 'changeSelected',
    'fileuploaddone': 'done',
    'fileuploadsubmit': 'submit',
    'fileuploadadd': 'add',
    'fileuploadpaste': 'paste',
    'fileuploadsend': 'send'
  };
  UploadEditView.prototype.template = function(item) {
    return $('#fileuploadTemplate').tmpl(item);
  };
  function UploadEditView() {
    UploadEditView.__super__.constructor.apply(this, arguments);
    this.bind("change", this.change);
    Album.bind('change', this.proxy(this.change));
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
    var album_id, _ref;
    album_id = (_ref = Album.record) != null ? _ref.id : void 0;
    if (data.files.length) {
      $.extend(data, {
        link: album_id ? album_id : void 0
      });
      this.c = App.hmanager.hasActive();
      App.hmanager.change(this);
      if (!App.showView.isQuickUpload()) {
        return App.showView.openPanel('upload');
      }
    }
  };
  UploadEditView.prototype.send = function(e, data) {
    var album;
    console.log('UploadView::send');
    album = Album.exists(data.link);
    if (album) {
      return Spine.trigger('loading:start', album);
    }
  };
  UploadEditView.prototype.done = function(e, data) {
    var album, photo, raw, raws, _i, _len;
    album = Album.exists(data.link);
    raws = $.parseJSON(data.jqXHR.responseText);
    Photo.refresh(raws, {
      clear: false
    });
    if (album) {
      for (_i = 0, _len = raws.length; _i < _len; _i++) {
        raw = raws[_i];
        photo = Photo.exists(raw['Photo'].id);
        if (photo) {
          Photo.trigger('create:join', photo, album);
        }
      }
      Spine.trigger('album:updateBuffer', album);
      Spine.trigger('loading:done', album);
    }
    if (App.showView.isQuickUpload()) {
      App.hmanager.change(this.c);
    }
    return e.preventDefault();
  };
  UploadEditView.prototype.paste = function(e, data) {};
  UploadEditView.prototype.submit = function(e, data) {
    console.log('UploadView::submit');
    return console.log(data);
  };
  UploadEditView.prototype.changeSelected = function(e) {
    var album, el, id;
    el = $(e.currentTarget);
    id = el.val();
    album = Album.exists(id);
    if (album) {
      album.updateSelection([album.id]);
      return Spine.trigger('album:activate');
    }
  };
  return UploadEditView;
})();
if (typeof module !== "undefined" && module !== null) {
  module.exports = UploadEditView;
}
