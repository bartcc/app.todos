var UploadView;
var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
UploadView = (function() {
  __extends(UploadView, Spine.Controller);
  UploadView.prototype.events = {
    'click': 'click',
    'fileuploadadd': 'add',
    'fileuploaddone': 'done',
    'fileuploadsubmit': 'submit'
  };
  UploadView.prototype.template = function(item) {
    return $('#fileuploadTemplate').tmpl(item);
  };
  function UploadView() {
    UploadView.__super__.constructor.apply(this, arguments);
    this.bind("change", this.change);
    Album.bind('change', this.proxy(this.render));
    Spine.bind('change:selectedAlbum', this.proxy(this.render));
    Spine.bind('change:selectedGallery', this.proxy(this.render));
    Gallery.bind('refresh', this.proxy(this.render));
  }
  UploadView.prototype.render = function() {
    var album, gallery, selection, _ref;
    console.log('UploadView::render');
    selection = Gallery.selectionList();
    gallery = Gallery.record;
    if (Album.exists(selection[0])) {
      album = Album.find(selection[0]);
    }
    if (!((_ref = this.current) != null ? _ref.eql(album) : void 0)) {
      this.html(this.template({
        gallery: gallery,
        album: album
      }));
      return this.current = album;
    }
  };
  UploadView.prototype.add = function(e, data) {
    return console.log('UploadView::add');
  };
  UploadView.prototype.done = function(e, data) {
    var photos;
    console.log('UploadView::done');
    photos = $.parseJSON(data.jqXHR.responseText);
    return Photo.refresh(photos, {
      clear: false
    });
  };
  UploadView.prototype.submit = function(e, data) {
    return console.log('UploadView::submit');
  };
  UploadView.prototype.click = function(e) {
    console.log('click');
    e.stopPropagation();
    e.preventDefault();
    return false;
  };
  return UploadView;
})();