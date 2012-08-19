var $, OverviewView;
var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; }, __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
if (typeof Spine === "undefined" || Spine === null) {
  Spine = require("spine");
}
$ = Spine.$;
OverviewView = (function() {
  __extends(OverviewView, Spine.Controller);
  OverviewView.prototype.elements = {
    ".items": "items"
  };
  OverviewView.prototype.events = {
    "click .optClose": "close"
  };
  OverviewView.prototype.template = function(items) {
    return $("#overviewTemplate").tmpl(items);
  };
  OverviewView.prototype.toolsTemplate = function(items) {
    return $("#toolsTemplate").tmpl(items);
  };
  function OverviewView() {
    this.callback = __bind(this.callback, this);    OverviewView.__super__.constructor.apply(this, arguments);
    this.el.data({
      current: Recent
    });
    this.maxRecent = 16;
    this.bind('render:toolbar', this.proxy(this.renderToolbar));
    Spine.bind('show:overview', this.proxy(this.show));
    Recent.bind('success:recent', this.proxy(this.render));
    Recent.bind('error:recent', this.proxy(this.error));
  }
  OverviewView.prototype.render = function(items) {
    var item, recents, _i, _len;
    recents = [];
    for (_i = 0, _len = items.length; _i < _len; _i++) {
      item = items[_i];
      recents.push(item['Photo']);
    }
    this.items.html(this.template(recents));
    return this.uri(recents);
  };
  OverviewView.prototype.thumbSize = function(width, height) {
    if (width == null) {
      width = 70;
    }
    if (height == null) {
      height = 70;
    }
    return {
      width: width,
      height: height
    };
  };
  OverviewView.prototype.uri = function(items) {
    console.log('OverviewView::uri');
    return Photo.uri(this.thumbSize(), __bind(function(xhr, record) {
      return this.callback(xhr, items);
    }, this), items);
  };
  OverviewView.prototype.callback = function(json, items) {
    var ele, img, item, jsn, photo, searchJSON, _i, _len, _results;
    console.log('PhotoList::callback');
    searchJSON = function(id) {
      var itm, _i, _len;
      for (_i = 0, _len = json.length; _i < _len; _i++) {
        itm = json[_i];
        if (itm[id]) {
          return itm[id];
        }
      }
    };
    _results = [];
    for (_i = 0, _len = items.length; _i < _len; _i++) {
      item = items[_i];
      photo = item;
      jsn = searchJSON(photo.id);
      ele = this.items.children().forItem(photo, true);
      img = new Image;
      img.element = ele;
      if (jsn) {
        img.src = jsn.src;
      } else {
        img.src = '/img/nophoto.png';
      }
      _results.push(img.onload = this.imageLoad);
    }
    return _results;
  };
  OverviewView.prototype.imageLoad = function() {
    var css;
    css = 'url(' + this.src + ')';
    return $('.thumbnail', this.element).css({
      'backgroundImage': css,
      'backgroundPosition': 'center, center'
    });
  };
  OverviewView.prototype.loadRecent = function() {
    return Recent.check(this.maxRecent);
  };
  OverviewView.prototype.show = function() {
    var controller, _i, _len, _ref;
    _ref = App.contentManager.controllers;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      controller = _ref[_i];
      if (controller.isActive()) {
        this.previous = controller;
      }
    }
    App.contentManager.change(this);
    return this.loadRecent();
  };
  OverviewView.prototype.close = function() {
    return this.navigate('/gallery', Gallery.record.id);
  };
  OverviewView.prototype.error = function(xhr, statusText, error) {
    console.log(xhr);
    return this.record.trigger('ajaxError', xhr, statusText, error);
  };
  return OverviewView;
})();
if (typeof module !== "undefined" && module !== null) {
  module.exports = OverviewView;
}
