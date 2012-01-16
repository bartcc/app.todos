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
        var el, event, parentDataElement, _ref, _ref2, _ref3;
        console.log('Drag::dragstart');
        el = $(e.target);
        el.addClass('dragged');
        Spine.dragItem = {};
        Spine.dragItem.el = el;
        Spine.dragItem.source = el.item();
        parentDataElement = $(e.target).parents('.parent.data');
        Spine.dragItem.origin = ((_ref = parentDataElement.data()) != null ? (_ref2 = _ref.tmplItem) != null ? _ref2.data : void 0 : void 0) || ((_ref3 = parentDataElement.data()) != null ? _ref3.current.record : void 0);
        event = e.originalEvent;
        event.dataTransfer.effectAllowed = 'move';
        event.dataTransfer.setData('text/html', Spine.dragItem);
        return Spine.trigger('drag:start', e, this);
      }, this),
      dragenter: function(e, data) {
        var func;
        console.log('Drag::dragenter');
        func = function() {
          return Spine.trigger('drag:timeout', e);
        };
        clearTimeout(Spine.timer);
        Spine.timer = setTimeout(func, 1000);
        return Spine.trigger('drag:enter', e, this);
      },
      dragover: function(e, data) {
        var event;
        console.log('Drag::dragover');
        event = e.originalEvent;
        event.stopPropagation();
        event.dataTransfer.dropEffect = 'move';
        Spine.trigger('drag:over', e, this);
        return false;
      },
      dragleave: function(e, data) {
        console.log('Drag::dragleave');
        return Spine.trigger('drag:leave', e, this);
      },
      dragend: function(e, data) {
        console.log('Drag::dragend');
        return $(e.target).removeClass('dragged');
      },
      drop: __bind(function(e, data) {
        var event, _ref;
        console.log('Drag::drop');
        console.log(data);
        clearTimeout(Spine.timer);
        event = e.originalEvent;
        if ((_ref = Spine.dragItem) != null) {
          _ref.el.removeClass('dragged');
        }
        return Spine.trigger('drag:drop', e, data);
      }, this)
    };
    return this.include(Include);
  }
};