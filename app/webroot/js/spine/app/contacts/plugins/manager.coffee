Spine ?= require("spine")
$      = Spine.$

Spine.Manager.include
  disableDrag: ->
    @el.draggable('disable')
  enableDrag: ->
    @el.draggable('enable')
  alive: (el, opts) ->
    return unless el
    @el = el
    defaults =
      height: -> 500
      axis: 'x'
      min: 200
      max: -> 500
      handle: '.draghandle'
    options = $.extend({}, defaults, opts)
    ori = if options.axis is 'y' then 'top' else 'left'
    dim = if options.axis is 'y' then 'height' else 'width'
    max = options.max.call @
    min = options.min
    el.draggable
      create: (e, ui) =>
        @el.css({position: 'inherit'})
        @disableDrag()
        @currentDim = options.height.call @
      axis: options.axis
      handle: options.handle
      start: (e, ui) =>
        @currentDim = $(ui.helper)[dim]()
      drag: (e, ui) =>
        _ori = ui.originalPosition[ori]
        _pos = ui.position[ori]
        _cur = @currentDim
        $(ui.helper)[dim] ->
          h = _cur-_pos+_ori
          if h >= min and h <= max
            return h
          if h < min
            return min
          if h > max
            return max
      stop: (e, ui) =>
        @currentDim = $(ui.helper)[dim]()

Spine.Manager.extend
  notify: (t) ->
    #alert(t)