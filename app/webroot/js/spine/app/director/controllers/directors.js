var $, Directors;
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
Directors = (function() {
  __extends(Directors, Spine.Controller);
  Directors.prototype.elements = {
    ".show": "showEl",
    ".edit": "editEl",
    ".show .content": "showContent",
    ".edit .content": "editContent",
    "#views": "views",
    ".draggable": "draggable",
    '.showEditor': 'editorBtn',
    '.showAlbum': 'albumBtn',
    '.showUpload': 'uploadBtn',
    '.showGrid': 'gridBtn'
  };
  Directors.prototype.events = {
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
  function Directors() {
    this.saveOnEnter = __bind(this.saveOnEnter, this);    Directors.__super__.constructor.apply(this, arguments);
    this.editEl.hide();
    Director.bind("change", this.proxy(this.change));
    Spine.App.bind('save', this.proxy(this.save));
    Spine.App.bind("change", this.proxy(this.change));
    this.bind("toggle:view", this.proxy(this.toggleView));
    this.create = this.edit;
    $(this.views).queue("fx");
  }
  Directors.prototype.change = function(item, mode) {
    if (!item.destroyed) {
      this.current = item;
      this.render();
      return typeof this[mode] === "function" ? this[mode](item) : void 0;
    }
  };
  Directors.prototype.render = function() {
    this.showContent.html($("#albumTemplate").tmpl(this.current));
    this.editContent.html($("#editAlbumTemplate").tmpl(this.current));
    this.focusFirstInput(this.editEl);
    return this;
  };
  Directors.prototype.focusFirstInput = function(el) {
    if (!el) {
      return;
    }
    if (el.is(':visible')) {
      $('input', el).first().focus().select();
    }
    return el;
  };
  Directors.prototype.show = function(item) {
    return this.showEl.show(0, this.proxy(function() {
      return this.editEl.hide();
    }));
  };
  Directors.prototype.edit = function(item) {
    return this.editEl.show(0, this.proxy(function() {
      this.showEl.hide();
      return this.focusFirstInput(this.editEl);
    }));
  };
  Directors.prototype.destroy = function() {
    return this.current.destroy();
  };
  Directors.prototype.email = function() {
    if (!this.current.email) {
      return;
    }
    return window.location = "mailto:" + this.current.email;
  };
  Directors.prototype.renderViewControl = function(controller, controlEl) {
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
  Directors.prototype.animateView = function() {
    var hasActive, height;
    hasActive = function() {
      var controller, _i, _len, _ref;
      _ref = App.hmanager.controllers;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        controller = _ref[_i];
        if (controller.isActive()) {
          return App.hmanager.enableDrag();
        }
      }
      return App.hmanager.disableDrag();
    };
    height = function() {
      if (hasActive()) {
        return App.hmanager.currentDim + "px";
      } else {
        return "7px";
      }
    };
    return $(this.views).animate({
      height: height()
    }, 400);
  };
  Directors.prototype.toggleEditor = function(e) {
    return this.trigger("toggle:view", App.editor, e.target);
  };
  Directors.prototype.toggleAlbum = function(e) {
    return this.trigger("toggle:view", App.album, e.target);
  };
  Directors.prototype.toggleUpload = function(e) {
    return this.trigger("toggle:view", App.upload, e.target);
  };
  Directors.prototype.toggleGrid = function(e) {
    return this.trigger("toggle:view", App.grid, e.target);
  };
  Directors.prototype.toggleView = function(controller, control) {
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
  Directors.prototype.toggleDraghandle = function() {
    return this.activeControl.click();
  };
  Directors.prototype.save = function(el) {
    var atts;
    atts = (typeof el.serializeForm === "function" ? el.serializeForm() : void 0) || this.editEl.serializeForm();
    this.current.updateChangedAttributes(atts);
    return this.show();
  };
  Directors.prototype.saveOnEnter = function(e) {
    if (e.keyCode !== 13) {
      return;
    }
    return Spine.App.trigger('save', this.editEl);
  };
  return Directors;
})();
if (typeof module !== "undefined" && module !== null) {
  module.exports = Directors;
}