$.fn.sortable = (type) ->
  $(@).Html5Sortable
    type: type
    drop: (source, target) -> return true

$.Html5Sortable = ->
    $.Html5Sortable.s_currentID = Math.floor(Math.random()*10000001)

  $.Html5Sortable.DRAGANDDROP_DEFAULT_TYPE = "fr.marcbuils.html5sortable"
  
  $.Html5Sortable.s_currentID = 0
    
  $.Html5Sortable.defaultOptions =
    dragTarget:   (source) -> $(source)
    text:         (source) -> $('<div></div>').append($(source).clone(true)).html()
    css:       (source) ->
      el = ($(source).prev('li') or $(source).next('li'))
      'height'        : el.css 'height'
#      'width'         : el.css 'width'
#      'padding-right' : el.css 'padding-right'
#      'margin-right'  : el.css 'margin-right'
#      'padding-left'  : el.css 'padding-left'
#      'margin-left'   : el.css 'margin-left'
      'padding-top'   : el.css 'padding-top'
      'padding-bottom': el.css 'padding-bottom'
      'margin-top'    : el.css 'margin-top'
      'margin-bottom' : el.css 'margin-bottom'
    klass:          (source) -> 'html5sortable-state-highlight'
    splitter:     (source) -> ($($('li.'+@klass())[0] or $('<li class="'+@klass()+'"></li>'))).css @css source
    type:         $.Html5Sortable.DRAGANDDROP_DEFAULT_TYPE,
    drop:         (source, target) -> false;

$.fn.Html5Sortable = (opts) ->
  options = $.extend {}, $.Html5Sortable.defaultOptions, opts

  # Set current ID
  $.Html5Sortable.s_currentID++
  
  # specific type
  if options.type is $.Html5Sortable.DRAGANDDROP_DEFAULT_TYPE
    options.type = options.type + '_' + $.Html5Sortable.s_currentID

  @each ->
    that = $(@)
    that.init = (el) ->
      options.dragTarget(el).attr('draggable', true)
      .bind 'dragstart', (e) ->
        dt = e.originalEvent.dataTransfer
        dt.effectAllowed = 'move'
        Spine.sortItem = {}
        Spine.sortItem.data = el.data()
        Spine.sortItem.dataTransfer = dt
        Spine.sortItem.splitter = options.splitter(@)

        Spine.sortItem.dataTransfer.setData "Text", JSON.stringify
          html:   options.text(el)
          type:   options.type

        # dt.setData("URL", options.type);
        $('._dragging').removeClass('_dragging')
        el.addClass('_dragging')
        
        Spine.trigger('drag:start', e, @)
#        return true

      .bind 'dragend', (e) ->
        $('._dragging').removeClass('_dragging')

        try
          unless (JSON.parse(Spine.sortItem.dataTransfer.getData("Text")).type is options.type)
            return true
        catch e
          return true
          
        Spine.sortItem.splitter.remove()

      .bind 'dragenter', (e) ->
        try
          unless (Spine.sortItem.dataTransfer.getData("Text") and JSON.parse(Spine.sortItem.dataTransfer.getData("Text")).type is options.type)
            return true
        catch e
          return true
          
          
        if (e.pageY - $(this).position().top > $(@).height())
          Spine.sortItem.splitter.insertAfter @
        else
          Spine.sortItem.splitter.insertBefore @
          
        Spine.trigger('drag:enter', e, @)

      .bind 'dragleave', (e) ->
        try
          unless (Spine.sortItem.dataTransfer.getData("Text") and JSON.parse(Spine.sortItem.dataTransfer.getData("Text")).type is options.type)
            return true;
        catch e
          return true
        
        Spine.trigger('drag:leave', e, @)

      .bind 'drop', (e) ->
        try
          unless (JSON.parse(Spine.sortItem.dataTransfer.getData("Text")).type is options.type)
            return true
        catch e
          return true
          
        sourceEl = $('._dragging')
        Spine.sortItem.splitter.remove()

        it = $(JSON.parse(Spine.sortItem.dataTransfer.getData('Text')).html).hide()
        it.data Spine.sortItem.data

        if (e.pageY - $(@).position().top > $(@).height())
          it.insertAfter @
        else
          it.insertBefore @

        that.init it
        
        # data not saved
        if !options.drop(sourceEl.get(0), it.get(0))
          it.remove()

        sourceEl.remove()
        it.fadeIn()

        Spine.trigger('drag:drop', e, @)

      .bind 'dragover_', (e) ->
        try
          unless (e.originalEvent.dataTransfer.getData("Text") and JSON.parse(e.originalEvent.dataTransfer.getData("Text")).type is options.type)
            return true
        catch e
          return true

        Spine.sortItem.splitter.remove()

        if (e.pageY - $(this).position().top > $(@).height())
          Spine.sortItem.splitter.insertAfter @
        else
          Spine.sortItem.splitter.insertBefore @

        Spine.trigger('drag:over_', e, @)
        return false
        
    that.children('li').each ->
        that.init $(@)