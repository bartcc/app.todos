var $, Model;
var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; }, __indexOf = Array.prototype.indexOf || function(item) {
  for (var i = 0, l = this.length; i < l; i++) {
    if (this[i] === item) return i;
  }
  return -1;
};
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
      record: false,
      selection: [
        {
          global: []
        }
      ],
      joinTableRecords: {},
      fromJSON: function(objects) {
        var json, key;
        this.joinTableRecords = this.createJoinTables(objects);
        key = this.className;
        if (this.isArray(objects)) {
          json = this.fromArray(objects, key);
        }
        return json || this.__super__.constructor.fromJSON.call(this, objects);
      },
      createJoinTables: function(arr) {
        var item, key, keys, res, table, _i, _j, _k, _len, _len2, _len3, _ref, _ref2;
        if (!this.isArray(arr)) {
          return;
        }
        table = {};
        console.log(this.className);
        if ((_ref = this.joinTables) != null ? _ref.length : void 0) {
          keys = [];
          _ref2 = this.joinTables;
          for (_i = 0, _len = _ref2.length; _i < _len; _i++) {
            key = _ref2[_i];
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
        extract = __bind(function(val) {
          var item, itm;
          if (!this.isArray(val[key])) {
            item = __bind(function() {
              var inst;
              inst = new this(val[key]);
              return res.push(inst);
            }, this);
            return itm = item();
          }
        }, this);
        for (_i = 0, _len = arr.length; _i < _len; _i++) {
          value = arr[_i];
          extract(value);
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
      selectionList: __bind(function() {
        var id, item, _i, _len, _ref;
        id = this.record.id;
        _ref = this.selection;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          item = _ref[_i];
          if (item[id]) {
            return item[id];
          }
        }
        return this.selection[0].global;
      }, this),
      isArray: function(value) {
        return Object.prototype.toString.call(value) === "[object Array]";
      },
      isObject: function(value) {
        return Object.prototype.toString.call(value) === "[object Object]";
      },
      current: function(record) {
        var rec;
        rec = false;
        if (this.exists(record != null ? record.id : void 0)) {
          rec = this.find(record.id);
        }
        this.record = rec;
        return this.record || false;
      },
      selected: function() {
        return this.record;
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
      },
      addToSelection: function(model, isMetaKey) {
        var list;
        list = model.selectionList();
        if (!list) {
          return;
        }
        if (!isMetaKey) {
          this.addUnique(model, list);
        } else {
          this.addRemove(model, list);
        }
        return list;
      },
      addUnique: function(model, list) {
        var _ref;
        return ([].splice.apply(list, [0, list.length - 0].concat(_ref = [this.id])), _ref);
      },
      addRemove: function(model, list) {
        var index, _ref;
        if (_ref = this.id, __indexOf.call(list, _ref) < 0) {
          list.push(this.id);
        } else {
          index = list.indexOf(this.id);
          list.splice(index, 1);
        }
        return list;
      }
    };
    this.extend(extend);
    return this.include(include);
  }
};