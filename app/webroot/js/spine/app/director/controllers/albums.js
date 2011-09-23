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
    "#views": "views",
    ".draggable": "draggable",
    '.showEditor': 'editorBtn',
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
    "click .showEditor": "toggleEditor",
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
    Spine.App.bind('save:gallery', this.proxy(this.save));
    Spine.App.bind("change:gallery", this.proxy(this.galleryChange));
    this.bind("toggle:view", this.proxy(this.toggleView));
    this.create = this.edit;
    $(this.views).queue("fx");
  }
  AlbumsView.prototype.loadJoinTables = function() {
    return AlbumsImage.records = Album.joinTableRecords;
  };
  AlbumsView.prototype.change = function(item, mode) {
    console.log('Albums::change');
    this.current = item;
    console;
    this.render();
    return typeof this[mode] === "function" ? this[mode](item) : void 0;
  };
  AlbumsView.prototype.galleryChange = function(item, mode) {
    var _ref;
    console.log('Albums::galleryChange');
    if ((item != null ? item.id : void 0) === ((_ref = this.current) != null ? _ref.id : void 0)) {
      return;
    }
    this.current = item;
    this.change(item, mode);
    return Spine.App.trigger('change:album');
  };
  AlbumsView.prototype.render = function() {
    var i, items, itm, joinedItems, val, _ref;
    console.log('Albums::render');
    joinedItems = GalleriesAlbum.filter((_ref = this.current) != null ? _ref.id : void 0);
    items = (function() {
      var _i, _len, _results;
      _results = [];
      for (_i = 0, _len = joinedItems.length; _i < _len; _i++) {
        val = joinedItems[_i];
        _results.push(Album.find(val.album_id));
      }
      return _results;
    })();
    i = 0;
    for (itm in items) {
      i++;
    }
    console.log(i + 'Albums gefiltert');
    if (this.current) {
      this.header.html('<h2>Albums for Gallery ' + this.current.name + '</h2>');
    } else {
      this.header.empty();
    }
    this.list.render(items);
    if (this.current) {
      this.editContent.html($("#editGalleryTemplate").tmpl(this.current));
      this.focusFirstInput(this.editEl);
    }
    return this;
  };
  AlbumsView.prototype.focusFirstInput_ = function(el) {
    if (!el) {
      return;
    }
    if (el.is(':visible')) {
      $('input', el).first().focus().select();
    }
    return el;
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
  AlbumsView.prototype.toggleEditor = function(e) {
    return this.trigger("toggle:view", App.editor, e.target);
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
    atts = (typeof el.serializeForm === "function" ? el.serializeForm() : void 0) || this.editEl.serializeForm();
    this.current.updateChangedAttributes(atts);
    return this.show();
  };
  AlbumsView.prototype.saveOnEnter = function(e) {
    if (e.keyCode !== 13) {
      return;
    }
    return Spine.App.trigger('save:gallery', this.editEl);
  };
  return AlbumsView;
})();
if (typeof module !== "undefined" && module !== null) {
  module.exports = AlbumsView;
}