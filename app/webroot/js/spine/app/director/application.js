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
    '#main': 'mainEl',
    '#sidebar': 'sidebarEl',
    '#content .show': 'showEl',
    '#content .edit': 'galleryEditEl',
    '.contents .albums': 'albumsEl',
    '.contents .images': 'imagesEl',
    '#gallery': 'galleryEl',
    '#album': 'albumEl',
    '#upload': 'uploadEl',
    '#photo': 'photoEl',
    '#grid': 'gridEl',
    '#loader': 'loaderEl',
    '#login': 'loginEl',
    '.vdraggable': 'vDrag',
    '.hdraggable': 'hDrag',
    '.show .content': 'content',
    '.status-symbol img': 'icon',
    '.status-text': 'statusText',
    '.status-symbol': 'statusSymbol'
  };
  function App() {
    App.__super__.constructor.apply(this, arguments);
    this.ALBUM_SINGLE_MOVE = this.constructor.createImage('/img/dragndrop/album_single_move.png');
    this.ALBUM_SINGLE_COPY = this.constructor.createImage('/img/dragndrop/album_single_copy.png');
    this.ALBUM_DOUBLE_MOVE = this.constructor.createImage('/img/dragndrop/album_double_move.png');
    this.ALBUM_DOUBLE_COPY = this.constructor.createImage('/img/dragndrop/album_double_copy.png');
    User.bind('pinger', this.proxy(this.validate));
    Gallery.bind('refresh', this.proxy(this.setupView));
    this.sidebar = new SidebarView({
      el: this.sidebarEl
    });
    this.gallery = new GalleryView({
      el: this.galleryEl
    });
    this.album = new AlbumView({
      el: this.albumEl
    });
    this.photo = new PhotoView({
      el: this.photoEl
    });
    this.upload = new UploadView({
      el: this.uploadEl
    });
    this.grid = new GridView({
      el: this.gridEl
    });
    this.showView = new ShowView({
      el: this.showEl,
      toolbar: 'ALbum'
    });
    this.albumsView = new AlbumsView({
      el: this.albumsEl,
      toolbar: 'Gallery'
    });
    this.photosView = new PhotosView({
      el: this.imagesEl
    });
    this.galleryEditView = new GalleryEditView({
      el: this.galleryEditEl
    });
    this.loginView = new LoginView({
      el: this.loginEl
    });
    this.mainView = new MainView({
      el: this.mainEl
    });
    this.loaderView = new LoaderView({
      el: this.loaderEl
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
    this.hmanager = new Spine.Manager(this.gallery, this.album, this.photo, this.upload, this.grid);
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
        return (_ref = this.showView.activeControl) != null ? _ref.click() : void 0;
      }, this)
    });
    this.contentManager = new Spine.Manager(this.showView, this.galleryEditView);
    this.contentManager.change(this.albumsView);
    this.canvasManager = new Spine.Manager(this.albumsView, this.photosView);
    this.appManager = new Spine.Manager(this.mainView, this.loaderView);
    this.appManager.change(this.loaderView);
  }
  App.prototype.validate = function(user, json) {
    var cb, valid;
    console.log('Pinger done');
    valid = user.sessionid === json.User.sessionid;
    valid = user.id === json.User.id && valid;
    if (!valid) {
      return User.logout();
    } else {
      this.icon[0].src = '/img/validated.png';
      this.statusText.text('Account verified');
      cb = function() {
        this.appManager.change(this.mainView);
        return this.canvasManager.change(this.albumsView);
      };
      return this.delay(cb, 2000);
    }
  };
  App.prototype.setupView = function() {
    this.contentManager.change(this.showView);
    if (!Gallery.count()) {
      this.openPanel('gallery', this.showView.btnGallery);
    }
    return this.loginView.render(User.first());
  };
  return App;
})();
$(function() {
  User.ping();
  return window.App = new App({
    el: $('body')
  });
});