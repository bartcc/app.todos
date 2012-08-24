var SidebarFlickr;
var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
SidebarFlickr = (function() {
  __extends(SidebarFlickr, Spine.Controller);
  SidebarFlickr.prototype.elements = {
    '.items': 'items',
    '.inner': 'inner'
  };
  SidebarFlickr.prototype.events = {
    'click      .expander': 'expand',
    'click': 'expand'
  };
  SidebarFlickr.prototype.template = function(items) {
    return $("#sidebarFlickrTemplate").tmpl(items);
  };
  function SidebarFlickr() {
    SidebarFlickr.__super__.constructor.apply(this, arguments);
    this.render();
  }
  SidebarFlickr.prototype.render = function() {
    var items;
    items = {
      name: 'Flickr',
      sub: [
        {
          name: 'Recent'
        }, {
          name: 'User'
        }
      ]
    };
    return this.html(this.template(items));
  };
  SidebarFlickr.prototype.expand = function(e) {
    var content, icon, parent;
    parent = $(e.target).parents('li');
    icon = $('.expander', parent);
    content = $('.sublist', parent);
    icon.toggleClass('expand');
    if (content.is(':visible')) {
      content.hide();
    } else {
      content.show();
    }
    e.stopPropagation();
    return e.preventDefault();
  };
  SidebarFlickr.prototype.renderSublist = function(gallery) {
    var album, albums, filterOptions, galleryEl, gallerySublist, _i, _len;
    if (gallery == null) {
      gallery = Gallery.record;
    }
    console.log('SidebarList::renderOneSublist');
    if (!gallery) {
      return;
    }
    filterOptions = {
      key: 'gallery_id',
      joinTable: 'GalleriesAlbum',
      sorted: true
    };
    albums = Album.filterRelated(gallery.id, filterOptions);
    for (_i = 0, _len = albums.length; _i < _len; _i++) {
      album = albums[_i];
      album.count = AlbumsPhoto.filter(album.id, {
        key: 'album_id'
      }).length;
    }
    if (!albums.length) {
      albums.push({
        flash: 'no albums'
      });
    }
    galleryEl = this.children().forItem(gallery);
    gallerySublist = $('ul', galleryEl);
    gallerySublist.html(this.sublistTemplate(albums));
    return this.updateTemplate(gallery);
  };
  return SidebarFlickr;
})();
