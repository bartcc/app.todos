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
    '#fileupload': 'uploadEl',
    '#fileupload .files': 'filesEl'
  };
  UploadEditView.prototype.events = {
    'click': 'click',
    'fileuploadadd #fileupload': 'add',
    'fileuploaddone #fileupload': 'done',
    'fileuploadsubmit #fileupload': 'submit',
    'change select': 'changeSelected',
    'fileuploadsend #fileupload': 'fileuploadsend'
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
    var changed;
    console.log(item);
    if (item) {
      changed = !(item != null ? item.eql(this.current) : void 0);
      console.log(changed);
      if (changed) {
        this.current = item;
        return this.render();
      }
    }
  };
  UploadEditView.prototype.render = function() {
    var album, gallery, selection;
    console.log('UploadView::render');
    selection = Gallery.selectionList();
    gallery = Gallery.record;
    album = Album.record;
    this.html(this.template({
      gallery: gallery,
      album: album
    }));
    this.el.idealforms();
    this.initFileupload();
    this.refreshElements();
    return this.el;
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
  UploadEditView.prototype.initFileupload = function() {
    console.log('UploadEditView::initFileupload');
    this.uploadEl.fileupload();
    console.log(this.filesEl);
    return $.getJSON($('form', this.uploadEl).prop('action'), function(files) {
      var fu, template;
      fu = this.uploadEl.data('fileupload');
      console.log(fu);
      fu._adjustMaxNumberOfFiles(-files.length);
      template = fu._renderDownload(files).appendTo(this.filesEl);
      fu._reflow = fu._transition && template.length && template[0].offsetWidth;
      return template.addClass('in');
    });
  };
  UploadEditView.prototype.fileuploadsend = function(e, data) {
    var redirectPage, target;
    redirectPage = window.location.href.replace(/\/[^\/]*$/, '/result.html?%s');
    if (data.dataType.substr(0, 6) === 'iframe') {
      target = $('<a/>').prop('href', data.url)[0];
      if (window.location.host !== target.host) {
        return data.formData.push({
          name: 'redirect',
          value: redirectPage
        });
      }
    }
  };
  UploadEditView.prototype.changeSelected = function(e) {
    var album, el, id;
    el = $(e.currentTarget);
    id = el.val();
    album = Album.find(id);
    album.updateSelection([album.id]);
    return Spine.trigger('album:activate');
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