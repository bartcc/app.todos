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
    'click .icon-set .zoom': 'zoom',
    'click .icon-set .delete': 'deletePhoto',
    'mouseenter .item': 'infoEnter',
    'mousemove': 'infoMove',
    'mousemove .item': 'infoUp',
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
  }
  PhotosList.prototype.change = function() {
    return console.log('PhotosList::change');
  };
  PhotosList.prototype.select = function(item, lonely) {
    console.log('PhotosList::select');
    if (item != null) {
      item.addRemoveSelection(lonely);
    }
    this.current = Photo.current(item != null);
    return this.exposeSelection();
  };
  PhotosList.prototype.render = function(items, mode) {
    var html;
    if (items == null) {
      items = [];
    }
    if (mode == null) {
      mode = 'html';
    }
    console.log('PhotosList::render');
    if (Album.record) {
      this.el.removeClass('all');
      if (items.length) {
        this[mode](this.template(items));
        if (mode === 'html') {
          this.exposeSelection();
        }
        this.uri(items, mode);
      } else {
        html = '<label class="invite"><span class="enlightened">This Album has no Photos. &nbsp;<p>You can simply add some Photos by dropping them in to the browser window.</p>';
        if (Photo.count()) {
          html += '<button class="optShowAllPhotos dark large">Show existing Photos</button></span>';
        }
        html += '</label>';
        this.html(html);
      }
    } else {
      this.el.addClass('all');
      this.renderAll();
    }
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
      width = App.showView.thumbSize;
    }
    if (height == null) {
      height = App.showView.thumbSize;
    }
    return {
      width: width,
      height: height
    };
  };
  PhotosList.prototype.uri = function(items, mode) {
    console.log('PhotosList::uri');
    this.size(App.showView.sOutValue);
    return Photo.uri(this.thumbSize(), __bind(function(xhr, record) {
      return this.callback(xhr, items);
    }, this), this.photos());
  };
  PhotosList.prototype.callback = function(json, items) {
    var ele, img, item, jsn, searchJSON, src, _i, _len;
    if (json == null) {
      json = [];
    }
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
    if (App.slideshow.options.autostart) {
      return Spine.trigger('show:slideshow');
    }
  };
  PhotosList.prototype.photos = function(id) {
    if (Album.record) {
      return Album.record.photos();
    } else if (id) {
      return Album.photos(id);
    } else {
      return Photo.all();
    }
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
    return Photo.uri(this.modalParams(), __bind(function(xhr, record) {
      return this.callbackModal(xhr, items);
    }, this), this.photos());
  };
  PhotosList.prototype.callbackModal = function(json, items) {
    var a, el, item, jsn, searchJSON, _i, _len, _results;
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
    _results = [];
    for (_i = 0, _len = items.length; _i < _len; _i++) {
      item = items[_i];
      jsn = searchJSON(item.id);
      _results.push(jsn ? (el = this.children().forItem(item), a = $('<a></a>').attr({
        'data-href': jsn.src,
        'title': item.title || item.src,
        'data-iso': item.iso || '',
        'data-captured': item.captured || '',
        'data-description': item.description || '',
        'data-model': item.model || '',
        'rel': 'gallery'
      }), $('.play', el).append(a)) : void 0);
    }
    return _results;
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
    this.select(item, this.isCtrlClick(e));
    App.showView.trigger('change:toolbarOne');
    if ($(e.target).hasClass('thumbnail')) {
      return e.stopPropagation();
    }
  };
  PhotosList.prototype.zoom = function(e) {
    var item, _ref, _ref2;
    item = $(e != null ? e.currentTarget : void 0).item() || this.current;
    this.select(item, true);
    this.stopInfo();
    this.navigate('/gallery', ((_ref = Gallery.record) != null ? _ref.id : void 0) || 'nope', ((_ref2 = Album.record) != null ? _ref2.id : void 0) || 'nope', item.id);
    Spine.trigger('photo:activate', item);
    e.stopPropagation();
    return e.preventDefault();
  };
  PhotosList.prototype.deletePhoto = function(e) {
    var el, item, _ref;
    item = $(e.currentTarget).item();
    if ((item != null ? (_ref = item.constructor) != null ? _ref.className : void 0 : void 0) !== 'Photo') {
      return;
    }
    el = $(e.currentTarget).parents('.item');
    el.removeClass('in');
    Album.updateSelection(item.id);
    window.setTimeout(__bind(function() {
      var album;
      Spine.trigger('destroy:photo');
      this.stopInfo();
      if (album = Album.record) {
        if (!this.el.children().length) {
          return this.parent.render();
        }
      }
    }, this), 300);
    this.stopInfo();
    e.stopPropagation();
    return e.preventDefault();
  };
  PhotosList.prototype.sortupdate = function() {
    this.children().each(function(index) {
      var ap, item;
      item = $(this).item();
      if (item) {
        ap = AlbumsPhoto.filter(item.id, {
          func: 'selectPhoto'
        })[0];
        if (ap && ap.order !== index) {
          ap.order = index;
          ap.save();
        }
        return Album.record.invalid = true;
      }
    });
    return this.exposeSelection();
  };
  PhotosList.prototype.initSelectable = function() {
    var options;
    options = {
      helper: 'clone'
    };
    return this.el.selectable();
  };
  PhotosList.prototype.infoUp = function(e) {
    var el;
    this.info.up(e);
    el = $('.icon-set', $(e.currentTarget)).addClass('in').removeClass('out');
    return e.preventDefault();
  };
  PhotosList.prototype.infoBye = function(e) {
    var el;
    this.info.bye();
    el = $('.icon-set', $(e.currentTarget)).addClass('out').removeClass('in');
    return e.preventDefault();
  };
  PhotosList.prototype.stopInfo = function(e) {
    return this.info.bye();
  };
  PhotosList.prototype.infoEnter = function(e) {};
  PhotosList.prototype.infoMove = function(e) {};
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
