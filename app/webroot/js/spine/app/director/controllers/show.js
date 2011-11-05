var ShowView;
var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
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
    '.content.albums': 'albumsEl',
    '.content.images': 'imagesEl',
    '#views .views': 'views',
    '.optEditGallery': 'btnEditGallery',
    '.optGallery': 'btnGallery',
    '.optAlbum': 'btnAlbum',
    '.optPhoto': 'btnPhoto',
    '.optUpload': 'btnUpload',
    '.optGrid': 'btnGrid',
    '.toolbar': 'toolBar'
  };
  ShowView.prototype.events = {
    "click .optPhotos": "showPhotos",
    "click .optAlbums": "showAlbums",
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
    "click .optGrid": "toggleGrid",
    'dblclick .draghandle': 'toggleDraghandle',
    'click .items': "deselect"
  };
  ShowView.prototype.toolsTemplate = function(items) {
    return $("#toolsTemplate").tmpl(items);
  };
  function ShowView() {
    ShowView.__super__.constructor.apply(this, arguments);
    Spine.bind('render:header', this.proxy(this.renderHeader));
    Spine.bind('change:canvas', this.proxy(this.changeCanvas));
    this.bind('change:toolbar', this.proxy(this.changeToolbar));
    this.bind('render:toolbar', this.proxy(this.renderToolbar));
    this.bind("toggle:view", this.proxy(this.toggleView));
    if (this.activeControl) {
      this.initControl(this.activeControl);
    } else {
      throw 'need initial control';
    }
    this.edit = this.editGallery;
  }
  ShowView.prototype.changeCanvas = function(controller) {
    App.canvasManager.trigger('change', controller);
    return this.current = controller;
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
    Gallery.record = false;
    return Spine.trigger('change:selectedGallery', false);
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
    console.log(e);
    if ($(e.currentTarget).hasClass('disabled')) {
      return;
    }
    return Spine.trigger('create:album');
  };
  ShowView.prototype.editGallery = function(e) {
    if ($(e.currentTarget).hasClass('disabled')) {
      return;
    }
    App.galleryEditView.render();
    return App.contentManager.change(App.galleryEditView);
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
  ShowView.prototype.toggleGrid = function(e) {
    this.changeToolbar('Grid');
    return this.trigger("toggle:view", App.grid, e.target);
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
    item = $(e.currentTarget).item();
    if (item != null) {
      item.emptySelection();
    }
    $('.item', this.current.el).removeClass('active');
    console.log(item);
    if (item instanceof Gallery) {
      Spine.trigger('expose:sublistSelection', Gallery.record);
    }
    e.stopPropagation();
    e.preventDefault();
    return false;
  };
  return ShowView;
})();