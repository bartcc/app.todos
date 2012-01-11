var $, GalleriesView;
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
GalleriesView = (function() {
  __extends(GalleriesView, Spine.Controller);
  GalleriesView.extend(Spine.Controller.Drag);
  GalleriesView.prototype.elements = {
    '.items': 'items'
  };
  GalleriesView.prototype.headerTemplate = function(items) {
    return $("#headerGalleryTemplate").tmpl(items);
  };
  GalleriesView.prototype.template = function(items) {
    return $("#galleriesTemplate").tmpl(items);
  };
  function GalleriesView() {
    GalleriesView.__super__.constructor.apply(this, arguments);
    this.el.data({
      current: {
        className: null,
        record: null
      }
    });
    this.list = new GalleriesList({
      el: this.items,
      template: this.template
    });
    this.header.template = this.headerTemplate;
    Gallery.bind('refresh change', this.proxy(this.change));
    GalleriesAlbum.bind('refresh change', this.proxy(this.change));
    AlbumsPhoto.bind('refresh change', this.proxy(this.change));
    Spine.bind('show:galleries', this.proxy(this.show));
  }
  GalleriesView.prototype.change = function() {
    var items;
    console.log('GalleriesView::change');
    items = Gallery.all();
    return this.render(items);
  };
  GalleriesView.prototype.render = function(items) {
    console.log('GalleriesView::render');
    this.list.render(items);
    return this.header.render();
  };
  GalleriesView.prototype.show = function() {
    Spine.trigger('change:toolbarOne', ['Gallery']);
    Album.activeRecord = false;
    Spine.trigger('gallery:activate', Gallery.record);
    return Spine.trigger('change:canvas', this);
  };
  GalleriesView.prototype.newAttributes = function() {
    if (User.first()) {
      return {
        name: 'New Name',
        user_id: User.first().id
      };
    } else {
      return User.ping();
    }
  };
  GalleriesView.prototype.create = function(e) {
    console.log('GalleriesView::create');
    return Spine.trigger('create:gallery');
  };
  GalleriesView.prototype.destroy = function(e) {
    console.log('GalleriesView::destroy');
    return Spine.trigger('destroy:gallery');
  };
  return GalleriesView;
})();
if (typeof module !== "undefined" && module !== null) {
  module.exports = GalleriesView;
}