var $, Controller;
var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
if (typeof Spine !== "undefined" && Spine !== null) {
  Spine;
} else {
  Spine = require("spine");
};
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
        var el, event, target;
        el = $(e.target);
        target = el.item();
        el.addClass('dragged');
        Spine.dragItem = {};
        Spine.dragItem.source = el.item();
        event = e.originalEvent;
        event.dataTransfer.setData('text/html', Spine.dragItem);
        return Spine.trigger('drag:start', e);
      }, this),
      dragenter: function(e, data) {
        $(e.target).addClass('over');
        return Spine.trigger('drag:enter', e);
      },
      dragover: function(e, data) {
        var event;
        event = e.originalEvent;
        if (event.stopPropagation) {
          event.stopPropagation();
        }
        event.dataTransfer.dropEffect = 'move';
        Spine.trigger('drag:over', e);
        return false;
      },
      dragleave: function(e, data) {
        var el, target;
        el = $(e.target);
        target = el.item();
        el.removeClass('over');
        return Spine.trigger('drag:leave', e);
      },
      dragend: function(e, data) {
        return $(e.target).removeClass('dragged');
      },
      drop: __bind(function(e) {
        var el, event, target;
        el = $(e.target);
        target = el.item();
        event = e.originalEvent;
        if (event.stopPropagation) {
          event.stopPropagation();
        }
        el.removeClass('over');
        Spine.trigger('drag:drop', target, e);
        Spine.dragItem = null;
        return false;
      }, this)
    };
    return this.include(Include);
  }
};