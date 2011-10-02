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
    var Extend, Include;
    Extend = {
      record: false,
      selection: [
        {
          global: []
        }
      ],
      joinTableRecords: {},
      fromJSON: function(objects) {
        var json, key;
        this.joinTableRecords = this.createJoinTable(objects);
        key = this.className;
        if (this.isArray(objects)) {
          json = this.fromArray(objects, key);
        }
        return json || this.__super__.constructor.fromJSON.call(this, objects);
      },
      createJoinTable: function(arr) {
        var item, res, table, _i, _len;
        console.log('ModelExtender::createJoinTable');
        if (!this.joinTable) {
          return;
        }
        table = {};
        res = this.introspectJSON(arr, this.joinTable);
        for (_i = 0, _len = res.length; _i < _len; _i++) {
          item = res[_i];
          table[item.id] = item;
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
      emptyList: function() {
        var list, _ref;
        list = this.selectionList();
        [].splice.apply(list, [0, list.length - 0].concat(_ref = [])), _ref;
        return list;
      },
      removeFromList: function(id) {
        var album;
        album = Album.find(id);
        return album.addRemoveSelection(this, true);
      },
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
    Include = {
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
      addRemoveSelection: function(model, isMetaKey) {
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
    this.extend(Extend);
    return this.include(Include);
  }
};