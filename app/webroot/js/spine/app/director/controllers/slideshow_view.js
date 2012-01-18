var $, SlideshowView;
var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
}, __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
if (typeof Spine === "undefined" || Spine === null) {
  Spine = require("spine");
}
$ = Spine.$;
SlideshowView = (function() {
  __extends(SlideshowView, Spine.Controller);
  SlideshowView.prototype.elements = {
    '.items': 'items',
    '.thumbnail': 'thumb',
    '#gallery': 'galleryEl'
  };
  SlideshowView.prototype.events = {
    'click .thumbnail': 'clickThumb'
  };
  SlideshowView.prototype.template = function(items) {
    return $("#photosTemplate").tmpl(items);
  };
  function SlideshowView() {
    SlideshowView.__super__.constructor.apply(this, arguments);
    this.el.data({
      current: false
    });
    this.thumbSize = 140;
    this.fullscreen = true;
    this.autoplay = false;
    Spine.bind('show:slideshow', this.proxy(this.show));
    Spine.bind('play:slideshow', this.proxy(this.play));
  }
  SlideshowView.prototype.render = function(items) {
    console.log('SlideshowView::render');
    this.items.html(this.template(items));
    this.uri(items, 'append');
    this.refreshElements();
    this.size();
    return this.el;
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
  SlideshowView.prototype.uri = function(items, mode) {
    console.log('SlideshowView::uri');
    return Album.record.uri(this.params(), mode, __bind(function(xhr, record) {
      return this.callback(items, xhr);
    }, this));
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
  SlideshowView.prototype.loadModal = function(items, mode) {
    if (mode == null) {
      mode = 'html';
    }
    return Album.record.uri(this.modalParams(), mode, __bind(function(xhr, record) {
      return this.callbackModal(items, xhr);
    }, this));
  };
  SlideshowView.prototype.callbackModal = function(items, json) {
    var el, ele, item, jsn, searchJSON, _i, _len;
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
        el = document.createElement('a');
        ele = this.items.children().forItem(item).children('.thumbnail').append($(el).hide().attr({
          'href': jsn.src,
          'title': item.title || item.src,
          'rel': 'gallery'
        }));
      }
    }
    return this.play();
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
  SlideshowView.prototype.show = function() {
    var filterOptions, items;
    console.log('Slideshow::show');
    if (!Album.record) {
      return;
    }
    Spine.trigger('change:canvas', this);
    filterOptions = {
      key: 'album_id',
      joinTable: 'AlbumsPhoto'
    };
    items = Photo.filterRelated(Album.record.id, filterOptions);
    return this.render(items);
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
  SlideshowView.prototype.play = function(autoplay) {
    var first;
    this.refreshElements();
    if (autoplay) {
      first = this.galleryEl.find('.thumbnail:first');
      return window.setTimeout(function() {
        return first.click();
      }, 1);
    }
  };
  SlideshowView.prototype.slideshow = function(active) {
    var val;
    val = active ? 4000 : 0;
    this.galleryEl.imagegallery('option', 'slideshow', val);
    if (val) {
      return this.play(val);
    }
  };
  SlideshowView.prototype.slideshowMode = function(active) {
    if (active == null) {
      active = this.autoplay;
    }
    this.autoplay = active !== false ? active : false;
    return this.slideshow(this.autoplay);
  };
  SlideshowView.prototype.fullscreenMode = function(active) {
    if (active == null) {
      active = this.fullscreen;
    }
    this.fullscreen = active !== false ? active : false;
    this.toggleFullscreen(this.fullscreen);
    return this.fullscreen;
  };
  SlideshowView.prototype.toggleFullscreen = function(active) {
    var root;
    root = document.documentElement;
    if (active) {
      $('#gallery-modal').addClass('fullscreen');
      if (root.webkitRequestFullScreen) {
        return root.webkitRequestFullScreen(window.Element.ALLOW_KEYBOARD_INPUT);
      } else if (root.mozRequestFullScreen) {
        return root.mozRequestFullScreen();
      }
    } else {
      $('#gallery-modal').removeClass('fullscreen');
      return (document.webkitCancelFullScreen || document.mozCancelFullScreen || $.noop).apply(document);
    }
  };
  SlideshowView.prototype.clickThumb = function(e) {
    var el;
    console.log('SlideshowView::click');
    el = $(e.target).find('a');
    e.stopPropagation();
    e.preventDefault();
    return el.click();
  };
  SlideshowView.prototype.anker = function(e) {
    e.stopPropagation();
    return e.preventDefault();
  };
  return SlideshowView;
})();
if (typeof module !== "undefined" && module !== null) {
  module.exports = SlideshowView;
}