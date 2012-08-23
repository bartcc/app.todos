var $, Ajax, Base, Model, Uri, UriCollection;
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
Model = Spine.Model;
Ajax = {
  enabled: true,
  pending: false,
  requests: [],
  requestNext: function() {
    var next;
    next = this.requests.shift();
    if (next) {
      return this.request(next);
    } else {
      this.pending = false;
      return Spine.trigger('uri:alldone');
    }
  },
  request: function(callback) {
    return (callback()).complete(__bind(function() {
      return this.requestNext();
    }, this));
  },
  queue: function(callback) {
    if (!this.enabled) {
      return;
    }
    if (this.pending) {
      this.requests.push(callback);
    } else {
      this.pending = true;
      this.request(callback);
    }
    return callback;
  }
};
Base = (function() {
  function Base() {}
  Base.prototype.defaults = {
    contentType: 'application/json',
    processData: false,
    headers: {
      'X-Requested-With': 'XMLHttpRequest'
    },
    dataType: 'json'
  };
  Base.prototype.ajax = function(params, defaults) {
    return $.ajax($.extend({}, this.defaults, defaults, params));
  };
  Base.prototype.queue = function(callback) {
    return Ajax.queue(callback);
  };
  Base.prototype.get = function() {
    return this.queue(__bind(function() {
      return this.ajax({
        type: "POST",
        url: base_url + 'photos/uri/' + this.url,
        data: JSON.stringify(this.data)
      }).success(this.recordResponse).error(this.errorResponse);
    }, this));
  };
  Base.prototype.uri = function(options) {
    return options.width + '/' + options.height + '/' + options.square + '/' + options.quality;
  };
  return Base;
})();
Uri = (function() {
  __extends(Uri, Base);
  function Uri(model, params, callback, data) {
    var options;
    this.model = model;
    this.callback = callback;
    this.data = data != null ? data : [];
    this.errorResponse = __bind(this.errorResponse, this);
    this.recordResponse = __bind(this.recordResponse, this);
    Uri.__super__.constructor.apply(this, arguments);
    options = $.extend({}, this.settings, params);
    this.url = this.uri(options);
    if (!this.data.length) {
      return;
    }
  }
  Uri.prototype.settings = {
    square: 1,
    quality: 70
  };
  Uri.prototype.init = function() {
    if (!this.cache()) {
      return this.get();
    }
  };
  Uri.prototype.cache = function() {
    var cache, data, idx, raw, res, _len, _ref;
    res = [];
    _ref = this.data;
    for (idx = 0, _len = _ref.length; idx < _len; idx++) {
      data = _ref[idx];
      raw = this.model.cache(this.url, data.id);
      console.log(raw);
      cache = raw[0];
      if (!cache) {
        return;
      }
      res.push(cache);
    }
    console.log(res);
    return this.callback(res);
  };
  Uri.prototype.recordResponse = function(uris) {
    this.model.addToCache(this.url, uris);
    return this.callback(uris);
  };
  Uri.prototype.errorResponse = function(xhr, statusText, error) {
    return this.model.trigger('ajaxError', xhr, statusText, error);
  };
  return Uri;
})();
UriCollection = (function() {
  __extends(UriCollection, Base);
  function UriCollection(record, params, mode, callback, max) {
    var options, photos, type;
    this.record = record;
    this.callback = callback;
    this.errorResponse = __bind(this.errorResponse, this);
    this.recordResponse = __bind(this.recordResponse, this);
    UriCollection.__super__.constructor.apply(this, arguments);
    type = this.record.constructor.className;
    switch (type) {
      case 'Album':
        photos = AlbumsPhoto.photos(this.record.id);
        max = max || photos.length;
        this.mode = mode;
        this.photos = photos.slice(0, max);
        break;
      case 'Photo':
        this.photos = [this.record];
    }
    options = $.extend({}, this.settings, params);
    this.url = this.uri(options);
  }
  UriCollection.prototype.settings = {
    width: 140,
    height: 140,
    square: 1,
    quality: 70
  };
  UriCollection.prototype.init = function() {
    var cache;
    cache = this.record.cache(this.url);
    if (cache != null ? cache.length : void 0) {
      return this.callback(cache, this.record);
    } else {
      return this.get();
    }
  };
  UriCollection.prototype.all = function() {
    return this.queue(__bind(function() {
      return this.ajax({
        type: "POST",
        url: base_url + 'photos/uri/' + this.url,
        data: JSON.stringify(this.photos)
      }).success(this.recordResponse).error(this.errorResponse);
    }, this));
  };
  UriCollection.prototype.recordResponse = function(uris) {
    this.record.addToCache(this.url, uris, this.mode);
    return this.callback(uris, this.record);
  };
  UriCollection.prototype.errorResponse = function(xhr, statusText, error) {
    return this.record.trigger('ajaxError', xhr, statusText, error);
  };
  return UriCollection;
})();
Model.Uri = {
  extended: function() {
    var Extend, Include;
    Include = {
      uri: function(params, mode, callback, max) {
        return new UriCollection(this, params, mode, callback, max).init();
      }
    };
    Extend = {
      uri: function(params, callback, data) {
        return new Uri(this, params, callback, data).init();
      }
    };
    this.include(Include);
    return this.extend(Extend);
  }
};
