var $, SlideshowView;
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
SlideshowView = (function() {
  __extends(SlideshowView, Spine.Controller);
  SlideshowView.prototype.elements = {
    '.items': 'items',
    '.thumbnail': 'thumb'
  };
  SlideshowView.prototype.template = function(items) {
    return $("#photosSlideshowTemplate").tmpl(items);
  };
  function SlideshowView() {
    this.slideshowPlay = __bind(this.slideshowPlay, this);
    this.sliderStart = __bind(this.sliderStart, this);    SlideshowView.__super__.constructor.apply(this, arguments);
    this.el.data({
      current: {
        className: 'Slideshow'
      }
    });
    this.thumbSize = 240;
    this.fullScreen = true;
    this.autoplay = false;
    Spine.bind('show:slideshow', this.proxy(this.show));
    Spine.bind('slider:change', this.proxy(this.size));
    Spine.bind('slider:start', this.proxy(this.sliderStart));
    Spine.bind('slideshow:ready', this.proxy(this.play));
  }
  SlideshowView.prototype.render = function(items) {
    this.items.html(this.template(items));
    this.uri(items);
    this.refreshElements();
    this.size(App.showView.sliderOutValue());
    this.items.children().sortable('photo');
    this.exposeSelection();
    return this.el;
  };
  SlideshowView.prototype.exposeSelection = function() {
    var id, item, list, _i, _len, _results;
    console.log('SlideshowView::exposeSelection');
    this.deselect();
    list = Album.selectionList();
    _results = [];
    for (_i = 0, _len = list.length; _i < _len; _i++) {
      id = list[_i];
      _results.push(Photo.exists(id) ? (item = Photo.find(id), this.items.children().forItem(item, true).addClass("active")) : void 0);
    }
    return _results;
  };
  SlideshowView.prototype.params = function(width, height) {
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
  SlideshowView.prototype.modalParams = function() {
    return {
      width: 600,
      height: 451,
      square: 2,
      force: false
    };
  };
  SlideshowView.prototype.uri = function(items) {
    console.log('SlideshowView::uri');
    return Photo.uri(this.params(), __bind(function(xhr, record) {
      return this.callback(items, xhr);
    }, this), this.phos);
  };
  SlideshowView.prototype.callback = function(items, json) {
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
        ele = this.items.children().forItem(item);
        src = jsn.src;
        img = new Image;
        img.element = ele;
        img.onload = this.imageLoad;
        img.src = src;
      }
    }
    return this.loadModal(items);
  };
  SlideshowView.prototype.imageLoad = function() {
    var css;
    css = 'url(' + this.src + ')';
    return $('.thumbnail', this.element).css({
      'backgroundImage': css,
      'backgroundPosition': 'center, center',
      'backgroundSize': '100%'
    });
  };
  SlideshowView.prototype.loadModal = function(items, mode) {
    if (mode == null) {
      mode = 'html';
    }
    return Photo.uri(this.modalParams(), __bind(function(xhr, record) {
      return this.callbackModal(xhr, items);
    }, this), this.phos);
  };
  SlideshowView.prototype.callbackModal = function(json, items) {
    var el, item, jsn, searchJSON, _i, _len;
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
        el = this.items.children().forItem(item);
        $('div.thumbnail', el).attr({
          'data-href': jsn.src,
          'title': item.title || item.src,
          'rel': 'gallery'
        });
      }
    }
    return Spine.trigger('slideshow:ready');
  };
  SlideshowView.prototype.show = function() {
    var filterOptions;
    console.log('Slideshow::show');
    App.showView.trigger('change:toolbarOne', ['']);
    App.showView.trigger('change:toolbarTwo', ['SlideshowPackage', App.showView.initSlider]);
    App.showView.trigger('canvas', this);
    filterOptions = {
      key: 'album_id',
      joinTable: 'AlbumsPhoto',
      sorted: true
    };
    return this.render(this.phos = this.photos());
  };
  SlideshowView.prototype.close = function(e) {
    this.parent.showPrevious();
    if (Gallery.record) {
      return this.navigate('/gallery', Gallery.record.id);
    }
  };
  SlideshowView.prototype.sliderStart = function() {
    return this.refreshElements();
  };
  SlideshowView.prototype.size = function(val, bg) {
    if (val == null) {
      val = this.thumbSize;
    }
    if (bg == null) {
      bg = 'none';
    }
    return this.thumb.css({
      'height': val + 'px',
      'width': val + 'px',
      'backgroundSize': bg
    });
  };
  SlideshowView.prototype.toggleFullScreen = function(activate) {
    var active, root;
    active = this.fullScreenEnabled();
    root = document.documentElement;
    if (!active) {
      $('#modal-gallery').addClass('modal-fullscreen');
      if (root.webkitRequestFullScreen) {
        return root.webkitRequestFullScreen(window.Element.ALLOW_KEYBOARD_INPUT);
      } else if (root.mozRequestFullScreen) {
        return root.mozRequestFullScreen();
      }
    } else {
      $('#modal-gallery').removeClass('modal-fullscreen');
      return (document.webkitCancelFullScreen || document.mozCancelFullScreen || $.noop).apply(document);
    }
  };
  SlideshowView.prototype.fullScreenEnabled = function() {
    return !!window.fullScreen || $('#modal-gallery').hasClass('modal-fullscreen');
  };
  SlideshowView.prototype.activePhotos = function() {
    var alb, albs, album, itm, pho, phos, photos, _i, _j, _k, _len, _len2, _len3, _ref;
    phos = [];
    albs = [];
    _ref = Gallery.selectionList();
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      itm = _ref[_i];
      albs.push(itm);
    }
    if (!albs.length) {
      return;
    }
    for (_j = 0, _len2 = albs.length; _j < _len2; _j++) {
      alb = albs[_j];
      album = Album.exists(alb);
      photos = album.photos();
      for (_k = 0, _len3 = photos.length; _k < _len3; _k++) {
        pho = photos[_k];
        phos.push(pho);
      }
    }
    return phos;
  };
  SlideshowView.prototype.slideshowable = function() {
    return this.activePhotos().length;
  };
  SlideshowView.prototype.play = function() {
    var elFromCanvas, elFromSelection, it;
    console.log('SlideshowView::play');
    elFromSelection = __bind(function() {
      var el, id, item, list, parent, root;
      console.log('elFromSelection');
      list = Album.selectionList();
      if (list.length) {
        id = list[0];
        if (Photo.exists(id)) {
          item = Photo.find(id);
        }
        root = this.current.el.children('.items');
        parent = root.children().forItem(item);
        el = $('[rel="gallery"]', parent)[0];
        return el;
      }
    }, this);
    elFromCanvas = __bind(function() {
      var el, item, parent, root;
      console.log('elFromCanvas');
      item = AlbumsPhoto.photos(Album.record.id)[0];
      root = this.current.el.children('.items');
      parent = root.children().forItem(item);
      el = $('[rel="gallery"]', parent)[0];
      return el;
    }, this);
    if (this.slideshowable()) {
      console.log(it = elFromSelection() || elFromCanvas());
      return it.click();
    } else {
      return alert('UUpps');
    }
  };
  SlideshowView.prototype.pause = function(e) {
    var isShown, modal;
    if (!this.slideshowable()) {
      return;
    }
    modal = $('#modal-gallery').data('modal');
    isShown = modal != null ? modal.isShown : void 0;
    if (!isShown) {
      this.slideshowPlay(e);
    } else {
      $('#modal-gallery').data('modal').toggleSlideShow();
    }
    return false;
  };
  SlideshowView.prototype.slideshowPlay = function(e) {
    return this.navigate('/slideshow', Math.random() * 16 | 0);
  };
  return SlideshowView;
})();
if (typeof module !== "undefined" && module !== null) {
  module.exports = SlideshowView;
}
