var $, ModalView;
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
ModalView = (function() {
  __extends(ModalView, Spine.Controller);
  ModalView.prototype.elements = {
    '.modal-header': 'header',
    '.modal-body': 'body',
    '.modal-footer': 'footer'
  };
  ModalView.prototype.events = {
    'click .btnClose': 'close'
  };
  ModalView.prototype.template = function(item) {
    return $('#modalTemplate').tmpl(item);
  };
  function ModalView() {
    ModalView.__super__.constructor.apply(this, arguments);
    this.el.modal({
      show: false
    });
    this.defaults = {
      header: 'Default Header Text',
      body: 'Default Body Text',
      footer: 'Default Footer Text'
    };
  }
  ModalView.prototype.render = function() {
    console.log('ModalView::render');
    this.html(this.template(this.options));
    return this.el;
  };
  ModalView.prototype.show = function(options) {
    var el;
    this.options = $.extend(this.defaults, options);
    return el = this.render().modal('show');
  };
  ModalView.prototype.close = function(e) {
    return this.el.modal('hide');
  };
  return ModalView;
})();
if (typeof module !== "undefined" && module !== null) {
  module.exports = ModalView;
}
