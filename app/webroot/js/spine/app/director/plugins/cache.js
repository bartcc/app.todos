var $, Model;
var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
if (typeof Spine === "undefined" || Spine === null) {
  Spine = require("spine");
}
$ = Spine.$;
Model = Spine.Model;
Model.Cache = {
  extended: function() {
    var Extend, Include;
    Extend = {
      caches: [
        {
          global: []
        }
      ],
      cacheList: __bind(function(recordID) {
        var id, item, _i, _len, _ref;
        id = recordID || 'global';
        if (!id) {
          return;
        }
        _ref = this.caches;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          item = _ref[_i];
          if (item[id]) {
            return item[id];
          }
        }
      }, this),
      cache: function(record, url) {
        var cache, dummy, item, _i, _len;
        cache = this.cacheList(record != null ? record.id : void 0);
        if (!cache) {
          return;
        }
        for (_i = 0, _len = cache.length; _i < _len; _i++) {
          item = cache[_i];
          if (item[url]) {
            return item[url];
          }
        }
        dummy = {};
        dummy[url] = [];
        cache.push(dummy);
        return this.cache(record, url);
      },
      addToCache: function(record, url, uri, mode) {
        var cache, dummy, ur, _i, _len, _ref;
        cache = this.cacheList(record != null ? record.id : void 0);
        if (!cache) {
          return;
        }
        if (mode === 'append') {
          cache = this.cache(record, url);
          for (_i = 0, _len = uri.length; _i < _len; _i++) {
            ur = uri[_i];
            cache.push(ur);
          }
        } else {
          dummy = {};
          dummy[url] = uri;
          [].splice.apply(cache, [0, cache.length - 0].concat(_ref = [])), _ref;
          cache.push(dummy);
        }
        return cache;
      },
      removeFromCache: function(record) {
        var item, spliced, _i, _len, _ref;
        _ref = this.caches;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          item = _ref[_i];
          if (item[record.id]) {
            spliced = this.caches.splice(index, 1);
            return spliced;
          }
        }
      },
      clearCache: function(id) {
        var originalList, _ref;
        originalList = this.cacheList(id);
        if (originalList) {
          [].splice.apply(originalList, [0, originalList.length - 0].concat(_ref = [])), _ref;
        }
        return originalList;
      }
    };
    Include = {
      cache: function(url) {
        return this.constructor.cache(this, url);
      },
      addToCache: function(url, uri, mode) {
        return this.constructor.addToCache(this, url, uri, mode);
      },
      removeFromCache: function() {
        return this.constructor.removeFromCache(this);
      },
      clearCache: function() {
        var list;
        return list = this.constructor.clearCache(this.id);
      }
    };
    this.extend(Extend);
    return this.include(Include);
  }
};
