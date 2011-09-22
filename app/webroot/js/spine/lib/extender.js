var $, Model;
var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
if (typeof Spine !== "undefined" && Spine !== null) {
  Spine;
} else {
  Spine = require("spine");
};
$ = Spine.$;
Model = Spine.Model;
Model.Extender = {
  extended: function() {
    var extend, include;
    extend = {
      joinTableRecords: {},
      fromJSON: function(objects) {
        var json, key;
        this.joinTableRecords = this.createJoinTables(objects);
        json = this.__super__.constructor.fromJSON.call(this, objects);
        key = this.className;
        if (this.isArray(json)) {
          json = this.fromArray(json, key);
        }
        return json;
      },
      createJoinTables: function(arr) {
        var item, key, keys, res, table, _i, _j, _k, _len, _len2, _len3, _ref;
        if (!this.isArray(arr)) {
          return;
        }
        table = {};
        console.log(this.className);
        if (this.joinTables && this.joinTables.length) {
          keys = [];
          _ref = this.joinTables;
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            key = _ref[_i];
            keys.push(key);
          }
          for (_j = 0, _len2 = keys.length; _j < _len2; _j++) {
            key = keys[_j];
            res = this.introspectJSON(arr, key);
          }
          for (_k = 0, _len3 = res.length; _k < _len3; _k++) {
            item = res[_k];
            table[item.id] = item;
          }
        }
        return table;
      },
      fromArray: function(arr, key) {
        var extract, res, value, _i, _len;
        res = [];
        extract = __bind(function(val, key) {
          var item, itm;
          if (!this.isArray(val[key])) {
            item = __bind(function() {
              return new this(val[key]);
            }, this);
            itm = item();
            if (itm.id) {
              return res.push(itm);
            }
          }
        }, this);
        for (_i = 0, _len = arr.length; _i < _len; _i++) {
          value = arr[_i];
          extract(value, key);
        }
        return res;
      },
      introspectJSON: function(json, jointable) {
        var introspect, obj, res, _i, _len;
        res = [];
        introspect = __bind(function(obj) {
          var key, val, _i, _len, _results;
          if (this.isObject(obj)) {
            for (key in obj) {
              val = obj[key];
              if (key === jointable) {
                res.push(new window[jointable](obj[key]));
              } else {
                introspect(obj[key]);
              }
            }
          }
          if (this.isArray(obj)) {
            _results = [];
            for (_i = 0, _len = obj.length; _i < _len; _i++) {
              val = obj[_i];
              _results.push(introspect(val));
            }
            return _results;
          }
        }, this);
        for (_i = 0, _len = json.length; _i < _len; _i++) {
          obj = json[_i];
          introspect(obj);
        }
        return res;
      },
      isArray: function(value) {
        return Object.prototype.toString.call(value) === "[object Array]";
      },
      isObject: function(value) {
        return Object.prototype.toString.call(value) === "[object Object]";
      }
    };
    include = {
      updateChangedAttributes: function(atts) {
        var invalid, key, origAtts, value;
        origAtts = this.attributes();
        for (key in atts) {
          value = atts[key];
          if (origAtts[key] !== value) {
            invalid = true;
            this[key] = value;
          }
        }
        if (invalid) {
          return this.save();
        }
      }
    };
    this.extend(extend);
    return this.include(include);
  }
};