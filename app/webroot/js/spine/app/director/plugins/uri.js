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
    dataType: 'json',
    processData: false,
    headers: {
      'X-Requested-With': 'XMLHttpRequest'
    }
  };
  Base.prototype.ajax = function(params, defaults) {
    return $.ajax($.extend({}, this.defaults, defaults, params));
  };
  Base.prototype.queue = function(callback) {
    return Ajax.queue(callback);
  };
  Base.prototype.get = function(item) {
    return this.queue(__bind(function() {
      return this.ajax({
        type: "POST",
        url: base_url + 'photos/uri/' + this.url,
        data: JSON.stringify(this.photos)
      }).success(this.recordResponse).error(this.errorResponse);
    }, this));
  };
  Base.prototype.uri = function(options) {
    return options.width + '/' + options.height + '/' + options.square + '/' + options.quality;
  };
  return Base;
})();
UriCollection = (function() {
  __extends(UriCollection, Base);
  function UriCollection(model, params, mode, callback) {
    var options;
    this.model = model;
    if (mode == null) {
      mode = 'html';
    }
    this.callback = callback;
    this.recordResponse = __bind(this.recordResponse, this);
    UriCollection.__super__.constructor.apply(this, arguments);
    this.photos = this.model.all();
    options = $.extend({}, this.settings, params);
    this.url = this.uri(options);
  }
  UriCollection.prototype.settings = {
    square: 1,
    quality: 70
  };
  UriCollection.prototype.test = function() {
    var cache;
    cache = this.model.cache(null, this.url);
    if (cache) {
      console.log('have cache');
      return this.callback(cache);
    } else if (this.photos.length) {
      console.log('no cache found');
      return this.get();
    }
  };
  UriCollection.prototype.recordResponse = function(uris) {
    this.model.addToCache(null, this.url, uris, this.mode);
    return this.callback(uris);
  };
  UriCollection.prototype.errorResponse = function() {};
  return UriCollection;
})();
Uri = (function() {
  __extends(Uri, Base);
  function Uri(record, params, mode, callback, max) {
    var ap, aps, options;
    this.record = record;
    this.callback = callback;
    this.recordResponse = __bind(this.recordResponse, this);
    Uri.__super__.constructor.apply(this, arguments);
    if (this.record) {
      aps = AlbumsPhoto.filter(this.record.id, {
        key: 'album_id'
      });
      max = max || aps.length - 1;
      this.mode = mode;
      this.photos = (function() {
        var _i, _len, _ref, _results;
        _ref = aps.slice(0, (max + 1) || 9e9);
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          ap = _ref[_i];
          _results.push(Photo.find(ap.photo_id));
        }
        return _results;
      })();
    }
    options = $.extend({}, this.settings, params);
    this.url = this.uri(options);
  }
  Uri.prototype.settings = {
    width: 140,
    height: 140,
    square: 1,
    quality: 70
  };
  Uri.prototype.test = function() {
    var cache;
    cache = this.record.cache(this.url);
    if (cache) {
      return this.callback(cache, this.record);
    } else if (this.photos.length) {
      return this.get();
    }
  };
  Uri.prototype.all = function() {
    return this.queue(__bind(function() {
      return this.ajax({
        type: "POST",
        url: base_url + 'photos/uri/' + this.url,
        data: JSON.stringify(this.photos)
      }).success(this.collectionResponse).error(this.errorResponse);
    }, this));
  };
  Uri.prototype.recordResponse = function(uris) {
    this.record.addToCache(this.url, uris, this.mode);
    return this.callback(uris, this.record);
  };
  Uri.prototype.errorResponse = function() {};
  return Uri;
})();
Model.Uri = {
  extended: function() {
    var Extend, Include;
    Include = {
      uri: function(params, mode, callback, max) {
        return new Uri(this, params, mode, callback, max).test();
      }
    };
    Extend = {
      uri: function(params, mode, callback) {
        return new UriCollection(this, params, mode, callback).test();
      }
    };
    this.include(Include);
    return this.extend(Extend);
  }
};