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
    'fileuploadfail': 'fail',
    'fileuploaddrop': 'drop',
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
  UploadEditView.prototype.fail = function(e, data) {
    return alert('File Upload Failed !!');
  };
  UploadEditView.prototype.drop = function(e, data) {
    var list, _ref;
    list = Gallery.selectionList();
    if (!list.length) {
      [].splice.apply(data.files, [0, data.files.length - 0].concat(_ref = [])), _ref;
      console.log(data.files);
      return this.notify();
    }
  };
  UploadEditView.prototype.add = function(e, data) {
    var album_id, list;
    console.log(data);
    list = Gallery.selectionList();
    album_id = list[0];
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
  UploadEditView.prototype.notify = function() {
    return App.modal2ButtonView.show({
      header: 'No Album selected',
      body: 'Please select an album .',
      info: ''
    });
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
