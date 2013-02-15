var $, Modal2ButtonView;
var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
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
Modal2ButtonView = (function() {
  __extends(Modal2ButtonView, Spine.Controller);
  Modal2ButtonView.prototype.elements = {
    '.modal-header': 'header',
    '.modal-body': 'body',
    '.modal-footer': 'footer'
  };
  Modal2ButtonView.prototype.events = {
    'click .btnClose': 'close',
    'click .btnYes': 'yes'
  };
  Modal2ButtonView.prototype.template = function(item) {
    return $('#modal2ButtonTemplate').tmpl(item);
  };
  function Modal2ButtonView() {
    Modal2ButtonView.__super__.constructor.apply(this, arguments);
    this.el.modal({
      show: false
    });
    this.defaults = {
      header: 'Default Header Text',
      body: 'Default Body Text',
      footer: 'Default Footer Text'
    };
  }
  Modal2ButtonView.prototype.render = function() {
    console.log('Modal2ButtonView::render');
    this.html(this.template(this.options));
    return this.el;
  };
  Modal2ButtonView.prototype.show = function(options) {
    var el;
    this.options = $.extend(this.defaults, options);
    return el = this.render().modal('show');
  };
  Modal2ButtonView.prototype.yes = function(e) {
    return this.el.modal('hide');
  };
  Modal2ButtonView.prototype.close = function(e) {
    return this.el.modal('hide');
  };
  return Modal2ButtonView;
})();
if (typeof module !== "undefined" && module !== null) {
  module.exports = Modal2ButtonView;
}
