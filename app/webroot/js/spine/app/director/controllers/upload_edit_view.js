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
    'fileuploadsend': 'send',
    'fileuploadprogressall': 'alldone'
  };
  UploadEditView.prototype.template = function(item) {
    return $('#fileuploadTemplate').tmpl(item);
  };
  function UploadEditView() {
    UploadEditView.__super__.constructor.apply(this, arguments);
    Spine.bind('change:selectedAlbum', this.proxy(this.change));
    this.queue = [];
  }
  UploadEditView.prototype.change = function(item) {
    return this.render();
  };
  UploadEditView.prototype.render = function() {
    var gallery, selection;
    console.log('UploadView::render');
    selection = Gallery.selectionList();
    gallery = Gallery.record;
    this.album = (Album.exists(selection[0]) ? Album.find(selection[0]) : void 0) || false;
    this.uploadinfoEl.html(this.template({
      gallery: gallery,
      album: this.album
    }));
    this.refreshElements();
    return this.el;
  };
  UploadEditView.prototype.add = function(e, data) {
    var album_id, list;
    list = Gallery.selectionList();
    if (!list.length) {
      return;
    }
    album_id = list[list.length - 1];
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
    album = Album.exists(data.link);
    if (album) {
      return Spine.trigger('loading:start', album);
    }
  };
  UploadEditView.prototype.alldone = function(e, data) {};
  UploadEditView.prototype.done = function(e, data) {
    var album, idx, photo, raw, raws, _len;
    album = Album.exists(data.link);
    raws = $.parseJSON(data.jqXHR.responseText);
    Photo.refresh(raws, {
      clear: false
    });
    if (album) {
      for (idx = 0, _len = raws.length; idx < _len; idx++) {
        raw = raws[idx];
        photo = Photo.exists(raw['Photo'].id);
        if (photo) {
          Photo.trigger('create:join', photo, album);
        }
        Spine.trigger('loading:done', album);
      }
      Spine.trigger('album:updateBuffer', album);
    }
    if (App.showView.isQuickUpload()) {
      App.hmanager.change(this.c);
    }
    return e.preventDefault();
  };
  UploadEditView.prototype.paste = function(e, data) {};
  UploadEditView.prototype.submit = function(e, data) {};
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
