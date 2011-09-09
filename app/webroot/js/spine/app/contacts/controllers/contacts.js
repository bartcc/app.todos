var $, Contacts;
var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
$ = jQuery;
Contacts = (function() {
  __extends(Contacts, Spine.Controller);
  Contacts.prototype.elements = {
    ".show": "showEl",
    ".edit": "editEl",
    ".show .content": "showContent",
    ".edit .content": "editContent",
    "#views": "views",
    ".draggable": "draggable"
  };
  Contacts.prototype.events = {
    "click .optEdit": "edit",
    "click .optEmail": "email",
    "click .showAlbum": "toggleAlbum",
    "click .showUpload": "toggleUpload",
    "click .showGrid": "toggleGrid",
    "click .optDestroy": "destroy",
    "click .optSave": "save",
    "keydown": "saveOnEnter"
  };
  function Contacts() {
    Contacts.__super__.constructor.apply(this, arguments);
    this.editEl.hide();
    Contact.bind("change", this.proxy(this.change));
    Spine.App.bind("show:contact", this.proxy(this.show));
    Spine.App.bind("edit:contact", this.proxy(this.editContact));
    this.bind("toggle:view", this.proxy(this.toggleView));
    $(this.views).queue("fx");
  }
  Contacts.prototype.change = function(item) {
    if (!item.destroyed) {
      this.current = item;
      return this.render();
    }
  };
  Contacts.prototype.render = function() {
    this.showContent.html($("#contactTemplate").tmpl(this.current));
    return this.editContent.html($("#editContactTemplate").tmpl(this.current));
  };
  Contacts.prototype.show = function(item) {
    if (item) {
      this.change(item);
    }
    this.showEl.show();
    return this.editEl.hide();
  };
  Contacts.prototype.edit = function() {
    return Spine.App.trigger("edit:contact");
  };
  Contacts.prototype.editContact = function() {
    return this.editEl.show(0, this.proxy(function() {
      this.showEl.hide();
      return $('input', this.editEl).first().focus().select();
    }));
  };
  Contacts.prototype.destroy = function() {
    return this.current.destroy();
  };
  Contacts.prototype.email = function() {
    if (!this.current.email) {
      return;
    }
    return window.location = "mailto:" + this.current.email;
  };
  Contacts.prototype.renderViewControl = function(controller, controlEl) {
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
  Contacts.prototype.animateView = function() {
    var asset, hasActive;
    hasActive = function() {
      var controller, _i, _len, _ref;
      _ref = App.hmanager.controllers;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        controller = _ref[_i];
        if (controller.isActive()) {
          App.hmanager.enableDrag();
          return true;
        } else {
          App.hmanager.disableDrag();
          return false;
        }
      }
    };
    asset = function() {
      if (hasActive()) {
        return App.hmanager.currentDim + "px";
      } else {
        return "7px";
      }
    };
    return $(this.views).animate({
      height: asset()
    }, 400);
  };
  Contacts.prototype.toggleAlbum = function(e) {
    return this.trigger("toggle:view", App.album, e.target);
  };
  Contacts.prototype.toggleUpload = function(e) {
    return this.trigger("toggle:view", App.upload, e.target);
  };
  Contacts.prototype.toggleGrid = function(e) {
    return this.trigger("toggle:view", App.grid, e.target);
  };
  Contacts.prototype.toggleView = function(controller, control) {
    var isActive;
    isActive = controller.isActive();
    if (isActive) {
      App.hmanager.trigger("change", false);
    } else {
      App.hmanager.trigger("change", controller);
    }
    this.renderViewControl(controller, control);
    return this.animateView();
  };
  Contacts.prototype.save = function() {
    var atts;
    atts = this.editEl.serializeForm();
    this.current.updateChangedAttributes(atts);
    return this.show();
  };
  Contacts.prototype.saveOnEnter = function(e) {
    if (e.keyCode !== 13) {
      return;
    }
    return this.save();
  };
  return Contacts;
})();