var ShowView;
var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; }, __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
ShowView = (function() {
  __extends(ShowView, Spine.Controller);
  ShowView.prototype.elements = {
    '#views .views': 'views',
    '.galleriesHeader': 'galleriesHeaderEl',
    '.albumsHeader': 'albumsHeaderEl',
    '.photosHeader': 'photosHeaderEl',
    '.photoHeader': 'photoHeaderEl',
    '.header': 'albumHeader',
    '.optOverview': 'btnOverview',
    '.optEditGallery': 'btnEditGallery',
    '.optGallery .ui-icon': 'btnGallery',
    '.optAlbum .ui-icon': 'btnAlbum',
    '.optPhoto .ui-icon': 'btnPhoto',
    '.optUpload .ui-icon': 'btnUpload',
    '.optQuickUpload': 'btnQuickUpload',
    '.optFullScreen': 'btnFullScreen',
    '.optSlideshow': 'btnSlideshow',
    '.toolbarOne': 'toolbarOneEl',
    '.toolbarTwo': 'toolbarTwoEl',
    '.props': 'propsEl',
    '.galleries': 'galleriesEl',
    '.albums': 'albumsEl',
    '.photos': 'photosEl',
    '.photo': 'photoEl',
    '.slideshow': 'slideshowEl',
    '.slider': 'slider',
    '.close': 'btnClose'
  };
  ShowView.prototype.events = {
    "click .optQuickUpload": "toggleQuickUpload",
    "click .optOverview": "showOverview",
    "click .optPrevious": "showPrevious",
    "click .optSlideshow": "showSlideshow",
    "click .optFullScreen": "toggleFullScreen",
    "click .optPlay": "play",
    "click .optCreatePhoto": "createPhoto",
    "click .optDestroyPhoto": "destroyPhoto",
    "click .optShowPhotos": "showPhotos",
    "click .optCreateAlbum": "createAlbum",
    "click .optShowAllAlbums": "showAllAlbums",
    "click .optDestroyAlbum": "destroyAlbum",
    "click .optEditGallery": "editGallery",
    "click .optCreateGallery": "createGallery",
    "click .optDestroyGallery": "destroyGallery",
    "click .optGallery": "toggleGalleryShow",
    "click .optAlbum": "toggleAlbumShow",
    "click .optPhoto": "togglePhotoShow",
    "click .optUpload": "toggleUploadShow",
    'click .optAllGalleries': 'allGalleries',
    'click .optAllAlbums': 'allAlbums',
    'click .optAllPhotos': 'allPhotos',
    'click .optSelectAll': 'selectAll',
    "click .optClose": "toggleDraghandle",
    'dblclick .draghandle': 'toggleDraghandle',
    'click .items': "deselect",
    'slidestop .slider': 'sliderStop',
    'slidestart .slider': 'sliderStart'
  };
  ShowView.prototype.toolsTemplate = function(items) {
    return $("#toolsTemplate").tmpl(items);
  };
  function ShowView() {
    this.sliderStop = __bind(this.sliderStop, this);
    this.sliderSlide = __bind(this.sliderSlide, this);
    this.sliderStart = __bind(this.sliderStart, this);
    this.initSlider = __bind(this.initSlider, this);
    this.deselect = __bind(this.deselect, this);    ShowView.__super__.constructor.apply(this, arguments);
    this.toolbarOne = new ToolbarView({
      el: this.toolbarOneEl,
      template: this.toolsTemplate
    });
    this.toolbarTwo = new ToolbarView({
      el: this.toolbarTwoEl,
      template: this.toolsTemplate
    });
    this.photoHeader = new PhotoHeader({
      el: this.photoHeaderEl
    });
    this.photosHeader = new PhotosHeader({
      el: this.photosHeaderEl
    });
    this.albumsHeader = new AlbumsHeader({
      el: this.albumsHeaderEl
    });
    this.galleriesHeader = new GalleriesHeader({
      el: this.galleriesHeaderEl
    });
    this.galleriesView = new GalleriesView({
      el: this.galleriesEl,
      className: 'items',
      header: this.galleriesHeader,
      parent: this
    });
    this.albumsView = new AlbumsView({
      el: this.albumsEl,
      className: 'items',
      header: this.albumsHeader,
      parent: this,
      parentModel: 'Gallery'
    });
    this.photosView = new PhotosView({
      el: this.photosEl,
      className: 'items',
      header: this.photosHeader,
      parent: this,
      parentModel: 'Album'
    });
    this.photoView = new PhotoView({
      el: this.photoEl,
      className: 'items',
      header: this.photoHeader,
      parent: this,
      parentModel: 'Photo'
    });
    this.slideshowView = new SlideshowView({
      el: this.slideshowEl,
      className: 'items',
      header: false,
      parent: this,
      parentModel: 'Photo',
      subview: true
    });
    Spine.bind('change:canvas', this.proxy(this.changeCanvas));
    Gallery.bind('change', this.proxy(this.changeToolbarOne));
    Album.bind('change', this.proxy(this.changeToolbarOne));
    Photo.bind('change', this.proxy(this.changeToolbarOne));
    Spine.bind('change:toolbarOne', this.proxy(this.changeToolbarOne));
    Spine.bind('change:toolbarTwo', this.proxy(this.changeToolbarTwo));
    Spine.bind('change:selectedAlbum', this.proxy(this.refreshToolbars));
    this.bind("toggle:view", this.proxy(this.toggleView));
    this.current = this.albumsView;
    this.sOutValue = 74;
    this.thumbSize = 240;
    if (this.activeControl) {
      this.initControl(this.activeControl);
    } else {
      throw 'need initial control';
    }
    this.edit = this.editGallery;
    this.canvasManager = new Spine.Manager(this.galleriesView, this.albumsView, this.photosView, this.photoView, this.slideshowView);
    this.canvasManager.change(this.current);
    this.headerManager = new Spine.Manager(this.galleriesHeader, this.albumsHeader, this.photosHeader, this.photoHeader);
    this.headerManager.change(this.albumsHeader);
    this.defaultToolbarTwo = this.toolbarTwo.change(['Slideshow']);
  }
  ShowView.prototype.changeCanvas = function(controller) {
    console.log('ShowView::changeCanvas');
    if (!this.current.subview) {
      this.previous = this.current;
    }
    this.current = controller;
    this.el.data({
      current: controller.el.data().current.record,
      className: controller.el.data().current.className
    });
    this.canvasManager.change(controller);
    return this.headerManager.change(controller.header);
  };
  ShowView.prototype.renderToolbar_ = function(el) {
    var _ref;
    console.log('ShowView::renderToolbar');
    if ((_ref = this[el]) != null) {
      _ref.html(this.toolsTemplate(this.currentToolbar));
    }
    return this.refreshElements();
  };
  ShowView.prototype.changeToolbarOne = function(list, cb) {
    if (list == null) {
      list = [];
    }
    this.toolbarOne.change(list, cb);
    this.toolbarTwo.refresh();
    return this.refreshElements();
  };
  ShowView.prototype.changeToolbarTwo = function(list, cb) {
    if (list == null) {
      list = [];
    }
    this.toolbarTwo.change(list, cb);
    return this.refreshElements();
  };
  ShowView.prototype.refreshToolbars = function() {
    console.log('ShowView::refreshToolbars');
    this.toolbarOne.change();
    return this.toolbarTwo.change();
  };
  ShowView.prototype.renderViewControl = function(controller, controlEl) {
    var active;
    active = controller.isActive();
    return $(".options .opt").each(function() {
      if (this === controlEl) {
        return $(this).toggleClass("active", active);
      } else {
        return $(this).removeClass("active");
      }
    });
  };
  ShowView.prototype.showGallery = function() {
    return App.contentManager.change(App.showView);
  };
  ShowView.prototype.showAlbums = function(e) {
    App.contentManager.change(App.showView);
    return Spine.trigger('show:albums');
  };
  ShowView.prototype.showAllAlbums = function() {
    return Spine.trigger('show:allAlbums');
  };
  ShowView.prototype.showPhotos = function(e) {
    return Spine.trigger('show:photos');
  };
  ShowView.prototype.showOverview = function(e) {
    return Spine.trigger('show:overview');
  };
  ShowView.prototype.showSlideshow = function() {
    this.changeToolbarOne(['Chromeless']);
    this.changeToolbarTwo(['Slider', 'Back', 'Play'], App.showView.initSlider);
    App.sidebar.toggleDraghandle({
      close: true
    });
    return Spine.trigger('show:slideshow');
  };
  ShowView.prototype.showPrevious = function() {
    this.changeToolbarOne(['Default']);
    this.changeToolbarTwo(['Slideshow']);
    App.sidebar.toggleDraghandle();
    return Spine.trigger('change:canvas', this.previous);
  };
  ShowView.prototype.createGallery = function(e) {
    return Spine.trigger('create:gallery');
  };
  ShowView.prototype.createPhoto = function(e) {
    return Spine.trigger('create:photo');
  };
  ShowView.prototype.createAlbum = function(e) {
    return Spine.trigger('create:album');
  };
  ShowView.prototype.editGallery = function(e) {
    return Spine.trigger('edit:gallery');
  };
  ShowView.prototype.editAlbum = function(e) {
    return Spine.trigger('edit:album');
  };
  ShowView.prototype.destroyGallery = function(e) {
    Spine.trigger('destroy:gallery');
    return this.deselect();
  };
  ShowView.prototype.destroyAlbum = function(e) {
    Spine.trigger('destroy:album');
    return this.deselect();
  };
  ShowView.prototype.destroyPhoto = function(e) {
    Spine.trigger('destroy:photo');
    return this.deselect();
  };
  ShowView.prototype.animateView = function() {
    var hasActive, height;
    hasActive = function() {
      if (App.hmanager.hasActive()) {
        return App.hmanager.enableDrag();
      }
      return false;
    };
    height = function() {
      App.hmanager.currentDim;
      if (hasActive()) {
        return parseInt(App.hmanager.currentDim) + "px";
      } else {
        return "18px";
      }
    };
    return this.views.animate({
      height: height()
    }, 400);
  };
  ShowView.prototype.toggleGalleryShow = function(e) {
    this.trigger("toggle:view", App.gallery, e.target);
    return e.preventDefault();
  };
  ShowView.prototype.toggleGallery = function(e) {
    return this.changeToolbarOne(['Gallery']);
  };
  ShowView.prototype.toggleAlbumShow = function(e) {
    this.trigger("toggle:view", App.album, e.target);
    return e.preventDefault();
  };
  ShowView.prototype.toggleAlbum = function(e) {
    return this.changeToolbarOne(['Album']);
  };
  ShowView.prototype.togglePhotoShow = function(e) {
    this.trigger("toggle:view", App.photo, e.target);
    return e.preventDefault();
  };
  ShowView.prototype.togglePhoto = function(e) {
    return this.changeToolbarOne(['Photos', 'Slider'], App.showView.initSlider);
  };
  ShowView.prototype.toggleUploadShow = function(e) {
    this.trigger("toggle:view", App.upload, e.target);
    return e.preventDefault();
  };
  ShowView.prototype.toggleUpload = function(e) {
    return this.changeToolbarOne(['Upload']);
  };
  ShowView.prototype.toggleFullScreen = function() {
    this.slideshowView.toggleFullScreen();
    return this.toolbarTwo.change();
  };
  ShowView.prototype.toggleSlideshow = function() {
    var active;
    active = this.btnSlideshow.toggleClass('active').hasClass('active');
    return this.slideshowView.slideshowMode(active);
  };
  ShowView.prototype.toggleView = function(controller, control) {
    var isActive;
    isActive = controller.isActive();
    if (isActive) {
      App.hmanager.trigger("change", false);
    } else {
      this.activeControl = $(control);
      App.hmanager.trigger("change", controller);
    }
    this.propsEl.find('.ui-icon').removeClass('ui-icon-carat-1-s');
    $(control).toggleClass('ui-icon-carat-1-s', !isActive);
    this.renderViewControl(controller, control);
    return this.animateView();
  };
  ShowView.prototype.toggleDraghandle = function() {
    return this.activeControl.click();
  };
  ShowView.prototype.toggleQuickUpload = function() {
    var active;
    this.refreshElements();
    active = this.btnQuickUpload.find('i').toggleClass('icon-ok icon-').hasClass('icon-ok');
    this.quickUpload(active);
    return active;
  };
  ShowView.prototype.quickUpload = function(active) {
    return App.uploader.fileupload('option', {
      autoUpload: active
    });
  };
  ShowView.prototype.isQuickUpload = function() {
    return this.btnQuickUpload.find('i').hasClass('icon-ok');
  };
  ShowView.prototype.play = function() {
    return Spine.trigger('play:slideshow');
  };
  ShowView.prototype.initControl = function(control) {
    if (Object.prototype.toString.call(control) === "[object String]") {
      return this.activeControl = this[control];
    } else {
      return this.activeControl = control;
    }
  };
  ShowView.prototype.deselect = function(e) {
    var className, item;
    item = this.el.data().current;
    className = this.el.data().className;
    switch (className) {
      case 'Photo':
        (function() {});
        break;
      case 'Album':
        Spine.Model['Album'].emptySelection();
        Spine.trigger('photo:activate');
        break;
      case 'Gallery':
        Spine.Model['Gallery'].emptySelection();
        Spine.trigger('album:activate');
        break;
      case 'Slideshow':
        (function() {});
        break;
      default:
        (function() {});
    }
    this.changeToolbarOne();
    return this.current.items.deselect();
  };
  ShowView.prototype.selectAll = function() {
    var _ref;
    this.current.items.children().each(function(index, el) {
      return $(el).item().addRemoveSelection(true);
    });
    if ((_ref = this.current.list) != null) {
      _ref.activate();
    }
    return this.changeToolbarOne();
  };
  ShowView.prototype.uploadProgress = function(e, coll) {};
  ShowView.prototype.uploadDone = function(e, coll) {};
  ShowView.prototype.sliderInValue = function(val) {
    val = val || this.sOutValue;
    return this.sInValue = (val / 2) - 20;
  };
  ShowView.prototype.sliderOutValue = function(value) {
    var val;
    val = value || this.slider.slider('value');
    return this.sOutValue = (val + 20) * 2;
  };
  ShowView.prototype.initSlider = function() {
    var inValue;
    inValue = this.sliderInValue();
    this.refreshElements();
    return this.slider.slider({
      orientation: 'horizonatal',
      value: inValue,
      slide: __bind(function(e, ui) {
        return this.sliderSlide(ui.value);
      }, this)
    });
  };
  ShowView.prototype.showSlider = function() {
    this.initSlider();
    this.sliderOutValue();
    return this.sliderInValue();
  };
  ShowView.prototype.sliderStart = function() {
    return Spine.trigger('slider:start');
  };
  ShowView.prototype.sliderSlide = function(val) {
    var newVal;
    newVal = this.sliderOutValue(val);
    Spine.trigger('slider:change', newVal);
    return newVal;
  };
  ShowView.prototype.sliderStop = function() {};
  ShowView.prototype.allGalleries = function() {
    return Spine.trigger('show:galleries');
  };
  ShowView.prototype.allAlbums = function() {
    return Spine.trigger('show:allAlbums');
  };
  ShowView.prototype.allPhotos = function() {
    return Spine.trigger('show:allPhotos');
  };
  return ShowView;
})();
