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
    this.change = __bind(this.change, this);    List.__super__.constructor.apply(this, arguments);
    this.bind("change", this.change);
    Contact.bind("change", this.proxy(this.change));
  }
  List.prototype.template = function() {
    return arguments[0];
  };
  List.prototype.change = function(item, mode) {
    if (item && !item.destroyed) {
      this.current = item;
      this.children().removeClass("active");
      this.children().forItem(this.current).addClass("active");
      return Spine.trigger('change', item, mode);
    }
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
    return this.change(item, 'show');
  };
  List.prototype.edit = function(e) {
    var item;
    item = $(e.target).item();
    return this.change(item, 'edit');
  };
  return List;
})();
if (typeof module !== "undefined" && module !== null) {
  module.exports = Spine.List;
}