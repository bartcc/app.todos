var $, AlbumsView;
var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; }, __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
if (typeof Spine !== "undefined" && Spine !== null) {
  Spine;
} else {
  Spine = require("spine");
};
$ = Spine.$;
AlbumsView = (function() {
  __extends(AlbumsView, Spine.Controller);
  AlbumsView.prototype.elements = {
    ".show": "showEl",
    ".edit": "editEl",
    ".show .content": "showContent",
    ".edit .content": "editContent",
    ".views": "views",
    ".draggable": "draggable",
    '.showGallery': 'galleryBtn',
    '.showAlbum': 'albumBtn',
    '.showUpload': 'uploadBtn',
    '.showGrid': 'gridBtn',
    '.content .items': 'items',
    '.content .editAlbum .item': 'albumEditor',
    '.header': 'header'
  };
  AlbumsView.prototype.events = {
    "click .optEdit": "edit",
    "click .optEmail": "email",
    "click .showGallery": "toggleGallery",
    "click .showAlbum": "toggleAlbum",
    "click .showUpload": "toggleUpload",
    "click .showGrid": "toggleGrid",
    "click .optDestroy": "destroy",
    "click .optSave": "save",
    "keydown": "saveOnEnter",
    'dblclick .draghandle': 'toggleDraghandle'
  };
  AlbumsView.prototype.template = function(items) {
    return $("#albumsTemplate").tmpl(items);
  };
  function AlbumsView() {
    this.saveOnEnter = __bind(this.saveOnEnter, this);    AlbumsView.__super__.constructor.apply(this, arguments);
    this.editEl.hide();
    this.list = new Spine.AlbumList({
      el: this.items,
      template: this.template,
      editor: this.albumEditor
    });
    Album.bind("change", this.proxy(this.render));
    Spine.bind('save:gallery', this.proxy(this.save));
    this.bind('save:gallery', this.proxy(this.save));
    Spine.bind('change:selectedGallery', this.proxy(this.change));
    Gallery.bind("change", this.proxy(this.renderGalleryEditor));
    Gallery.bind("change", this.proxy(this.renderHeader));
    this.bind("toggle:view", this.proxy(this.toggleView));
    this.create = this.edit;
    $(this.views).queue("fx");
  }
  AlbumsView.prototype.loadJoinTables = function() {
    return AlbumsImage.records = Album.joinTableRecords;
  };
  AlbumsView.prototype.change = function(item, mode) {
    console.log('Albums::change');
    if (mode) {
      console.log(mode);
    }
    this.current = item;
    this.render(item);
    return typeof this[mode] === "function" ? this[mode](item) : void 0;
  };
  AlbumsView.prototype.render = function(album) {
    var items, joinedItems, val;
    console.log('Albums::render');
    if (this.current) {
      joinedItems = GalleriesAlbum.filter(this.current.id);
      items = (function() {
        var _i, _len, _results;
        _results = [];
        for (_i = 0, _len = joinedItems.length; _i < _len; _i++) {
          val = joinedItems[_i];
          _results.push(Album.find(val.album_id));
        }
        return _results;
      })();
    } else {
      items = Album.filter();
    }
    this.renderGalleryEditor();
    this.renderHeader();
    return this.list.render(items, album);
  };
  AlbumsView.prototype.renderGalleryEditor = function(item) {
    if (item) {
      this.current = item;
    }
    if (this.current) {
      this.editContent.html($("#editGalleryTemplate").tmpl(this.current));
      this.focusFirstInput(this.editEl);
    } else {
      this.editContent.html($("#noSelectionTemplate").tmpl({
        type: 'Select a Gallery!'
      }));
    }
    return this;
  };
  AlbumsView.prototype.renderHeader = function(item) {
    console.log('Albums::renderHeader');
    if (this.current) {
      return this.header.html('<h2>Albums for Gallery ' + this.current.name + '</h2>');
    } else {
      return this.header.html('<h2>Albums Overview</h2>');
    }
  };
  AlbumsView.prototype.show = function(item) {
    return this.showEl.show(0, this.proxy(function() {
      return this.editEl.hide();
    }));
  };
  AlbumsView.prototype.edit = function(item) {
    return this.editEl.show(0, this.proxy(function() {
      this.showEl.hide();
      return this.focusFirstInput(this.editEl);
    }));
  };
  AlbumsView.prototype.destroy = function() {
    return this.current.destroy();
  };
  AlbumsView.prototype.email = function() {
    if (!this.current.email) {
      return;
    }
    return window.location = "mailto:" + this.current.email;
  };
  AlbumsView.prototype.renderViewControl = function(controller, controlEl) {
    var active;
    active = controller.isActive();
    return $(".options .view").each(function() {
      if (this === controlEl) {
        return $(this).toggleClass("active", active);
      } else {
        return $(this).removeClass("active");
      }
    });
  };
  AlbumsView.prototype.animateView = function() {
    var hasActive, height;
    hasActive = function() {
      if (App.hmanager.hasActive()) {
        return App.hmanager.enableDrag();
      }
      return App.hmanager.disableDrag();
    };
    height = function() {
      if (hasActive()) {
        return parseInt(App.hmanager.currentDim) + "px";
      } else {
        return "7px";
      }
    };
    return $(this.views).animate({
      height: height()
    }, 400);
  };
  AlbumsView.prototype.toggleGallery = function(e) {
    return this.trigger("toggle:view", App.gallery, e.target);
  };
  AlbumsView.prototype.toggleAlbum = function(e) {
    return this.trigger("toggle:view", App.album, e.target);
  };
  AlbumsView.prototype.toggleUpload = function(e) {
    return this.trigger("toggle:view", App.upload, e.target);
  };
  AlbumsView.prototype.toggleGrid = function(e) {
    return this.trigger("toggle:view", App.grid, e.target);
  };
  AlbumsView.prototype.toggleView = function(controller, control) {
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
  AlbumsView.prototype.toggleDraghandle = function() {
    return this.activeControl.click();
  };
  AlbumsView.prototype.save = function(el) {
    var atts;
    console.log('Albums::save');
    console.log(this.current);
    if (this.current) {
      atts = (typeof el.serializeForm === "function" ? el.serializeForm() : void 0) || this.editEl.serializeForm();
      this.current.updateChangedAttributes(atts);
      return this.show();
    }
  };
  AlbumsView.prototype.saveOnEnter = function(e) {
    if (e.keyCode !== 13) {
      return;
    }
    return this.trigger('save:gallery', this.editEl);
  };
  return AlbumsView;
})();
if (typeof module !== "undefined" && module !== null) {
  module.exports = AlbumsView;
}