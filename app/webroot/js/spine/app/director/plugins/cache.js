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
      cache: function(url, id) {
        var cached, item, key, val, _i, _len, _results;
        cached = this.cacheList(id);
        if (!cached) {
          return;
        }
        _results = [];
        for (_i = 0, _len = cached.length; _i < _len; _i++) {
          item = cached[_i];
          for (key in item) {
            val = item[key];
            if (item[url]) {
              return val;
            }
          }
        }
        return _results;
      },
      initCache: function(id) {
        var arr;
        arr = this.caches;
        arr.push(this.hash(id));
        return arr;
      },
      hash: function(key) {
        var o;
        o = new Object();
        o[key] = [];
        return o;
      },
      hasCache: function(url, id) {
        return !!(this.cache(url, id).length);
      },
      addToCache: function(url, uris) {
        var item, itm, itm_url, key, uri, val, _i, _len, _results;
        _results = [];
        for (_i = 0, _len = uris.length; _i < _len; _i++) {
          uri = uris[_i];
          _results.push((function() {
            var _results2;
            _results2 = [];
            for (key in uri) {
              val = uri[key];
              item = this.cacheList(key);
              if (!this.keyExists.call(item, url)) {
                item.push(this.hash(url));
              }
              _results2.push((function() {
                var _j, _len2, _ref, _results3;
                _results3 = [];
                for (_j = 0, _len2 = item.length; _j < _len2; _j++) {
                  itm = item[_j];
                  _results3.push((itm_url = itm[url]) ? (([].splice.apply(itm_url, [0, itm_url.length - 0].concat(_ref = [])), _ref), itm_url.push(uri)) : void 0);
                }
                return _results3;
              })());
            }
            return _results2;
          }).call(this));
        }
        return _results;
      },
      itemExists: function(item) {
        var key, thisItem, val, _i, _len;
        for (key in item) {
          val = item[key];
          for (_i = 0, _len = this.length; _i < _len; _i++) {
            thisItem = this[_i];
            if (thisItem[key]) {
              return thisItem;
            }
          }
        }
        return false;
      },
      keyExists: function(key) {
        var thisItem, _i, _len;
        for (_i = 0, _len = this.length; _i < _len; _i++) {
          thisItem = this[_i];
          if (thisItem[key]) {
            return thisItem;
          }
        }
        return false;
      },
      addToCache_: function(url, uris) {
        var cache, uri_, url_;
        cache = this.cacheList();
        url_ = function() {
          var item, urlObj, _i, _len;
          for (_i = 0, _len = cache.length; _i < _len; _i++) {
            item = cache[_i];
            if (item[url]) {
              return item[url];
            }
          }
          urlObj = {};
          urlObj[url] = [];
          cache.push(urlObj);
          return urlObj[url];
        };
        uri_ = function(arr) {
          var uri, _i, _len, _results;
          _results = [];
          for (_i = 0, _len = uris.length; _i < _len; _i++) {
            uri = uris[_i];
            _results.push(arr.push(uri));
          }
          return _results;
        };
        return uri_(url_());
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
