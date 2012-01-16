var $, Controller;
var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
if (typeof Spine === "undefined" || Spine === null) {
  Spine = require("spine");
}
$ = Spine.$;
Controller = Spine.Controller;
Controller.Sort = {
  extended: function() {
    var Include;
    Include = {
      init: function() {
        return Spine.sortItem = null;
      },
      sortstart: function(e) {
        var dt;
        dt = e.originalEvent.dataTransfer;
        dt.setData("Text", JSON.stringify({
          html: options.text(item),
          type: options.type
        }));
        $('._dragging').removeClass('_dragging');
        item.addClass('_dragging');
        Spine.trigger('sort:dragstart', e, this);
        return true;
      },
      sortend: function(e) {
        $('._dragging').removeClass('_dragging');
        $('li.' + options.css).remove();
        try {
          if (!(JSON.parse(e.originalEvent.dataTransfer.getData("Text")).type === options.type)) {
            return true;
          }
        } catch (e) {
          return true;
        }
        return false;
      },
      sortenter: function(e) {
        try {
          if (!(e.originalEvent.dataTransfer.getData("Text") && JSON.parse(e.originalEvent.dataTransfer.getData("Text")).type === options.type)) {
            return true;
          }
        } catch (e) {
          return true;
        }
        Spine.trigger('sort:dragenter', e, this);
        return false;
      },
      sortleave: function(e) {
        try {
          if (!(e.originalEvent.dataTransfer.getData("Text") && JSON.parse(e.originalEvent.dataTransfer.getData("Text")).type === options.type)) {
            return true;
          }
        } catch (e) {
          return true;
        }
        $('li.' + options.css).remove();
        Spine.trigger('sort:dragleave', e, this);
        return false;
      },
      sort: function(e, data) {
        var it, source;
        try {
          if (!(JSON.parse(e.originalEvent.dataTransfer.getData("Text")).type === options.type)) {
            return true;
          }
        } catch (e) {
          return true;
        }
        source = $('._dragging');
        $('li.' + options.css).remove();
        it = $(JSON.parse(e.originalEvent.dataTransfer.getData('Text')).html).hide();
        if (e.pageY - $(this).position().top > $(this).height()) {
          it.insertAfter(this);
        } else {
          it.insertBefore(this);
        }
        if (!options.drop($src.get(0), it.get(0))) {
          it.remove();
          return false;
        }
        source.remove();
        it.fadeIn();
        Spine.trigger('sort:drop', e, this);
        return false;
      },
      sortover: function(e, data) {
        try {
          if (!(e.originalEvent.dataTransfer.getData("Text") && JSON.parse(e.originalEvent.dataTransfer.getData("Text")).type === options.type)) {
            return true;
          }
        } catch (e) {
          return true;
        }
        $('li.' + options.css).remove();
        if (e.pageY - $(this).position().top > $(this).height()) {
          $('<li class="' + options.css + '"></li>').insertAfter(this);
        } else {
          $('<li class="' + options.css + '"></li>').insertBefore(this);
        }
        Spine.trigger('sort:dragover', e, this);
        return false;
      },
      initSortItem_: function(item, options) {
        return options.drag_target(item).attr('draggable', true).bind('dragstart', function(e) {
          var dt;
          dt = e.originalEvent.dataTransfer;
          dt.setData("Text", JSON.stringify({
            html: options.text(item),
            type: options.type
          }));
          $('._dragging').removeClass('_dragging');
          item.addClass('_dragging');
          return true;
        }).bind('dragend', function(e) {
          $('._dragging').removeClass('_dragging');
          $('li.' + options.css).remove();
          try {
            if (!(JSON.parse(e.originalEvent.dataTransfer.getData("Text")).type === options.type)) {
              return true;
            }
          } catch (e) {
            return true;
          }
          return false;
        }).bind('dragenter', function(e) {
          try {
            if (!(e.originalEvent.dataTransfer.getData("Text") && JSON.parse(e.originalEvent.dataTransfer.getData("Text")).type === options.type)) {
              return true;
            }
          } catch (e) {
            return true;
          }
          return false;
        }).bind('dragleave', function(e) {
          try {
            if (!(e.originalEvent.dataTransfer.getData("Text") && JSON.parse(e.originalEvent.dataTransfer.getData("Text")).type === options.type)) {
              return true;
            }
          } catch (e) {
            return true;
          }
          $('li.' + options.css).remove();
          return false;
        }).bind('drop', function(e) {
          var it, source;
          try {
            if (!(JSON.parse(e.originalEvent.dataTransfer.getData("Text")).type === options.type)) {
              return true;
            }
          } catch (e) {
            return true;
          }
          source = $('._dragging');
          $('li.' + options.css).remove();
          it = $(JSON.parse(e.originalEvent.dataTransfer.getData('Text')).html).hide();
          if (e.pageY - $(this).position().top > $(this).height()) {
            it.insertAfter(this);
          } else {
            it.insertBefore(this);
          }
          _initItem(it);
          if (!options.drop($src.get(0), $item.get(0))) {
            it.remove();
            return false;
          }
          source.remove();
          it.fadeIn();
          return false;
        }).bind('dragover', function(e) {
          try {
            if (!(e.originalEvent.dataTransfer.getData("Text") && JSON.parse(e.originalEvent.dataTransfer.getData("Text")).type === options.type)) {
              return true;
            }
          } catch (e) {
            return true;
          }
          $('li.' + options.css).remove();
          if (e.pageY - $(this).position().top > $(this).height()) {
            $('<li class="' + options.css + '"></li>').insertAfter(this);
          } else {
            $('<li class="' + options.css + '"></li>').insertBefore(this);
          }
          return false;
        });
      },
      dragstart: __bind(function(e, data) {
        var el, event, parentDataElement, _ref, _ref2, _ref3;
        console.log('Sort::sortstart');
        el = $(e.target);
        el.addClass('dragged');
        Spine.sortItem = {};
        Spine.sortItem.el = el;
        Spine.sortItem.source = el.item();
        parentDataElement = $(e.target).parents('.data');
        Spine.sortItem.origin = ((_ref = parentDataElement.data()) != null ? (_ref2 = _ref.tmplItem) != null ? _ref2.data : void 0 : void 0) || ((_ref3 = parentDataElement.data()) != null ? _ref3.current.record : void 0);
        event = e.originalEvent;
        event.dataTransfer.effectAllowed = 'move';
        event.dataTransfer.setData('text/html', Spine.sortItem);
        return Spine.trigger('sort:start', e, this);
      }, this),
      dragenter: function(e, data) {
        var func;
        console.log('Sort::dragenter');
        func = function() {
          return Spine.trigger('sort:timeout', e);
        };
        clearTimeout(Spine.timer);
        Spine.timer = setTimeout(func, 1000);
        return Spine.trigger('sort:enter', e, this);
      },
      dragover: function(e, data) {
        var event;
        console.log('Sort::dragover');
        event = e.originalEvent;
        event.stopPropagation();
        event.dataTransfer.dropEffect = 'move';
        Spine.trigger('sort:over', e, this);
        return false;
      },
      dragleave: function(e, data) {
        console.log('Sort::dragleave');
        return Spine.trigger('sort:leave', e, this);
      },
      dragend: function(e, data) {
        console.log('Sort::dragend');
        return $(e.target).removeClass('dragged');
      },
      drop: __bind(function(e, data) {
        var event, _ref;
        console.log('Sort::drop');
        console.log(data);
        clearTimeout(Spine.timer);
        event = e.originalEvent;
        if ((_ref = Spine.sortItem) != null) {
          _ref.el.removeClass('dragged');
        }
        return Spine.trigger('sort:drop', e, this);
      }, this)
    };
    return this.include(Include);
  }
};