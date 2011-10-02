var $, Model, Request;
var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; }, __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
if (typeof Spine !== "undefined" && Spine !== null) {
  Spine;
} else {
  Spine = require("spine");
};
$ = Spine.$;
Model = Spine.Model;
Request = (function() {
  __extends(Request, Base);
  function Request(record) {
    this.record = record;
    this.errorResponse = __bind(this.errorResponse, this);
    this.blankResponse = __bind(this.blankResponse, this);
    this.recordResponse = __bind(this.recordResponse, this);
    this.data = {};
    this.model = this.record.constructor;
    this.foreignModel = Spine.Model[this.model.foreignModel];
    this.joinTable = Spine.Model[this.model.joinTable];
    this.associationForeignKey = this.model.associationForeignKey;
    this.foreignKey = this.model.foreignKey;
    if (this.foreignModel && this.foreignModel.record) {
      this.data[this.foreignModel.className] = this.foreignModel.record;
    }
    this.data[this.model.className] = this.record;
  }
  Request.prototype.find = function(params) {
    return this.ajax(params, {
      type: "GET",
      url: this.url
    });
  };
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
    var data, ids, item, list;
    if (this.joinTable) {
      data = {};
      list = this.joinTable.findAllByAttribute(this.foreignKey, this.model.record.id);
      ids = (function() {
        var _i, _len, _results;
        _results = [];
        for (_i = 0, _len = list.length; _i < _len; _i++) {
          item = list[_i];
          _results.push(item[this.associationForeignKey]);
        }
        return _results;
      }).call(this);
      data[this.foreignModel.className] = ids;
      this.data[this.foreignModel.className] = data;
    }
    return this.queue(__bind(function() {
      return this.ajax(params, {
        type: "PUT",
        data: JSON.stringify(this.data),
        url: Ajax.getURL(this.record)
      }).success(this.recordResponse).error(this.errorResponse);
    }, this));
  };
  Request.prototype.destroy = function(params) {
    return this.queue(__bind(function() {
      return this.ajax(params, {
        type: "DELETE",
        url: Ajax.getURL(this.record)
      }).success(this.recordResponse).error(this.errorResponse);
    }, this));
  };
  Request.prototype.recordResponse = function(data, status, xhr) {
    this.record.trigger("ajaxSuccess", this.record, status, xhr);
    if (Spine.isBlank(data)) {
      return;
    }
    data = this.model.fromJSON(data);
    return Ajax.disable(__bind(function() {
      if (data.id && this.record.id !== data.id) {
        this.record.changeID(data.id);
      }
      return this.record.updateAttributes(data.attributes());
    }, this));
  };
  Request.prototype.blankResponse = function(data, status, xhr) {
    return this.record.trigger("ajaxSuccess", this.record, status, xhr);
  };
  Request.prototype.errorResponse = function(xhr, statusText, error) {
    return this.record.trigger("ajaxError", this.record, xhr, statusText, error);
  };
  return Request;
})();
Model.AjaxExtender = {
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