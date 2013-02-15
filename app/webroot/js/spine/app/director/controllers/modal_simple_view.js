var $, ModalSimpleView;
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
ModalSimpleView = (function() {
  __extends(ModalSimpleView, Spine.Controller);
  ModalSimpleView.prototype.elements = {
    '.modal-header': 'header',
    '.modal-body': 'body',
    '.modal-footer': 'footer'
  };
  ModalSimpleView.prototype.events = {
    'click .btnClose': 'close'
  };
  ModalSimpleView.prototype.template = function(item) {
    return $('#modalSimpleTemplate').tmpl(item);
  };
  function ModalSimpleView() {
    ModalSimpleView.__super__.constructor.apply(this, arguments);
    this.el.modal({
      show: false
    });
    this.defaults = {
      header: 'Default Header Text',
      body: 'Default Body Text',
      footer: 'Default Footer Text'
    };
  }
  ModalSimpleView.prototype.render = function() {
    console.log('ModalView::render');
    this.html(this.template(this.options));
    return this.el;
  };
  ModalSimpleView.prototype.show = function(options) {
    var el;
    this.options = $.extend(this.defaults, options);
    return el = this.render().modal('show');
  };
  ModalSimpleView.prototype.close = function(e) {
    this.el.modal('hide');
    return App.showView.showPrevious();
  };
  return ModalSimpleView;
})();
if (typeof module !== "undefined" && module !== null) {
  module.exports = ModalSimpleView;
}
