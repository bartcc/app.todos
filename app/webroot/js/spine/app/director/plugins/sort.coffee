$.fn.sortable = (type) ->
  $(@).Html5Sortable
    type: type
    drop: (source, target) -> return true

$.Html5Sortable = ->
    $.Html5Sortable.s_currentID = Math.floor(Math.random()*10000001)

  $.Html5Sortable.DRAGANDDROP_DEFAULT_TYPE = "de.webpremiere.html5sortable"
  
  $.Html5Sortable.s_currentID = 0
    
  $.Html5Sortable.defaultOptions =
    dragTarget:   (source) -> $(source)
    text:         (source) -> $('<div></div>').append($(source).clone(true)).html()
    css:       (source) ->
      el = ($(source).prev('li') or $(source).next('li'))
      'height'        : el.css 'height'
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
        dt.setData 'Text', JSON.stringify
          html:   options.text(el)
          type:   options.type
        Spine.sortItem = {}
        Spine.sortItem.data = el.data()
        Spine.sortItem.splitter = options.splitter(@)
        # dt.setData("URL", options.type);
        $('._dragging').removeClass('_dragging out')
        el.addClass('_dragging out')
        
#        Spine.trigger('drag:start', e, @)

      .bind 'dragend', (e) ->
        $('._dragging').removeClass('_dragging')
        
        try
          unless (JSON.parse(e.originalEvent.dataTransfer.getData('Text')).type is options.type)
            return true
        catch e
          return true
          
        Spine.sortItem.splitter.remove()

      .bind 'dragenter', (e) ->
        if (e.pageY - $(@).position().top > $(@).height())
          Spine.sortItem.splitter.insertAfter @
        else
          Spine.sortItem.splitter.insertBefore @
          
        return false

      .bind 'dragleave', (e) ->
        try
          unless (e.originalEvent.dataTransfer.getData('Text') and JSON.parse(e.originalEvent.dataTransfer.getData('Text')).type is options.type)
            return true;
        catch e
          return true
        
        return false

      .bind 'drop', (e) ->
        console.log 'Sort::drop'
#        try
#          unless (JSON.parse(e.originalEvent.dataTransfer.getData('Text')).type is options.type)
#            return true
#        catch e
#          return true
          
        sourceEl = $('._dragging')
        Spine.sortItem.splitter.remove()
        
#        e.stopPropagation()
#        e.preventDefault()

        it = $(JSON.parse(e.originalEvent.dataTransfer.getData('Text')).html).fadeOut 1000, ->
          sourceEl.remove()
          
          
        it.data Spine.sortItem.data
        model = $(it).item().constructor.className

        if (e.pageY - $(@).position().top > $(@).height())
          it.insertAfter @
        else
          it.insertBefore @

        that.init it
        
        # data not saved
        if !options.drop(sourceEl.get(0), it.get(0))
          it.remove()

        it.fadeIn 1000
        
        Spine.Model[model].trigger('sortupdate', e, it)
#        Spine.trigger('drag:drop', e, it) # Why isn't it bubbeling up? Remove this line when it does!
        
    that.children('li').each ->
        that.init $(@)