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
      caches: [],
      cacheList: __bind(function(recordID) {
        var id, item, _i, _len, _ref;
        id = recordID || this.record.id;
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
        var cache, item, _i, _len;
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
      },
      addToCache: function(record, url, uri, mode) {
        var cache, dummy;
        cache = this.cacheList(record.id);
        if (!cache) {
          return;
        }
        dummy = {};
        if (mode === 'append') {
          cache = this.cache(record, url) || (dummy[url] = []);
          cache.push(dummy[url]);
        } else {
          dummy[url] = uri;
          if (!this.cache(record, url)) {
            cache.push(dummy);
          }
        }
        return cache;
      },
      clearCache: function(id) {
        var newLength, oldLength, originalList, _ref;
        originalList = this.cacheList(id);
        oldLength = originalList.length;
        [].splice.apply(originalList, [0, originalList.length - 0].concat(_ref = [])), _ref;
        newLength = originalList.length;
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
      clearCache: function() {
        return this.constructor.clearCache(this.id);
      }
    };
    this.extend(Extend);
    return this.include(Include);
  }
};