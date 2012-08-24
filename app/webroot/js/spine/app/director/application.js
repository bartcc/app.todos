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
  App.extend(Spine.Controller.Drag);
  App.prototype.elements = {
    '#fileupload': 'uploader',
    '#modal-gallery': 'modalGallery',
    '#flickr': 'flickrEl',
    '#main': 'mainEl',
    '#sidebar': 'sidebarEl',
    '.show': 'showEl',
    '.overview': 'overviewEl',
    '#content .edit': 'galleryEditEl',
    '#ga': 'galleryEl',
    '#al': 'albumEl',
    '#ph': 'photoEl',
    '#fu': 'uploadEl',
    '#loader': 'loaderEl',
    '#login': 'loginEl',
    '#modal-gallery': 'slideshowEl',
    '#modal-view': 'modalEl',
    '.vdraggable': 'vDrag',
    '.hdraggable': 'hDrag',
    '.show .content': 'content',
    '.status-symbol img': 'statusIcon',
    '.status-text': 'statusText',
    '.status-symbol': 'statusSymbol'
  };
  App.prototype.events = {
    'keypress': 'keys',
    'drop': 'drop',
    'dragenter': 'dragenter'
  };
  function App() {
    App.__super__.constructor.apply(this, arguments);
    User.bind('pinger', this.proxy(this.validate));
    this.loadToolbars();
    this.modalView = new ModalView({
      el: this.modalEl,
      className: 'modal'
    });
    this.galleryEditView = new GalleryEditorView({
      el: this.galleryEditEl
    });
    this.gallery = new GalleryEditView({
      el: this.galleryEl,
      externalUI: '.optGallery'
    });
    this.album = new AlbumEditView({
      el: this.albumEl,
      externalUI: '.optAlbum'
    });
    this.photo = new PhotoEditView({
      el: this.photoEl,
      externalUI: '.optPhoto'
    });
    this.upload = new UploadEditView({
      el: this.uploadEl,
      externalUI: '.optUpload'
    });
    this.showView = new ShowView({
      el: this.showEl,
      activeControl: 'btnGallery',
      modalView: this.modalView,
      uploader: this.upload
    });
    this.overviewView = new OverviewView({
      el: this.overviewEl
    });
    this.sidebar = new Sidebar({
      el: this.sidebarEl
    });
    this.flickr = new SidebarFlickr({
      el: this.flickrEl
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
    this.hmanager = new Spine.Manager(this.gallery, this.album, this.photo, this.upload);
    this.hmanager.external = this.showView.toolbarOne;
    this.hmanager.initDrag(this.hDrag, {
      initSize: __bind(function() {
        return this.el.height() / 2;
      }, this),
      disabled: false,
      axis: 'y',
      min: function() {
        return 90;
      },
      max: __bind(function() {
        return this.el.height() / 2;
      }, this),
      goSleep: __bind(function() {}, this),
      awake: __bind(function() {}, this)
    });
    this.appManager = new Spine.Manager(this.mainView, this.loaderView);
    this.appManager.change(this.loaderView);
    this.contentManager = new Spine.Manager(this.galleryEditView, this.overviewView, this.showView);
    this.contentManager.change(this.showView);
    this.initializeFileupload();
    this.slideshow = this.initializeSlideshow();
    this.routes({
      '/gallery/:gid/:aid/:pid': function(params) {
        var photo;
        this.contentManager.change(this.showView);
        photo = Photo.exists(params.pid);
        Spine.trigger('show:photo', photo);
        Gallery.current(params.gid);
        return Album.current(params.aid);
      },
      '/gallery/:gid/:aid': function(params) {
        this.contentManager.change(this.showView);
        Spine.trigger('show:photos');
        Gallery.current(params.gid);
        return Album.current(params.aid);
      },
      '/gallery/:id': function(params) {
        this.contentManager.change(this.showView);
        Spine.trigger('change:toolbar', ['Gallery']);
        return Spine.trigger('gallery:activate', params.id);
      },
      '/galleries/': function() {
        this.contentManager.change(this.showView);
        return Spine.trigger('show:galleries');
      },
      '/albums/': function() {
        this.contentManager.change(this.showView);
        return this.showView.albumsView.trigger('show:allAlbums');
      },
      '/photos/': function() {
        this.contentManager.change(this.showView);
        Spine.trigger('show:photos');
        return Album.current();
      },
      '/overview/': function() {
        return Spine.trigger('show:overview', true);
      },
      '/slideshow/:id': function() {
        this.contentManager.change(this.showView);
        return Spine.trigger('show:slideshow');
      }
    });
  }
  App.prototype.validate = function(user, json) {
    var valid;
    console.log('Pinger done');
    valid = user.sessionid === json.sessionid;
    valid = user.id === json.id && valid;
    if (!valid) {
      return User.logout();
    } else {
      this.old_statusIcon = this.statusIcon[0].src;
      this.statusIcon[0].src = '/img/validated.png';
      this.statusText.text('Verifying Account');
      return this.delay(this.setupView, 300);
    }
  };
  App.prototype.drop = function(e) {
    var event, _ref, _ref2, _ref3;
    console.log('App::drop');
    event = e.originalEvent;
    if ((_ref = Spine.dragItem) != null) {
      if ((_ref2 = _ref.closest) != null) {
        _ref2.removeClass('over nodrop');
      }
    }
    if ((_ref3 = Spine.sortItem) != null) {
      _ref3.splitter.remove();
    }
    if (!event.dataTransfer.files.length) {
      e.stopPropagation();
    }
    return e.preventDefault();
  };
  App.prototype.setupView = function() {
    Spine.unbind('uri:alldone');
    this.statusIcon[0].src = '/img/validated.png';
    this.statusText.hide();
    return this.statusText.text('Welcome').fadeIn('slow', __bind(function() {
      return this.delay(this.finalizeView, 300);
    }, this));
  };
  App.prototype.finalizeView = function() {
    this.appManager.change(this.mainView);
    return this.loginView.render(User.first());
  };
  App.prototype.initializeSlideshow = function() {
    var options;
    options = {
      show: false,
      canvas: true,
      backdrop: true,
      slideshow: 1000,
      autostart: false,
      toggleAutostart: function() {
        return console.log(this.autostart = !this.autostart);
      }
    };
    return $('#modal-gallery').modal(options).data('modal');
  };
  App.prototype.initializeFileupload = function() {
    return this.uploader.fileupload({
      autoUpload: true,
      singleFileUploads: true
    });
  };
  App.prototype.loadToolbars = function() {
    return Toolbar.load();
  };
  App.prototype.keys = function(e) {
    var charCode, keyCode;
    charCode = e.charCode;
    keyCode = e.keyCode;
    switch (charCode) {
      case 97:
        if (e.metaKey || e.ctrlKey) {
          this.showView.selectAll();
          e.preventDefault();
        }
        break;
      case 32:
        this.showView.slideshowView.toggle();
        e.preventDefault();
    }
    switch (keyCode) {
      case 9:
        this.sidebar.toggleDraghandle();
        return e.preventDefault();
      case 27:
        this.showView.btnPrevious.click();
        return e.preventDefault();
      case 13:
        return this.modalView.close();
    }
  };
  return App;
})();
$(function() {
  User.ping();
  window.App = new App({
    el: $('body')
  });
  Spine.Route.setup();
  return App.navigate(location.hash);
});
