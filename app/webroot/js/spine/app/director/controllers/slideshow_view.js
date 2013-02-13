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
    this.sliderStart = __bind(this.sliderStart, this);    SlideshowView.__super__.constructor.apply(this, arguments);
    this.el.data({
      current: {
        className: 'Slideshow'
      }
    });
    this.thumbSize = 240;
    this.fullScreen = true;
    this.autoplay = false;
    this.autostart = false;
    Spine.bind('show:slideshow', this.proxy(this.show));
    Spine.bind('slider:change', this.proxy(this.size));
    Spine.bind('slider:start', this.proxy(this.sliderStart));
    Spine.bind('chromeless', this.proxy(this.chromeless));
    this.bind('slideshow:ready', this.proxy(this.play));
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
      _results.push(Photo.exists(id) ? (Photo.exists(id) ? item = Photo.find(id) : void 0, this.items.children().forItem(item, true).addClass("active")) : void 0);
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
    }, this), this.photos());
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
    }, this), this.photos());
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
    return this.play();
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
    if (Album.record) {
      this.render(Photo.filterRelated(Album.record.id, filterOptions));
    }
    return this.render(this.phos = this.photos());
  };
  SlideshowView.prototype.close = function(e) {
    this.parent.showPrevious();
    if (Gallery.record) {
      return this.navigate('/gallery', Gallery.record.id);
    } else {
      return this.navigate('/galleryies/');
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
    var isActive, root;
    root = document.documentElement;
    if (activate || !(isActive = this.fullScreenEnabled())) {
      $('#modal-gallery').addClass('modal-fullscreen');
      if (root.webkitRequestFullScreen) {
        root.webkitRequestFullScreen(window.Element.ALLOW_KEYBOARD_INPUT);
      } else if (root.mozRequestFullScreen) {
        root.mozRequestFullScreen();
      }
    } else {
      $('#modal-gallery').removeClass('modal-fullscreen');
      (document.webkitCancelFullScreen || document.mozCancelFullScreen || $.noop).apply(document);
    }
    return this.fullScreenEnabled();
  };
  SlideshowView.prototype.fullScreenEnabled = function() {
    return !!window.fullScreen || $('#modal-gallery').hasClass('modal-fullscreen');
  };
  SlideshowView.prototype.slideshowable = function() {
    return this.photos().length;
  };
  SlideshowView.prototype.isAutoplay = function() {
    return this.autoplay;
  };
  SlideshowView.prototype.isAutostart = function() {
    return App.slideshow.options.autostart;
  };
  SlideshowView.prototype.play = function() {
    var el, elFromCanvas, elFromSelection;
    if (!this.isActive()) {
      this.navigate('/slideshow', Math.random() * 16 | 0);
    }
    elFromSelection = __bind(function() {
      var el, id, item, list, parent;
      console.log('elFromSelection');
      list = Album.selectionList();
      if (list.length) {
        id = list[0];
        if (Photo.exists(id)) {
          item = Photo.find(id);
        }
        parent = this.el.children().forItem(item, true);
        el = $('[rel="gallery"]', parent)[0];
        return el;
      }
    }, this);
    elFromCanvas = __bind(function() {
      var el, item;
      console.log('elFromCanvas');
      item = AlbumsPhoto.photos(Album.record.id)[0];
      el = $('[rel=gallery]', this.el)[0];
      return el;
    }, this);
    if (this.slideshowable()) {
      if ($('.modal-backdrop').length) {
        return;
      }
      el = elFromSelection() || elFromCanvas();
      return el != null ? el.click() : void 0;
    } else {
      return this.notify();
    }
  };
  SlideshowView.prototype.stop = function() {
    return App.slideshow.stopSlideShow();
  };
  SlideshowView.prototype.notify = function() {
    return App.modalView.show({
      header: 'Information',
      body: 'To start a slideshow at least one (not empty) album must be selected',
      info: 'Tip of the day: You can also use your spacebar to start a slideshow'
    });
  };
  SlideshowView.prototype.toggle = function(e) {
    if (!this.slideshowable()) {
      this.notify();
      return;
    }
    if (!App.slideshow.isShown) {
      this.navigate('/slideshow', Math.random() * 16 | 0);
    } else {
      App.slideshow.toggleSlideShow();
    }
    return false;
  };
  return SlideshowView;
})();
if (typeof module !== "undefined" && module !== null) {
  module.exports = SlideshowView;
}
