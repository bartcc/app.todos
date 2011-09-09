var $;
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
Spine.List = (function() {
  __extends(List, Spine.Controller);
  List.prototype.events = {
    "click .item": "click",
    "dblclick .item": "edit"
  };
  List.prototype.selectFirst = true;
  function List() {
    this.change = __bind(this.change, this);
    this.test = __bind(this.test, this);    List.__super__.constructor.apply(this, arguments);
    this.bind("change", this.change);
    Contact.bind("create", this.change);
  }
  List.prototype.template = function() {
    return arguments[0];
  };
  List.prototype.test = function(item) {
    return console.log(item);
  };
  List.prototype.change = function(item) {
    if (!item) {
      return;
    }
    this.current = item;
    this.children().removeClass("active");
    return this.children().forItem(this.current).addClass("active");
  };
  List.prototype.render = function(items) {
    if (items) {
      this.items = items;
    }
    this.html(this.template(this.items));
    this.change(this.current);
    if (this.selectFirst) {
      if (!this.children(".active").length) {
        return this.children(":first").click();
      }
    }
  };
  List.prototype.children = function(sel) {
    return this.el.children(sel);
  };
  List.prototype.click = function(e) {
    var item;
    item = $(e.target).item();
    return this.trigger("change", item);
  };
  List.prototype.edit = function(e) {
    var item;
    item = $(e.target).item();
    return Spine.App.trigger('edit:contact', item);
  };
  return List;
})();
if (typeof module !== "undefined" && module !== null) {
  module.exports = Spine.List;
}