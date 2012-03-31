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
  ToolbarView.prototype.template = function(items) {
    return $('#toolsTemplate').tmpl(items);
  };
  function ToolbarView(instance) {
    ToolbarView.__super__.constructor.apply(this, arguments);
    this.current = [];
  }
  ToolbarView.prototype.change = function(list) {
    var content, itm, tools, _i, _len;
    if (list == null) {
      list = [];
    }
    if (list.length) {
      tools = Toolbar.filter(list);
      content = new Array;
      for (_i = 0, _len = tools.length; _i < _len; _i++) {
        itm = tools[_i];
        $.merge(content, itm.content);
      }
      this.current = content;
      if ((function() {
        var _j, _len2, _results;
        _results = [];
        for (_j = 0, _len2 = list.length; _j < _len2; _j++) {
          itm = list[_j];
          _results.push(typeof itm === 'function');
        }
        return _results;
      })()) {
        this.current.cb = itm;
      }
    }
    return this.render();
  };
  ToolbarView.prototype.filterTools = function(list) {
    return Toolbar.select(list);
  };
  ToolbarView.prototype.sort = function(a, b) {};
  ToolbarView.prototype.refresh = function() {
    return this.render();
  };
  ToolbarView.prototype.lock = function() {
    return this.locked = true;
  };
  ToolbarView.prototype.unlock = function() {
    return this.locked = false;
  };
  ToolbarView.prototype.clear = function() {
    this.current = [];
    return this.render();
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
