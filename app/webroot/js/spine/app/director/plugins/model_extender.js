var $, Model;
var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; }, __indexOf = Array.prototype.indexOf || function(item) {
  for (var i = 0, l = this.length; i < l; i++) {
    if (this[i] === item) return i;
  }
  return -1;
};
if (typeof Spine === "undefined" || Spine === null) {
  Spine = require("spine");
}
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
      current: function(recordOrID) {
        var id, prev, rec, same, _ref;
        rec = false;
        id = (recordOrID != null ? recordOrID.id : void 0) || recordOrID;
        if (this.exists(id)) {
          rec = this.find(id);
        }
        prev = this.record;
        this.record = rec;
        same = !!(((_ref = this.record) != null ? typeof _ref.eql === "function" ? _ref.eql(prev) : void 0 : void 0) && !!prev);
        Spine.trigger('change:selected' + this.className, this.record, !same);
        return this.record;
      },
      fromJSON: function(objects) {
        var json, key;
        this.createJoinTables(objects);
        key = this.className;
        if (this.isArray(objects)) {
          json = this.fromArray(objects, key);
        }
        return json || this.__super__.constructor.fromJSON.call(this, objects);
      },
      createJoinTables: function(arr) {
        var joinTables, key, _i, _len, _results;
        if (!this.isArray(arr)) {
          return;
        }
        joinTables = this.joinTables();
        _results = [];
        for (_i = 0, _len = joinTables.length; _i < _len; _i++) {
          key = joinTables[_i];
          _results.push(Spine.Model[key].refresh(this.createJoin(arr, key)));
        }
        return _results;
      },
      joinTables: function() {
        var fModels, joinTables, key, value;
        fModels = this.foreignModels();
        joinTables = (function() {
          var _results;
          _results = [];
          for (key in fModels) {
            value = fModels[key];
            _results.push(fModels[key]['joinTable']);
          }
          return _results;
        })();
        return joinTables;
      },
      fromArray: function(arr, key) {
        var extract, obj, res, _i, _len;
        res = [];
        extract = __bind(function(obj) {
          var item, itm;
          if (!this.isArray(obj[key])) {
            item = __bind(function() {
              return res.push(new this(obj[key]));
            }, this);
            return itm = item();
          }
        }, this);
        for (_i = 0, _len = arr.length; _i < _len; _i++) {
          obj = arr[_i];
          extract(obj);
        }
        return res;
      },
      createJoin: function(json, tableName) {
        var introspect, obj, res, _i, _len;
        res = [];
        introspect = __bind(function(obj) {
          var item, key, val, _i, _j, _len, _len2, _results;
          if (this.isObject(obj)) {
            for (key in obj) {
              val = obj[key];
              if (key === tableName) {
                for (_i = 0, _len = val.length; _i < _len; _i++) {
                  item = val[_i];
                  res.push(item);
                }
              } else {
                introspect(obj[key]);
              }
            }
          }
          if (this.isArray(obj)) {
            _results = [];
            for (_j = 0, _len2 = obj.length; _j < _len2; _j++) {
              val = obj[_j];
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
      createJoin_: function(json, tableName) {
        var introspect, obj, res, _i, _len;
        res = [];
        introspect = __bind(function(obj) {
          var key, val, _i, _len, _results;
          if (this.isObject(obj)) {
            for (key in obj) {
              val = obj[key];
              if (key === tableName) {
                res.push(obj[key]);
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
      selectionList: function(recordID) {
        var id, item, _i, _len, _ref, _ref2;
        id = recordID || ((_ref = this.record) != null ? _ref.id : void 0);
        if (!id) {
          return this.selection[0].global;
        }
        _ref2 = this.selection;
        for (_i = 0, _len = _ref2.length; _i < _len; _i++) {
          item = _ref2[_i];
          if (item[id]) {
            return item[id];
          }
        }
      },
      updateSelection: function(list, id) {
        return this.emptySelection(list, id);
      },
      emptySelection: function(list, id) {
        var originalList;
        if (list == null) {
          list = [];
        }
        originalList = this.selectionList(id);
        [].splice.apply(originalList, [0, originalList.length - 0].concat(list)), list;
        this.trigger('change:selection', originalList);
        return originalList;
      },
      removeFromSelection: function(id) {
        var index, list;
        list = this.selectionList();
        index = list.indexOf(id);
        if (index !== -1) {
          list.splice(index, 1);
        }
        return list;
      },
      isArray: function(value) {
        return Object.prototype.toString.call(value) === "[object Array]";
      },
      isObject: function(value) {
        return Object.prototype.toString.call(value) === "[object Object]";
      },
      selected: function() {
        return this.record;
      },
      toID: function(records) {
        var record, _i, _len, _results;
        if (records == null) {
          records = this.records;
        }
        _results = [];
        for (_i = 0, _len = records.length; _i < _len; _i++) {
          record = records[_i];
          _results.push(record.id);
        }
        return _results;
      },
      successHandler: function(data, status, xhr) {
        return console.log(data);
      },
      errorHandler: function(record, xhr, statusText, error) {
        var status;
        status = xhr.status;
        if (status !== 200) {
          error = new Error({
            record: record,
            xhr: xhr,
            statusText: statusText,
            error: error
          });
          error.save();
          User.redirect('users/login');
        }
        console.log(record);
        console.log(xhr);
        console.log(statusText);
        return console.log(error);
      },
      customErrorHandler: function(record, xhr) {
        var error, status;
        console.log(record);
        console.log(xhr);
        status = xhr.status;
        if (status !== 200) {
          error = new Error({
            flash: '<strong style="color:red">Login failed</strong>',
            xhr: xhr
          });
          error.save();
          return User.redirect('users/login');
        }
      },
      filterRelated: function(id, options) {
        var joinTableItems;
        joinTableItems = Spine.Model[options.joinTable].filter(id, options);
        return this.sort(this.filter(joinTableItems));
      },
      sort: function(arr) {
        return arr.sort(function(a, b) {
          var aInt, bInt;
          aInt = parseInt(a.order);
          bInt = parseInt(b.order);
          if (aInt < bInt) {
            return -1;
          } else if (aInt > bInt) {
            return 1;
          } else {
            return 0;
          }
        });
      }
    };
    Include = {
      updateSelection: function(list) {
        var model;
        model = this.constructor['parentSelector'];
        if (!this.constructor.isArray(list)) {
          list = [list];
        }
        return list = Spine.Model[model].updateSelection(list);
      },
      emptySelection: function() {
        var list, model;
        model = this.constructor['parentSelector'];
        return list = Spine.Model[model].emptySelection();
      },
      addRemoveSelection: function(isMetaKey) {
        var list, model, _ref;
        model = this.constructor['parentSelector'];
        list = (_ref = Spine.Model[model]) != null ? _ref.selectionList() : void 0;
        if (!list) {
          return;
        }
        if (!isMetaKey) {
          this.addUnique(list);
        } else {
          this.addRemove(list);
        }
        Spine.Model[model].trigger('change:selection', list);
        return list;
      },
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
      addUnique: function(list) {
        var _ref;
        [].splice.apply(list, [0, list.length - 0].concat(_ref = [this.id])), _ref;
        return list;
      },
      addRemove: function(list) {
        var index, _ref;
        if (_ref = this.id, __indexOf.call(list, _ref) < 0) {
          list.push(this.id);
        } else {
          index = list.indexOf(this.id);
          if (index !== -1) {
            list.splice(index, 1);
          }
        }
        return list;
      },
      allGalleryAlbums: __bind(function() {
        var albums, ga, gallery, gas, _i, _len;
        gallery = Gallery.record;
        if (!gallery) {
          return;
        }
        albums = [];
        gas = GalleriesAlbum.filter(gallery.id, {
          key: 'gallery_id'
        });
        for (_i = 0, _len = gas.length; _i < _len; _i++) {
          ga = gas[_i];
          if (Album.exists(ga.album_id)) {
            albums.push(Album.find(ga.album_id));
          }
        }
        return albums;
      }, this),
      allAlbumPhotos: __bind(function() {
        var album, ap, aps, photos, _i, _len;
        album = Album.record;
        if (!album) {
          return;
        }
        photos = [];
        aps = AlbumsPhoto.filter(album.id, {
          key: 'album_id'
        });
        for (_i = 0, _len = aps.length; _i < _len; _i++) {
          ap = aps[_i];
          if (Photo.exists(ap.album_id)) {
            photos.push(Photo.find(ap.album_id));
          }
        }
        return photos;
      }, this)
    };
    this.extend(Extend);
    return this.include(Include);
  }
};
