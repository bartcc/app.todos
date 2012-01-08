var ToolbarView;
var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
ToolbarView = (function() {
  __extends(ToolbarView, Spine.Controller);
  ToolbarView.prototype.template = function() {
    return arguments[0];
  };
  function ToolbarView(instance) {
    ToolbarView.__super__.constructor.apply(this, arguments);
    this.current = [];
  }
  ToolbarView.prototype.change = function(list, cb) {
    var content, itm, tools, _i, _len;
    if (list.length) {
      tools = this.filterTools(list);
      content = new Array;
      for (_i = 0, _len = tools.length; _i < _len; _i++) {
        itm = tools[_i];
        $.merge(content, itm.content);
      }
      this.current = content;
      if (typeof cb === 'function') {
        this.current.cb = cb;
      }
    }
    this.render(this.current);
    return this.current;
  };
  ToolbarView.prototype.filterTools = function(list) {
    return Toolbar.filter(list);
  };
  ToolbarView.prototype.refresh = function(list) {
    if (list == null) {
      list = this.current;
    }
    return this.render(list);
  };
  ToolbarView.prototype.lock = function() {
    return this.locked = true;
  };
  ToolbarView.prototype.unlock = function() {
    return this.locked = false;
  };
  ToolbarView.prototype.clear = function() {
    return this.render([]);
  };
  ToolbarView.prototype.render = function(list) {
    var _ref;
    if (list == null) {
      list = this.current;
    }
    if (this.locked) {
      return;
    }
    this.html(this.template(list));
    return (_ref = this.current) != null ? typeof _ref.cb === "function" ? _ref.cb() : void 0 : void 0;
  };
  return ToolbarView;
})();