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
      autodim: -> 500
      disabled: true
      axis: 'x'
      min: 20
      max: -> 500
      handle: '.draghandle'
    options = $.extend({}, defaults, opts)
    ori = if options.axis is 'y' then 'top' else 'left'
    dim = if options.axis is 'y' then 'height' else 'width'
    rev = if options.axis is 'y' then 1 else -1
    max = (options.max.call @)
    min = (options.min)
    el.draggable
      create: (e, ui) =>
        @el.css({position: 'inherit'})
        @disableDrag() if options.disabled
        @currentDim = options.autodim.call @
      axis: options.axis
      handle: options.handle
      start: (e, ui) =>
        @currentDim = $(ui.helper)[dim]()
      drag: (e, ui) =>
        _ori = ui.originalPosition[ori]
        _pos = ui.position[ori]
        _cur = @currentDim
        $(ui.helper)[dim] ->
          d = (_cur+_ori)-(_pos*rev)
          if d >= min and d <= max
            return d
          if d < min
            return min
          if d > max
            return max
          return d
      stop: (e, ui) =>
        @currentDim = $(ui.helper)[dim]()

Spine.Manager.extend
  notify: (t) ->
    #alert(t)