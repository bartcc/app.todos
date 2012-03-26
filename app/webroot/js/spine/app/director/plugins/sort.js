$.fn.sortable = function(type) {
  return $(this).Html5Sortable({
    type: type,
    drop: function(source, target) {
      return true;
    }
  });
};
$.Html5Sortable = function() {
  return $.Html5Sortable.s_currentID = Math.floor(Math.random() * 10000001);
};
$.Html5Sortable.DRAGANDDROP_DEFAULT_TYPE = "de.webpremiere.html5sortable";
$.Html5Sortable.s_currentID = 0;
$.Html5Sortable.defaultOptions = {
  dragTarget: function(source) {
    return $(source);
  },
  text: function(source) {
    return $('<div></div>').append($(source).clone(true)).html();
  },
  css: function(source) {
    var el;
    el = $(source).prev('li') || $(source).next('li');
    return {
      'height': el.css('height'),
      'padding-top': el.css('padding-top'),
      'padding-bottom': el.css('padding-bottom'),
      'margin-top': el.css('margin-top'),
      'margin-bottom': el.css('margin-bottom')
    };
  },
  klass: function(source) {
    return 'html5sortable-state-highlight';
  },
  splitter: function(source) {
    return ($($('li.' + this.klass())[0] || $('<li class="' + this.klass() + '"></li>'))).css(this.css(source));
  },
  type: $.Html5Sortable.DRAGANDDROP_DEFAULT_TYPE,
  drop: function(source, target) {
    return false;
  }
};
$.fn.Html5Sortable = function(opts) {
  var options;
  options = $.extend({}, $.Html5Sortable.defaultOptions, opts);
  $.Html5Sortable.s_currentID++;
  if (options.type === $.Html5Sortable.DRAGANDDROP_DEFAULT_TYPE) {
    options.type = options.type + '_' + $.Html5Sortable.s_currentID;
  }
  return this.each(function() {
    var that;
    that = $(this);
    that.init = function(el) {
      return options.dragTarget(el).attr('draggable', true).bind('dragstart', function(e) {
        var dt;
        dt = e.originalEvent.dataTransfer;
        dt.effectAllowed = 'move';
        dt.setData('Text', JSON.stringify({
          html: options.text(el),
          type: options.type
        }));
        Spine.sortItem = {};
        Spine.sortItem.data = el.data();
        Spine.sortItem.splitter = options.splitter(this);
        $('._dragging').removeClass('_dragging out');
        return el.addClass('_dragging out');
      }).bind('dragend', function(e) {
        $('._dragging').removeClass('_dragging');
        try {
          if (!(JSON.parse(e.originalEvent.dataTransfer.getData('Text')).type === options.type)) {
            return true;
          }
        } catch (e) {
          return true;
        }
        return Spine.sortItem.splitter.remove();
      }).bind('dragenter', function(e) {
        if (e.pageY - $(this).position().top > $(this).height()) {
          Spine.sortItem.splitter.insertAfter(this);
        } else {
          Spine.sortItem.splitter.insertBefore(this);
        }
        return false;
      }).bind('dragleave', function(e) {
        try {
          if (!(e.originalEvent.dataTransfer.getData('Text') && JSON.parse(e.originalEvent.dataTransfer.getData('Text')).type === options.type)) {
            return true;
          }
        } catch (e) {
          return true;
        }
        return false;
      }).bind('drop', function(e) {
        var it, model, sourceEl;
        console.log('Sort::drop');
        sourceEl = $('._dragging');
        Spine.sortItem.splitter.remove();
        it = $(JSON.parse(e.originalEvent.dataTransfer.getData('Text')).html).fadeOut(1000, function() {
          return sourceEl.remove();
        });
        it.data(Spine.sortItem.data);
        model = $(it).item().constructor.className;
        if (e.pageY - $(this).position().top > $(this).height()) {
          it.insertAfter(this);
        } else {
          it.insertBefore(this);
        }
        that.init(it);
        if (!options.drop(sourceEl.get(0), it.get(0))) {
          it.remove();
        }
        it.fadeIn(1000);
        return Spine.Model[model].trigger('sortupdate', e, it);
      });
    };
    return that.children('li').each(function() {
      return that.init($(this));
    });
  });
};
