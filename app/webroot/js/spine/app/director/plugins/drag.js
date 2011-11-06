var $, Controller;
var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
if (typeof Spine === "undefined" || Spine === null) {
  Spine = require("spine");
}
$ = Spine.$;
Controller = Spine.Controller;
Controller.Drag = {
  extended: function() {
    var Include;
    Include = {
      init: function() {
        return Spine.dragItem = null;
      },
      dragstart: __bind(function(e, data) {
        var el, event, parentDataElement, _ref;
        el = $(e.target);
        el.addClass('dragged');
        Spine.dragItem = {};
        Spine.dragItem.source = el.item();
        parentDataElement = $(e.target).parents('.data');
        Spine.dragItem.origin = ((_ref = parentDataElement.data().tmplItem) != null ? _ref.data : void 0) || parentDataElement.data();
        event = e.originalEvent;
        event.dataTransfer.effectAllowed = 'move';
        event.dataTransfer.setData('text/html', Spine.dragItem);
        return Spine.trigger('drag:start', e, this);
      }, this),
      dragenter: function(e, data) {
        var func;
        func = function() {
          return Spine.trigger('drag:timeout', e);
        };
        clearTimeout(Spine.timer);
        Spine.timer = setTimeout(func, 1000);
        return Spine.trigger('drag:enter', e, this);
      },
      dragover: function(e, data) {
        var event;
        event = e.originalEvent;
        if (event.stopPropagation) {
          event.stopPropagation();
        }
        event.dataTransfer.dropEffect = 'move';
        Spine.trigger('drag:over', e, this);
        return false;
      },
      dragleave: function(e, data) {
        return Spine.trigger('drag:leave', e, this);
      },
      dragend: function(e, data) {
        return $(e.target).removeClass('dragged');
      },
      drop: __bind(function(e) {
        var el, event, target;
        clearTimeout(Spine.timer);
        el = $(e.target);
        target = el.item();
        event = e.originalEvent;
        if (event.stopPropagation) {
          event.stopPropagation();
        }
        el.removeClass('over nodrop');
        Spine.trigger('drag:drop', target, e);
        Spine.dragItem = null;
        return false;
      }, this)
    };
    return this.include(Include);
  }
};