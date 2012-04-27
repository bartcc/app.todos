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
        throw 'record ' + id + ' is not configured ';
      }, this),
      cache: function(record, url) {
        var cached, item, _i, _len;
        cached = this.cacheList(record != null ? record.id : void 0);
        if (!cached) {
          return;
        }
        for (_i = 0, _len = cached.length; _i < _len; _i++) {
          item = cached[_i];
          if (item[url]) {
            return item[url];
          }
        }
        this.initCache(cached, url);
        return this.cache(record, url);
      },
      initCache: function(cached, url) {
        var o;
        o = new Object();
        o[url] = [];
        return cached.push(o);
      },
      addToCache_: function(record, url, uris, mode) {
        var cache, o, uri, _i, _len, _ref;
        cache = this.cacheList(record != null ? record.id : void 0);
        if (mode === 'append') {
          cache = this.cache(record, url);
          for (_i = 0, _len = uris.length; _i < _len; _i++) {
            uri = uris[_i];
            cache.push(uri);
          }
        } else if (uris.length) {
          o = new Object();
          o[url] = uris;
          [].splice.apply(cache, [0, cache.length - 0].concat(_ref = [])), _ref;
          cache.push(o);
        }
        return cache;
      },
      addToCache: function(record, url, uris, mode) {
        var arr, cache, item, uri, _i, _j, _k, _len, _len2, _len3, _ref;
        if (mode === 'html') {
          cache = this.cacheList(record != null ? record.id : void 0);
          for (_i = 0, _len = cache.length; _i < _len; _i++) {
            item = cache[_i];
            if (item[url]) {
              arr = item[url];
              [].splice.apply(arr, [0, arr.length - 0].concat(_ref = [])), _ref;
              for (_j = 0, _len2 = uris.length; _j < _len2; _j++) {
                uri = uris[_j];
                arr.push(uri);
              }
            }
          }
        } else if (uris.length) {
          cache = this.cache(record, url);
          for (_k = 0, _len3 = uris.length; _k < _len3; _k++) {
            uri = uris[_k];
            cache.push(uri);
          }
        }
        return cache;
      },
      destroyCache: function(id) {
        var index, item, spliced, _len, _ref;
        _ref = this.caches;
        for (index = 0, _len = _ref.length; index < _len; index++) {
          item = _ref[index];
          if (item[id]) {
            spliced = this.caches.splice(index, 1);
            return spliced;
          }
        }
      },
      clearCache: function(id) {
        var originalList, _ref;
        originalList = this.cacheList(id);
        [].splice.apply(originalList, [0, originalList.length - 0].concat(_ref = [])), _ref;
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
      destroyCache: function() {
        return this.constructor.destroyCache(this.id);
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
