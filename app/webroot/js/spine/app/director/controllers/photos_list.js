var $, PhotosList;
var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; }, __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
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
PhotosList = (function() {
  __extends(PhotosList, Spine.Controller);
  PhotosList.prototype.elements = {
    '.thumbnail': 'thumb'
  };
  PhotosList.prototype.events = {
    'click .item': 'click',
    'click .more-icon.delete': 'deletePhoto',
    'dblclick .item': 'dblclick',
    'mouseenter .item': 'infoEnter',
    'mousemove  .item': 'infoMove',
    'mouseleave .item': 'infoLeave',
    'mouseleave  .item': 'infoBye',
    'dragstart .item': 'stopInfo'
  };
  PhotosList.prototype.selectFirst = true;
  function PhotosList() {
    this.sliderStart = __bind(this.sliderStart, this);
    this.stopInfo = __bind(this.stopInfo, this);
    this.infoBye = __bind(this.infoBye, this);
    this.infoUp = __bind(this.infoUp, this);
    this.callback = __bind(this.callback, this);    PhotosList.__super__.constructor.apply(this, arguments);
    Photo.bind('sortupdate', this.proxy(this.sortupdate));
    Spine.bind('photo:activate', this.proxy(this.activate));
    Spine.bind('slider:start', this.proxy(this.sliderStart));
    Spine.bind('slider:change', this.proxy(this.size));
    Photo.bind('update', this.proxy(this.update));
    Photo.bind("ajaxError", Photo.errorHandler);
    Album.bind("ajaxError", Album.errorHandler);
    Photo.bind('uri', this.proxy(this.uri));
  }
  PhotosList.prototype.change = function() {
    return console.log('PhotosList::change');
  };
  PhotosList.prototype.select = function(item, e) {
    console.log('PhotosList::select');
    this.current = Photo.current(item);
    return this.exposeSelection();
  };
  PhotosList.prototype.render = function(items, mode) {
    if (mode == null) {
      mode = 'html';
    }
    console.log('PhotosList::render');
    if (Album.record) {
      this.el.removeClass('all');
      if (items.length) {
        this[mode](this.template(items));
        if (mode !== 'append') {
          this.exposeSelection();
        }
        this.uri(items, mode);
      } else {
        this.html('<label class="invite"><span class="enlightened">This album has no images.</span></label>');
      }
    } else {
      this.el.addClass('all');
      this.renderAll();
    }
    this.elIn = $('.more-icon', this.el);
    return this.el;
  };
  PhotosList.prototype.renderAll = function() {
    var items;
    console.log('PhotosList::renderAll');
    items = Photo.all();
    if (items.length) {
      this.html(this.template(items));
      this.exposeSelection();
      this.uri(items, 'html');
    }
    return this.el;
  };
  PhotosList.prototype.update = function(item) {
    var active, backgroundImage, css, el, tb, tmplItem;
    console.log('PhotosList::update');
    el = __bind(function() {
      return this.children().forItem(item);
    }, this);
    tb = function() {
      return $('.thumbnail', el());
    };
    backgroundImage = tb().css('backgroundImage');
    css = tb().attr('style');
    active = el().hasClass('active');
    tmplItem = el().tmplItem();
    tmplItem.tmpl = $("#photosTemplate").template();
    tmplItem.update();
    tb().attr('style', css);
    el().toggleClass('active', active);
    return this.refreshElements();
  };
  PhotosList.prototype.thumbSize = function(width, height) {
    if (width == null) {
      width = this.parent.thumbSize;
    }
    if (height == null) {
      height = this.parent.thumbSize;
    }
    return {
      width: width,
      height: height
    };
  };
  PhotosList.prototype.uri = function(items, mode) {
    console.log('PhotosList::uri');
    this.size(this.parent.sOutValue);
    if (Album.record) {
      return Album.record.uri(this.thumbSize(), mode, __bind(function(xhr, record) {
        return this.callback(items, xhr);
      }, this));
    } else {
      return Photo.uri(this.thumbSize(), mode, __bind(function(xhr, record) {
        return this.callback(items, xhr);
      }, this));
    }
  };
  PhotosList.prototype.callback = function(items, json) {
    var ele, img, item, jsn, searchJSON, src, _i, _len;
    console.log('PhotosList::callback');
    searchJSON = function(id) {
      var itm, _i, _len;
      for (_i = 0, _len = json.length; _i < _len; _i++) {
        itm = json[_i];
        if (itm[id]) {
          return itm[id];
        }
      }
    };
    for (_i = 0, _len = items.length; _i < _len; _i++) {
      item = items[_i];
      jsn = searchJSON(item.id);
      if (jsn) {
        ele = this.children().forItem(item);
        src = jsn.src;
        img = new Image;
        img.element = ele;
        img.onload = this.imageLoad;
        img.src = src;
      }
    }
    return this.loadModal(items);
  };
  PhotosList.prototype.imageLoad = function() {
    var css;
    css = 'url(' + this.src + ')';
    return $('.thumbnail', this.element).css({
      'backgroundImage': css,
      'backgroundPosition': 'center, center',
      'backgroundSize': '100%'
    });
  };
  PhotosList.prototype.modalParams = function() {
    return {
      width: 600,
      height: 451,
      square: 2,
      force: false
    };
  };
  PhotosList.prototype.loadModal = function(items, mode) {
    if (mode == null) {
      mode = 'html';
    }
    if (!Album.record) {
      return;
    }
    return Album.record.uri(this.modalParams(), mode, __bind(function(xhr, record) {
      return this.callbackModal(items, xhr);
    }, this));
  };
  PhotosList.prototype.callbackModal = function(items, json) {
    var a, el, item, jsn, searchJSON, _i, _len;
    console.log('Slideshow::callbackModal');
    searchJSON = function(id) {
      var itm, _i, _len;
      for (_i = 0, _len = json.length; _i < _len; _i++) {
        itm = json[_i];
        if (itm[id]) {
          return itm[id];
        }
      }
    };
    for (_i = 0, _len = items.length; _i < _len; _i++) {
      item = items[_i];
      jsn = searchJSON(item.id);
      if (jsn) {
        el = this.children().forItem(item);
        a = $('<a></a>').attr({
          'data-href': jsn.src,
          'title': item.title || item.src,
          'rel': 'gallery'
        });
        $('.play', el).append(a);
      }
    }
    if (!this.parent.silent) {
      return this.play();
    }
  };
  PhotosList.prototype.play = function() {
    var el;
    el = this.children('li:first');
    $('a', el).click();
    return this.parent.silent = true;
  };
  PhotosList.prototype.playSlideshow = function(e) {
    var el;
    el = $(e.target).closest('li.item');
    console.log($('.play a', el));
    $('.play a', el).click();
    e.preventDefault();
    e.stopPropagation();
    return false;
  };
  PhotosList.prototype.exposeSelection = function() {
    var id, item, list, _i, _len;
    console.log('PhotosList::exposeSelection');
    this.deselect();
    list = Album.selectionList();
    for (_i = 0, _len = list.length; _i < _len; _i++) {
      id = list[_i];
      if (Photo.exists(id)) {
        item = Photo.find(id);
        this.children().forItem(item).addClass("active");
      }
    }
    return this.activate();
  };
  PhotosList.prototype.activate = function() {
    var first, selection;
    selection = Album.selectionList();
    if (selection.length === 1) {
      if (Photo.exists(selection[0])) {
        first = Photo.find(selection[0]);
      }
      if (!(first != null ? first.destroyed : void 0)) {
        this.current = first;
        return Photo.current(first);
      }
    } else {
      return Photo.current();
    }
  };
  PhotosList.prototype.click = function(e) {
    var item;
    console.log('PhotosList::click');
    item = $(e.currentTarget).item();
    item.addRemoveSelection(this.isCtrlClick(e));
    Spine.trigger('change:toolbarOne');
    this.select(item, e);
    if ($(e.target).hasClass('thumbnail')) {
      return e.stopPropagation();
    }
  };
  PhotosList.prototype.dblclick = function(e) {
    console.log('PhotosList::dblclick');
    Spine.trigger('show:photo', this.current);
    this.exposeSelection();
    e.stopPropagation();
    return e.preventDefault();
  };
  PhotosList.prototype.deletePhoto = function(e) {
    var item;
    item = $(e.target).closest('.item').item();
    Album.updateSelection(item.id);
    Spine.trigger('destroy:photo');
    this.stopInfo();
    return false;
  };
  PhotosList.prototype.sortupdate = function() {
    this.children().each(function(index) {
      var ap, item, photo;
      item = $(this).item();
      if (item && Album.record) {
        ap = AlbumsPhoto.filter(item.id, {
          func: 'selectPhoto'
        })[0];
        if (ap && ap.order !== index) {
          ap.order = index;
          return ap.save();
        }
      } else if (item) {
        photo = (Photo.filter(item.id, {
          func: 'selectPhoto'
        }))[0];
        photo.order = index;
        return photo.save();
      }
    });
    return this.exposeSelection();
  };
  PhotosList.prototype.infoEnter = function(e) {
    var el;
    this.elIn.removeClass('in');
    el = $(e.target).find('.more-icon');
    return el.addClass('in');
  };
  PhotosList.prototype.infoMove = function(e) {
    var el;
    el = $(e.target).find('.more-icon');
    return this.inEl = el.addClass('in');
  };
  PhotosList.prototype.infoLeave = function(e) {
    return this.elIn.removeClass('in');
  };
  PhotosList.prototype.initSelectable = function() {
    var options;
    options = {
      helper: 'clone'
    };
    return this.el.selectable();
  };
  PhotosList.prototype.infoUp = function(e) {
    this.info.up(e);
    return e.preventDefault();
  };
  PhotosList.prototype.infoBye = function(e) {
    this.info.bye();
    return e.preventDefault();
  };
  PhotosList.prototype.stopInfo = function(e) {
    return this.info.bye();
  };
  PhotosList.prototype.sliderStart = function() {
    return this.refreshElements();
  };
  PhotosList.prototype.size = function(val, bg) {
    if (bg == null) {
      bg = 'none';
    }
    return this.thumb.css({
      'height': val + 'px',
      'width': val + 'px',
      'backgroundSize': bg
    });
  };
  return PhotosList;
})();
if (typeof module !== "undefined" && module !== null) {
  module.exports = PhotosList;
}
