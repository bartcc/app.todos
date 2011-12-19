var Sidebar;
var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; }, __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
}, __indexOf = Array.prototype.indexOf || function(item) {
  for (var i = 0, l = this.length; i < l; i++) {
    if (this[i] === item) return i;
  }
  return -1;
};
Sidebar = (function() {
  __extends(Sidebar, Spine.Controller);
  Sidebar.extend(Spine.Controller.Drag);
  Sidebar.prototype.elements = {
    'input': 'input',
    '.items': 'items',
    '.inner': 'inner',
    '.droppable': 'droppable',
    '.optAllAlbums': 'albums',
    '.optAllPhotos': 'photos'
  };
  Sidebar.prototype.events = {
    "click button": "create",
    'click .optAllGalleries': 'allGalleries',
    'click .optAllAlbums': 'allAlbums',
    'click .optAllPhotos': 'allPhotos',
    "keyup input": "filter",
    "dblclick .draghandle": 'toggleDraghandle',
    'dragenter .items .item': 'dragenter',
    'dragover  .items .item': 'dragover',
    'dragleave': 'dragleave',
    'drop      .items .item': 'drop',
    'dragend   .items .item': 'dragend'
  };
  Sidebar.prototype.template = function(items) {
    return $("#sidebarTemplate").tmpl(items);
  };
  function Sidebar() {
    this.validateDrop = __bind(this.validateDrop, this);
    this.dropComplete = __bind(this.dropComplete, this);
    this.dragLeave = __bind(this.dragLeave, this);
    this.dragOver = __bind(this.dragOver, this);
    this.dragEnter = __bind(this.dragEnter, this);    Sidebar.__super__.constructor.apply(this, arguments);
    this.el.width(350);
    this.list = new SidebarList({
      el: this.items,
      template: this.template
    });
    Gallery.bind("refresh change", this.proxy(this.render));
    Gallery.bind("ajaxError", Gallery.errorHandler);
    Spine.bind('create:gallery', this.proxy(this.create));
    Spine.bind('edit:gallery', this.proxy(this.edit));
    Spine.bind('destroy:gallery', this.proxy(this.destroy));
    Spine.bind('drag:start', this.proxy(this.dragStart));
    Spine.bind('drag:enter', this.proxy(this.dragEnter));
    Spine.bind('drag:over', this.proxy(this.dragOver));
    Spine.bind('drag:leave', this.proxy(this.dragLeave));
    Spine.bind('drag:drop', this.proxy(this.dropComplete));
    Spine.bind('show:allPhotos', this.proxy(this.showAllPhotos));
    Spine.bind('show:allAlbums', this.proxy(this.showAllAlbums));
  }
  Sidebar.prototype.filter = function() {
    this.query = this.input.val();
    return this.render();
  };
  Sidebar.prototype.render = function(item, mode) {
    var items;
    console.log('Sidebar::render');
    items = Gallery.filter(this.query, {
      func: 'searchSelect'
    });
    items = items.sort(Gallery.nameSort);
    return this.list.render(items, item, mode);
  };
  Sidebar.prototype.dragStart = function(e, controller) {
    var el, event, fromSidebar, id, selection, source, _ref;
    console.log('Sidebar::dragStart');
    if (!Spine.dragItem) {
      return;
    }
    el = $(e.currentTarget);
    event = e.originalEvent;
    Spine.dragItem.targetEl = null;
    source = Spine.dragItem.source;
    if (el.parents('ul.sublist').length) {
      id = el.parents('li.item')[0].id;
      if (id && Gallery.exists(id)) {
        Spine.dragItem.origin = Gallery.find(id);
      }
      fromSidebar = true;
      selection = [source.id];
    } else {
      switch (source.constructor.className) {
        case 'Album':
          selection = Gallery.selectionList();
          break;
        case 'Photo':
          selection = Album.selectionList();
      }
    }
    if (!(_ref = source.id, __indexOf.call(selection, _ref) >= 0)) {
      source.emptySelection().push(source.id);
      switch (source.constructor.className) {
        case 'Album':
          if (!fromSidebar) {
            Spine.trigger('album:exposeSelection', selection);
          }
          break;
        case 'Photo':
          Spine.trigger('photo:exposeSelection', selection);
      }
    }
    return this.clonedSelection = selection.slice(0);
  };
  Sidebar.prototype.dragEnter = function(e) {
    var data, dataEl, el, id, origin, source, target, _ref, _ref2, _ref3, _ref4, _ref5;
    if (!Spine.dragItem) {
      return;
    }
    el = $(e.target).closest('.data');
    dataEl = $(e.target).closest('.data');
    data = ((_ref = dataEl.tmplItem) != null ? _ref.data : void 0) || dataEl.data();
    target = el.item() || el.data();
    source = (_ref2 = Spine.dragItem) != null ? _ref2.source : void 0;
    origin = ((_ref3 = Spine.dragItem) != null ? _ref3.origin : void 0) || Gallery.record;
    if ((_ref4 = Spine.dragItem.closest) != null) {
      _ref4.removeClass('over nodrop');
    }
    Spine.dragItem.closest = el;
    if (this.validateDrop(target, source, origin)) {
      Spine.dragItem.closest.addClass('over');
    } else {
      Spine.dragItem.closest.addClass('over nodrop');
    }
    id = el.attr('id');
    if (id && this._id !== id) {
      this._id = id;
      return (_ref5 = Spine.dragItem.closest) != null ? _ref5.removeClass('over') : void 0;
    }
  };
  Sidebar.prototype.dragOver = function(e) {};
  Sidebar.prototype.dragLeave = function(e) {};
  Sidebar.prototype.dropComplete = function(e) {
    var albums, origin, photos, source, target;
    console.log('Sidebar::dropComplete');
    if (!Spine.dragItem) {
      return;
    }
    Spine.dragItem.closest.removeClass('over nodrop');
    target = Spine.dragItem.closest.item() || Spine.dragItem.closest.data();
    source = Spine.dragItem.source;
    origin = Spine.dragItem.origin;
    if (!this.validateDrop(target, source, origin)) {
      return;
    }
    switch (source.constructor.className) {
      case 'Album':
        albums = [];
        Album.each(__bind(function(record) {
          if (this.clonedSelection.indexOf(record.id) !== -1) {
            return albums.push(record);
          }
        }, this));
        Album.trigger('create:join', target, albums);
        if (!this.isCtrlClick(e)) {
          return Album.trigger('destroy:join', origin, albums);
        }
        break;
      case 'Photo':
        photos = [];
        Photo.each(__bind(function(record) {
          if (this.clonedSelection.indexOf(record.id) !== -1) {
            return photos.push(record);
          }
        }, this));
        Photo.trigger('create:join', target, photos);
        if (!this.isCtrlClick(e)) {
          return Photo.trigger('destroy:join', origin, photos);
        }
    }
  };
  Sidebar.prototype.validateDrop = function(target, source, origin) {
    var item, items, _i, _j, _len, _len2;
    switch (source.constructor.className) {
      case 'Album':
        if (target.constructor.className !== 'Gallery') {
          return false;
        }
        if (!(origin.id !== target.id)) {
          return false;
        }
        items = GalleriesAlbum.filter(target.id, {
          key: 'gallery_id'
        });
        for (_i = 0, _len = items.length; _i < _len; _i++) {
          item = items[_i];
          if (item.album_id === source.id) {
            return false;
          }
        }
        return true;
      case 'Photo':
        if (target.constructor.className !== 'Album') {
          return false;
        }
        if (!(origin.id !== target.id)) {
          return false;
        }
        items = AlbumsPhoto.filter(target.id, {
          key: 'album_id'
        });
        for (_j = 0, _len2 = items.length; _j < _len2; _j++) {
          item = items[_j];
          if (item.photo_id === source.id) {
            return false;
          }
        }
        return true;
      default:
        return false;
    }
  };
  Sidebar.prototype.newAttributes = function() {
    if (User.first()) {
      return {
        name: this.galleryName(),
        author: User.first().name,
        user_id: User.first().id
      };
    } else {
      return User.ping();
    }
  };
  Sidebar.prototype.galleryName = function(proposal) {
    if (proposal == null) {
      proposal = 'Gallery ' + Number(Gallery.count() + 1);
    }
    Gallery.each(__bind(function(record) {
      if (record.name === proposal) {
        return proposal = this.galleryName(proposal + '_1');
      }
    }, this));
    return proposal;
  };
  Sidebar.prototype.create = function() {
    var gallery;
    console.log('Sidebar::create');
    this.openPanel('gallery', App.showView.btnGallery);
    gallery = new Gallery(this.newAttributes());
    gallery.save();
    return Spine.trigger('show:albums');
  };
  Sidebar.prototype.destroy = function() {
    var ga, gas, _i, _len;
    console.log('Sidebar::destroy');
    if (Gallery.record) {
      gas = GalleriesAlbum.filter(Gallery.record.id, {
        key: 'gallery_id'
      });
      for (_i = 0, _len = gas.length; _i < _len; _i++) {
        ga = gas[_i];
        Spine.Ajax.disable(function() {
          return ga.destroy();
        });
      }
      Gallery.record.destroy();
      if (!Gallery.count()) {
        return Gallery.current();
      }
    }
  };
  Sidebar.prototype.edit = function() {
    App.galleryEditView.render();
    return App.contentManager.change(App.galleryEditView);
  };
  Sidebar.prototype.toggleDraghandle = function() {
    var speed, w, width;
    width = __bind(function() {
      var max, w;
      max = App.vmanager.currentDim;
      w = this.el.width();
      if (App.vmanager.sleep) {
        App.vmanager.awake();
        this.clb = function() {};
        return max + "px";
      } else {
        this.clb = App.vmanager.goSleep;
        return '8px';
      }
    }, this);
    w = width();
    speed = 500;
    return this.el.animate({
      width: w
    }, speed, __bind(function() {
      return this.clb();
    }, this));
  };
  Sidebar.prototype.allGalleries = function() {
    return Spine.trigger('show:galleries');
  };
  Sidebar.prototype.allAlbums = function() {
    return Spine.trigger('show:allAlbums', true);
  };
  Sidebar.prototype.allPhotos = function() {
    return Spine.trigger('show:allPhotos', true);
  };
  Sidebar.prototype.showAllPhotos = function(deselect) {
    var changed;
    if (deselect == null) {
      deselect = false;
    }
    if (deselect) {
      this.list.deselect();
    }
    this.showAllAlbums(deselect);
    Gallery.current();
    Album.current();
    changed = Album.changed();
    Spine.trigger('show:photos');
    return Spine.trigger('change:selectedAlbum', false, changed);
  };
  Sidebar.prototype.showAllAlbums = function(deselect) {
    if (deselect == null) {
      deselect = false;
    }
    if (deselect) {
      this.list.deselect();
    }
    Gallery.current();
    Spine.trigger('show:albums');
    return Spine.trigger('change:selectedGallery', false, true);
  };
  return Sidebar;
})();