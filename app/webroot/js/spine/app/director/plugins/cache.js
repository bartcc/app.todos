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
      cache: function(url) {
        var cached, item, _i, _len;
        cached = this.cacheList();
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
        return this.cache(url);
      },
      initCache: function(cached, url) {
        var o;
        o = new Object();
        o[url] = [];
        return cached.push(o);
      },
      addToCache: function(url, uris, mode) {
        var arr, cache, item, uri, _i, _j, _len, _len2, _ref;
        cache = this.cacheList();
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
        return cache;
      },
      destroyCache: function(id) {
        var findIdFromObject, findItemsFromArray, list;
        list = this.cacheList();
        findIdFromObject = function(id, obj) {
          var arr, idx, itm, key, value, _len, _results;
          _results = [];
          for (key in obj) {
            value = obj[key];
            arr = obj[key];
            for (idx = 0, _len = arr.length; idx < _len; idx++) {
              itm = arr[idx];
              if (itm[id]) {
                return arr.splice(idx, 1);
              }
            }
          }
          return _results;
        };
        findItemsFromArray = function(items) {
          var itm, ix, _len, _results;
          _results = [];
          for (ix = 0, _len = items.length; ix < _len; ix++) {
            itm = items[ix];
            _results.push(findIdFromObject(id, itm));
          }
          return _results;
        };
        return findItemsFromArray(list);
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
