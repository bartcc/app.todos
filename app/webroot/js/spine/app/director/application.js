var App;
var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
App = (function() {
  __extends(App, Spine.Controller);
  App.prototype.elements = {
    '#sidebar-wrapper': 'sidebarEl',
    '#albums': 'albumsEl',
    '#albums .show': 'albumsShowEl',
    '#albums .edit': 'albumsEditEl',
    '#gallery': 'galleryEl',
    '#album': 'albumEl',
    '#upload': 'uploadEl',
    '#grid': 'gridEl',
    '.vdraggable': 'vDrag',
    '.hdraggable': 'hDrag'
  };
  function App() {
    App.__super__.constructor.apply(this, arguments);
    this.sidebar = new SidebarView({
      el: this.sidebarEl
    });
    this.gallery = new GalleryView({
      el: this.galleryEl
    });
    this.album = new AlbumView({
      el: this.albumEl
    });
    this.upload = new UploadView({
      el: this.uploadEl
    });
    this.grid = new GridView({
      el: this.gridEl
    });
    this.albumsShowView = new AlbumsShowView({
      el: this.albumsShowEl
    });
    this.albumsEditView = new AlbumsEditView({
      el: this.albumsEditEl
    });
    this.vmanager = new Spine.Manager(this.sidebar);
    this.vmanager.initDrag(this.vDrag, {
      initSize: this.proxy(function() {
        return $(this.sidebar.el).width() / 2;
      }),
      disabled: false,
      axis: 'x',
      min: 250,
      max: this.proxy(function() {
        return $(this.el).width() / 2;
      })
    });
    this.hmanager = new Spine.Manager(this.gallery, this.album, this.upload, this.grid);
    this.hmanager.initDrag(this.hDrag, {
      initSize: this.proxy(function() {
        return $(this.el).height() / 2;
      }),
      disabled: false,
      axis: 'y',
      min: 30,
      max: this.proxy(function() {
        return this.el.height() * 2 / 3;
      }),
      goSleep: this.proxy(function() {
        var _ref;
        return (_ref = this.albumsShowView.activeControl) != null ? _ref.click() : void 0;
      })
    });
    this.albumsManager = new Spine.Manager(this.albumsShowView, this.albumsEditView);
  }
  return App;
})();
$(function() {
  window.App = new App({
    el: $('body')
  });
  return App.albumsManager.change(App.albumsShowView);
});