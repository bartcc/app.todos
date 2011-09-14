var Tasks;
var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
Tasks = (function() {
  __extends(Tasks, Spine.Controller);
  Tasks.prototype.tag = 'li';
  Tasks.prototype.events = {
    "change   input[type=checkbox]": "toggle",
    "click    .destroy": "destroy",
    "dblclick .view": "edit",
    "keypress input[type=text]": "blurOnEnter",
    "blur     input[type=text]": "close"
  };
  Tasks.prototype.elements = {
    "input[type=text]": "input",
    ".item": "wrapper"
  };
  function Tasks() {
    Tasks.__super__.constructor.apply(this, arguments);
    this.item.bind("update", this.proxy(this.render));
    this.item.bind("destroy", this.proxy(this.remove));
  }
  Tasks.prototype.render = function() {
    var element, isEqual;
    this.item.reload();
    isEqual = _.isEqual(this.item.savedAttributes, this.item.attributes());
    element = $("#taskTemplate").tmpl(this.item);
    this.el.prop('id', 'todo-' + this.item.id).addClass('hover');
    this.el.html(element).toggleClass('unsaved', !isEqual);
    this.refreshElements();
    return this;
  };
  Tasks.prototype.toggle = function() {
    this.item.done = !this.item.done;
    return this.item.save();
  };
  Tasks.prototype.destroy = function() {
    return this.item.remove();
  };
  Tasks.prototype.edit = function() {
    this.wrapper.addClass("editing");
    return this.input.focus();
  };
  Tasks.prototype.blurOnEnter = function(e) {
    if (e.keyCode === 13) {
      return e.target.blur();
    }
  };
  Tasks.prototype.close = function() {
    this.wrapper.removeClass("editing");
    return this.item.updateAttributes({
      name: this.input.val()
    });
  };
  Tasks.prototype.remove = function() {
    return this.el.remove();
  };
  return Tasks;
})();