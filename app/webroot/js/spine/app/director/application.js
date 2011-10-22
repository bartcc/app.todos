var App;
var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
}, __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
App = (function() {
  __extends(App, Spine.Controller);
  App.prototype.elements = {
    '#sidebar': 'sidebarEl',
    '#albums': 'albumsEl',
    '#albums .show': 'albumsShowEl',
    '#albums .edit': 'albumsEditEl',
    '#gallery': 'galleryEl',
    '#album': 'albumEl',
    '#upload': 'uploadEl',
    '#grid': 'gridEl',
    '#login': 'loginEl',
    '.vdraggable': 'vDrag',
    '.hdraggable': 'hDrag',
    '.show .content': 'content'
  };
  function App() {
    App.__super__.constructor.apply(this, arguments);
    User.bind('pinger', this.proxy(this.userconfirmation));
    this.sidebar = new SidebarView({
      el: this.sidebarEl,
      className: 'SidebarView'
    });
    this.gallery = new GalleryView({
      el: this.galleryEl,
      className: 'GalleryView'
    });
    this.album = new AlbumView({
      el: this.albumEl,
      className: 'AlbumView'
    });
    this.upload = new UploadView({
      el: this.uploadEl,
      className: 'UploadView'
    });
    this.grid = new GridView({
      el: this.gridEl,
      className: 'GridView'
    });
    this.albumsShowView = new AlbumsShowView({
      el: this.albumsShowEl,
      toolbar: 'Gallery',
      className: 'AlbumsShowView'
    });
    this.albumsEditView = new AlbumsEditView({
      el: this.albumsEditEl,
      className: 'AlbumsEditView'
    });
    this.loginView = new LoginView({
      el: this.loginEl,
      className: 'LoginView'
    });
    this.vmanager = new Spine.Manager(this.sidebar);
    this.vmanager.initDrag(this.vDrag, {
      initSize: __bind(function() {
        return this.sidebar.el.width();
      }, this),
      disabled: false,
      axis: 'x',
      min: function() {
        return 8;
      },
      tol: function() {
        return 20;
      },
      max: __bind(function() {
        return this.el.width() / 2;
      }, this),
      goSleep: __bind(function() {
        return this.sidebar.inner.hide();
      }, this),
      awake: __bind(function() {
        return this.sidebar.inner.show();
      }, this)
    });
    this.hmanager = new Spine.Manager(this.gallery, this.album, this.upload, this.grid);
    this.hmanager.initDrag(this.hDrag, {
      initSize: __bind(function() {
        return this.el.height() / 3;
      }, this),
      disabled: false,
      axis: 'y',
      min: function() {
        return 20;
      },
      max: __bind(function() {
        return this.el.height() / 3;
      }, this),
      goSleep: __bind(function() {
        var _ref;
        return (_ref = this.albumsShowView.activeControl) != null ? _ref.click() : void 0;
      }, this)
    });
    this.albumsManager = new Spine.Manager(this.albumsShowView, this.albumsEditView);
  }
  App.prototype.userconfirmation = function(user, json) {
    console.log('Server ping has finished');
    if (user.sessionid !== json.User.sessionid) {
      alert('Invalid Session, Please login again');
      User.shred();
      return window.location = base_url + 'users/login';
    }
  };
  return App;
})();
$(function() {
  window.App = new App({
    el: $('body')
  });
  User.ping();
  App.loginView.render(User.first());
  App.albumsManager.change(App.albumsShowView);
  if (!Gallery.count()) {
    return App.openPanel('gallery', App.albumsShowView.btnGallery);
  }
});