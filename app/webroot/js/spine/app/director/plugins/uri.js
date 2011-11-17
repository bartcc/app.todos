(function() {
  var $, Ajax, Base, Model, Uri;
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
    return Base;
  })();
  Uri = (function() {
    __extends(Uri, Base);
    function Uri(record, params, callback, max) {
      var ap, aps, options;
      this.record = record;
      this.callback = callback;
      this.recordResponse = __bind(this.recordResponse, this);
      Uri.__super__.constructor.apply(this, arguments);
      aps = AlbumsPhoto.filter(this.record.id);
      this.max = max || aps.length - 1;
      this.photos = (function() {
        var _i, _len, _ref, _results;
        _ref = aps.slice(0, (this.max + 1) || 9e9);
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          ap = _ref[_i];
          _results.push(Photo.find(ap.photo_id));
        }
        return _results;
      }).call(this);
      options = $.extend({}, this.settings, params);
      this.url = options.width + '/' + options.height + '/' + options.square + '/' + options.quality;
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
    Uri.prototype.get = function() {
      return this.queue(__bind(function() {
        return this.ajax({
          type: "POST",
          url: base_url + 'photos/uri/' + this.url,
          data: JSON.stringify(this.photos)
        }).success(this.recordResponse).error(this.errorResponse);
      }, this));
    };
    Uri.prototype.recordResponse = function(uris) {
      this.record.addToCache(this.url, uris);
      return this.callback(uris, this.record);
    };
    Uri.prototype.errorResponse = function() {};
    return Uri;
  })();
  Model.Uri = {
    extended: function() {
      var Include;
      Include = {
        uri: function(params, callback, max) {
          return new Uri(this, params, callback, max).test();
        }
      };
      return this.include(Include);
    }
  };
}).call(this);
