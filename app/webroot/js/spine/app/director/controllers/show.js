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
  ShowView.extend(Spine.Controller.Toolbars);
  ShowView.prototype.elements = {
    '#views .views': 'views',
    '.galleriesHeader': 'galleriesHeaderEl',
    '.albumsHeader': 'albumsHeaderEl',
    '.photosHeader': 'photosHeaderEl',
    '.photoHeader': 'photoHeaderEl',
    '.header': 'albumHeader',
    '.optOverview': 'btnOverview',
    '.optEditGallery': 'btnEditGallery',
    '.optGallery': 'btnGallery',
    '.optAlbum': 'btnAlbum',
    '.optPhoto': 'btnPhoto',
    '.optUpload': 'btnUpload',
    '.optSlideshow': 'btnSlideshow',
    '.toolbar': 'toolBar',
    '.galleries': 'galleriesEl',
    '.albums': 'albumsEl',
    '.photos': 'photosEl',
    '.photo': 'photoEl',
    '#slider': 'slider'
  };
  ShowView.prototype.events = {
    "click .optOverview": "showOverview",
    "click .optCreatePhoto": "createPhoto",
    "click .optDestroyPhoto": "destroyPhoto",
    "click .optShowPhotos": "showPhotos",
    "click .optCreateAlbum": "createAlbum",
    "click .optShowAllAlbums": "showAllAlbums",
    "click .optDestroyAlbum": "destroyAlbum",
    "click .optEditGallery": "editGallery",
    "click .optCreateGallery": "createGallery",
    "click .optDestroyGallery": "destroyGallery",
    "click .optEmail": "email",
    "click .optGallery": "toggleGallery",
    "click .optAlbum": "toggleAlbum",
    "click .optPhoto": "togglePhoto",
    "click .optUpload": "toggleUpload",
    "click .optSlideshow": "toggleSlideshow",
    "click .optThumbsize": "showSlider",
    'dblclick .draghandle': 'toggleDraghandle',
    'click .items': "deselect",
    'fileuploadprogress': "uploadProgress",
    'fileuploaddone': "uploadDone",
    'slide #slider': 'sliderSlide',
    'slidestop #slider': 'sliderStop',
    'slidestart #slider': 'sliderStart'
  };
  ShowView.prototype.toolsTemplate = function(items) {
    return $("#toolsTemplate").tmpl(items);
  };
  function ShowView() {
    this.sliderStop = __bind(this.sliderStop, this);
    this.sliderSlide = __bind(this.sliderSlide, this);
    this.sliderStart = __bind(this.sliderStart, this);
    this.showSlider = __bind(this.showSlider, this);
    this.deselect = __bind(this.deselect, this);    ShowView.__super__.constructor.apply(this, arguments);
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
    Spine.bind('change:canvas', this.proxy(this.changeCanvas));
    Gallery.bind('change', this.proxy(this.renderToolbar));
    Album.bind('change', this.proxy(this.renderToolbar));
    Photo.bind('change', this.proxy(this.renderToolbar));
    this.bind('change:toolbar', this.proxy(this.changeToolbar));
    this.bind('render:toolbar', this.proxy(this.renderToolbar));
    this.bind("toggle:view", this.proxy(this.toggleView));
    this.current = this.albumsView;
    this.sOutValue = 110;
    if (this.activeControl) {
      this.initControl(this.activeControl);
    } else {
      throw 'need initial control';
    }
    this.edit = this.editGallery;
    this.canvasManager = new Spine.Manager(this.galleriesView, this.albumsView, this.photosView, this.photoView);
    this.canvasManager.change(this.current);
    this.headerManager = new Spine.Manager(this.galleriesHeader, this.albumsHeader, this.photosHeader, this.photoHeader);
    this.headerManager.change(this.albumsHeader);
  }
  ShowView.prototype.changeCanvas = function(controller) {
    console.log('ShowView::changeCanvas');
    this.current = controller;
    this.el.data({
      current: this.current.el.data()
    });
    this.canvasManager.change(controller);
    return this.headerManager.change(controller.header);
  };
  ShowView.prototype.renderToolbar = function() {
    console.log('ShowView::renderToolbar');
    this.toolBar.html(this.toolsTemplate(this.currentToolbar));
    return this.refreshElements();
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
    if ($(e.currentTarget).hasClass('disabled')) {
      return;
    }
    return Spine.trigger('show:albums');
  };
  ShowView.prototype.showAllAlbums = function() {
    return Spine.trigger('show:allAlbums');
  };
  ShowView.prototype.showPhotos = function(e) {
    if ($(e.currentTarget).hasClass('disabled')) {
      return;
    }
    return Spine.trigger('show:photos');
  };
  ShowView.prototype.createGallery = function(e) {
    if ($(e.currentTarget).hasClass('disabled')) {
      return;
    }
    return Spine.trigger('create:gallery');
  };
  ShowView.prototype.createPhoto = function(e) {
    if ($(e.currentTarget).hasClass('disabled')) {
      return;
    }
    return Spine.trigger('create:photo');
  };
  ShowView.prototype.createAlbum = function(e) {
    if ($(e.currentTarget).hasClass('disabled')) {
      return;
    }
    return Spine.trigger('create:album');
  };
  ShowView.prototype.editGallery = function(e) {
    if ($(e.currentTarget).hasClass('disabled')) {
      return;
    }
    return Spine.trigger('edit:gallery');
  };
  ShowView.prototype.editAlbum = function(e) {
    if ($(e.currentTarget).hasClass('disabled')) {
      return;
    }
    return Spine.trigger('edit:album');
  };
  ShowView.prototype.destroyGallery = function(e) {
    if ($(e.currentTarget).hasClass('disabled')) {
      return;
    }
    return Spine.trigger('destroy:gallery');
  };
  ShowView.prototype.destroyAlbum = function(e) {
    if ($(e.currentTarget).hasClass('disabled')) {
      return;
    }
    return Spine.trigger('destroy:album');
  };
  ShowView.prototype.destroyPhoto = function(e) {
    if ($(e.currentTarget).hasClass('disabled')) {
      return;
    }
    return Spine.trigger('destroy:photo');
  };
  ShowView.prototype.showOverview = function(e) {
    return Spine.trigger('show:overview');
  };
  ShowView.prototype.animateView = function() {
    var hasActive, height;
    hasActive = function() {
      if (App.hmanager.hasActive()) {
        return App.hmanager.enableDrag();
      }
      return App.hmanager.disableDrag();
    };
    height = function() {
      App.hmanager.currentDim;
      if (hasActive()) {
        return parseInt(App.hmanager.currentDim) + "px";
      } else {
        return "8px";
      }
    };
    return this.views.animate({
      height: height()
    }, 400);
  };
  ShowView.prototype.toggleGallery = function(e) {
    this.changeToolbar(Gallery);
    return this.trigger("toggle:view", App.gallery, e.target);
  };
  ShowView.prototype.toggleAlbum = function(e) {
    this.changeToolbar(Album);
    return this.trigger("toggle:view", App.album, e.target);
  };
  ShowView.prototype.togglePhoto = function(e) {
    this.changeToolbar(Photo);
    return this.trigger("toggle:view", App.photo, e.target);
  };
  ShowView.prototype.toggleUpload = function(e) {
    this.changeToolbar('Upload');
    return this.trigger("toggle:view", App.upload, e.target);
  };
  ShowView.prototype.toggleSlideshow = function(e) {
    this.changeToolbar('Slideshow');
    return this.trigger("toggle:view", App.slideshow, e.target);
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
    this.renderViewControl(controller, control);
    return this.animateView();
  };
  ShowView.prototype.toggleDraghandle = function() {
    return this.activeControl.click();
  };
  ShowView.prototype.initControl = function(control) {
    if (Object.prototype.toString.call(control) === "[object String]") {
      return this.activeControl = this[control];
    } else {
      return this.activeControl = control;
    }
  };
  ShowView.prototype.deselect = function(e) {
    var item;
    item = this.el.data().current;
    console.log(this.el.data());
    switch (item.constructor.className) {
      case 'Photo':
        (function() {});
        break;
      case 'Album':
        Spine.Model['Album'].emptySelection();
        Photo.current();
        Spine.trigger('photo:exposeSelection');
        Spine.trigger('change:selectedPhoto', item);
        break;
      case 'Gallery':
        Spine.Model['Gallery'].emptySelection();
        Album.current();
        Spine.trigger('album:exposeSelection');
        Spine.trigger('change:selectedAlbum', item);
        break;
      default:
        Gallery.current();
        Spine.trigger('gallery:exposeSelection');
        Spine.trigger('change:selectedGallery', false);
    }
    this.trigger('render:toolbar');
    this.current.items.deselect();
    this.renderToolbar();
    e.stopPropagation();
    e.preventDefault();
    return false;
  };
  ShowView.prototype.uploadProgress = function(e, coll) {
    return console.log(coll);
  };
  ShowView.prototype.uploadDone = function(e, coll) {
    return console.log(coll);
  };
  ShowView.prototype.sliderInValue = function(val) {
    val = val || this.sOutValue;
    return this.sInValue = (val / 2) - 20;
  };
  ShowView.prototype.sliderOutValue = function() {
    var val;
    val = this.slider.slider('value');
    return this.sOutValue = (val + 20) * 2;
  };
  ShowView.prototype.initSlider = function() {
    var inValue;
    inValue = this.sliderInValue();
    return this.slider.slider({
      orientation: 'horizonatal',
      value: inValue
    });
  };
  ShowView.prototype.showSlider = function() {
    this.initSlider();
    this.sliderOutValue();
    return this.sliderInValue();
  };
  ShowView.prototype.sliderStart = function() {
    return this.photosView.list.sliderStart();
  };
  ShowView.prototype.sliderSlide = function() {
    return this.photosView.list.size(this.sliderOutValue());
  };
  ShowView.prototype.sliderStop = function() {};
  return ShowView;
})();