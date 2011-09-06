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
        _max = options.max.call @
        $(ui.helper)[dim] ->
          d = (_cur+_ori)-(_pos*rev)
          if d >= min and d <= _max
            return d
          if d < min
            return min
          if d > _max
            return _max
      stop: (e, ui) =>
        @currentDim = $(ui.helper)[dim]()

Spine.Manager.extend
  notify: (t) ->
    #alert(t)