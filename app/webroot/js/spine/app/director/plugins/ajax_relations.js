var $, Builder, Model, Request;
var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
}, __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
if (typeof Spine === "undefined" || Spine === null) {
  Spine = require("spine");
}
$ = Spine.$;
Model = Spine.Model;
Builder = (function() {
  function Builder(record) {
    this.data = {};
    this.record = record;
    this.model = record.constructor;
    this.foreignModels = this.model.foreignModels();
  }
  Builder.prototype.newWrapper = function(key) {
    var data;
    if (!key.className) {
      throw 'No classname found';
    }
    data = {};
    data[key.className] = {};
    return data;
  };
  Builder.prototype.build = function() {
    var key, model, records, selected, value, _i, _len, _ref;
    this.fModels = (function() {
      var _ref, _results;
      _ref = this.foreignModels;
      _results = [];
      for (key in _ref) {
        value = _ref[key];
        _results.push(this.foreignModels[key]);
      }
      return _results;
    }).call(this);
    _ref = this.fModels;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      key = _ref[_i];
      model = Spine.Model[key.className];
      records = model.filter(this.record.id);
      selected = this.newWrapper(model);
      selected[model.className] = this.model.toID(records);
      this.data[model.className] = selected;
    }
    this.data[this.model.className] = this.record;
    return this.data;
  };
  return Builder;
})();
Request = (function() {
  __extends(Request, Spine.Singleton);
  function Request(record) {
    this.record = record;
    Request.__super__.constructor.apply(this, arguments);
    this.data = new Builder(this.record).build();
  }
  Request.prototype.create = function(params) {
    return this.queue(__bind(function() {
      return this.ajax(params, {
        type: "POST",
        data: JSON.stringify(this.data),
        url: Ajax.getURL(this.model)
      }).success(this.recordResponse).error(this.errorResponse);
    }, this));
  };
  Request.prototype.update = function(params) {
    return this.queue(__bind(function() {
      return this.ajax(params, {
        type: "PUT",
        data: JSON.stringify(this.data),
        url: Ajax.getURL(this.record)
      }).success(this.recordResponse).error(this.errorResponse);
    }, this));
  };
  return Request;
})();
Model.AjaxRelations = {
  extended: function() {
    var Include;
    Include = {
      ajax: function() {
        return new Request(this);
      }
    };
    return this.include(Include);
  }
};
Spine.Builder = Builder;