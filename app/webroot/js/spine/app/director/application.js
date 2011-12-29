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
    '#content .overview': 'overviewEl',
    '#content .show': 'showEl',
    '#content .edit': 'galleryEditEl',
    '#gallery': 'galleryEl',
    '#album': 'albumEl',
    '#fileupload': 'uploadEl',
    '#photo': 'photoEl',
    '#slideshow': 'slideshowEl',
    '#loader': 'loaderEl',
    '#login': 'loginEl',
    '.vdraggable': 'vDrag',
    '.hdraggable': 'hDrag',
    '.show .content': 'content',
    '.status-symbol img': 'icon',
    '.status-text': 'statusText',
    '.status-symbol': 'statusSymbol'
  };
  App.prototype.events = {
    'drop': 'drop'
  };
  function App() {
    App.__super__.constructor.apply(this, arguments);
    User.bind('pinger', this.proxy(this.validate));
    this.galleryEditView = new GalleryEditorView({
      el: this.galleryEditEl
    });
    this.gallery = new GalleryEditView({
      el: this.galleryEl
    });
    this.album = new AlbumEditView({
      el: this.albumEl
    });
    this.photo = new PhotoEditView({
      el: this.photoEl
    });
    this.upload = new UploadEditView({
      el: this.uploadEl
    });
    this.slideshow = new SlideshowEditView({
      el: this.slideshowEl
    });
    this.overviewView = new OverviewView({
      el: this.overviewEl
    });
    this.showView = new ShowView({
      el: this.showEl,
      activeControl: 'btnGallery'
    });
    this.sidebar = new Sidebar({
      el: this.sidebarEl
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
    this.hmanager = new Spine.Manager(this.gallery, this.album, this.photo, this.upload, this.slideshow);
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
    this.contentManager = new Spine.Manager(this.overviewView, this.showView, this.galleryEditView);
    this.contentManager.change(this.showView);
    this.appManager = new Spine.Manager(this.mainView, this.loaderView);
    this.appManager.change(this.loaderView);
    this.initFileupload();
  }
  App.prototype.validate = function(user, json) {
    var cb, valid;
    console.log('Pinger done');
    valid = user.sessionid === json.User.sessionid;
    valid = user.id === json.User.id && valid;
    if (!valid) {
      return User.logout();
    } else {
      this.old_icon = this.icon[0].src;
      this.icon[0].src = '/img/validated.png';
      this.statusText.text('Account verified');
      cb = function() {
        return this.setupView();
      };
      return this.delay(cb, 1000);
    }
  };
  App.prototype.drop = function(e) {
    var _ref;
    if ((_ref = Spine.dragItem) != null ? _ref.closest : void 0) {
      return Spine.dragItem.closest.removeClass('over nodrop');
    }
  };
  App.prototype.setupView = function() {
    var cb;
    Spine.unbind('uri:alldone');
    this.icon[0].src = '/img/validated.png';
    this.statusText.hide();
    cb = function() {
      this.appManager.change(this.mainView);
      if (!Gallery.count()) {
        this.openPanel('gallery', this.showView.btnGallery);
      }
      return this.loginView.render(User.first());
    };
    return this.statusText.text('Thanks for Patience').fadeIn('slow', __bind(function() {
      return this.delay(cb, 1000);
    }, this));
  };
  App.prototype.initFileupload = function() {
    this.uploadEl.fileupload();
    return $.getJSON($('form', this.uploadEl).prop('action'), function(files) {
      var fu;
      fu = uploadEl.data('fileupload');
      fu._adjustMaxNumberOfFiles(-files.length);
      return fu._renderDownload(files).appendTo($('.files', this.uploadEl).fadeIn(function() {
        return $(this).show();
      }));
    });
  };
  return App;
})();
$(function() {
  User.ping();
  return window.App = new App({
    el: $('body')
  });
});