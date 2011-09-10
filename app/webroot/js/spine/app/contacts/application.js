var App;
var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
App = (function() {
  __extends(App, Spine.Controller);
  App.prototype.elements = {
    '#sidebar': 'sidebarEl',
    '#contacts': 'contactsEl',
    '#album': 'albumEl',
    '#upload': 'uploadEl',
    '#grid': 'gridEl',
    '.vdraggable': 'vDrag',
    '.hdraggable': 'hDrag'
  };
  function App() {
    App.__super__.constructor.apply(this, arguments);
    this.sidebar = new Sidebar({
      el: this.sidebarEl
    });
    this.contacts = new Contacts({
      el: this.contactsEl
    });
    this.album = new Album({
      el: this.albumEl
    });
    this.upload = new Upload({
      el: this.uploadEl
    });
    this.grid = new Grid({
      el: this.gridEl
    });
    this.vmanager = new Spine.Manager(this.sidebar);
    this.vmanager.startDrag(this.vDrag, {
      initSize: this.proxy(function() {
        return $(this.sidebar.el).width() / 2;
      }),
      disabled: false,
      axis: 'x',
      min: 250,
      max: this.proxy(function() {
        return $(this.el).width() / 2;
      })
    });
    this.hmanager = new Spine.Manager(this.album, this.upload, this.album, this.grid);
    this.hmanager.startDrag(this.hDrag, {
      initSize: this.proxy(function() {
        return $(this.contacts.el).height() / 2;
      }),
      disabled: true,
      axis: 'y',
      min: 0,
      max: this.proxy(function() {
        return this.contacts.el.height() / 2;
      })
    });
    Contact.fetch();
  }
  return App;
})();
$(function() {
  return window.App = new App({
    el: $('body')
  });
});