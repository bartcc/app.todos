Spine ?= require("spine")
$      = Spine.$

Spine.Manager.include
  disableDrag: ->
    @el.draggable('disable')
    not @el.draggable("option", "disabled")
  enableDrag: ->
    @el.draggable('enable')
    not @el.draggable("option", "disabled")
  initDrag: (el, opts) ->
    return unless el
    @el = el
    defaults =
      initSize: -> 500
      disabled: true
      axis: 'x'
      min: 20
      max: -> 300
      handle: '.draghandle'
      goSleep: ->
      awake: ->
    options = $.extend({}, defaults, opts)
    ori = if options.axis is 'y' then 'top' else 'left'
    dim = if options.axis is 'y' then 'height' else 'width'
    rev = if options.axis is 'y' then 1 else -1
    min = (options.min)
    max = (options.max)
    el.draggable
      create: (e, ui) =>
        @el.css({position: 'inherit'})
        @disableDrag() if options.disabled
        @currentDim = options.initSize.call @
        @goSleep = options.goSleep
        @awake = options.awake
        @min = min
        @max = max
      axis: options.axis
      handle: options.handle
      start: (e, ui) =>
        @currentDim = $(ui.helper)[dim]()
      drag: (e, ui) =>
        _ori = ui.originalPosition[ori]
        _pos = ui.position[ori]
        _cur = @currentDim
        _max = max.call @
        _min = min.call @
        $(ui.helper)[dim] =>
          d = (_cur+_ori)-(_pos*rev)
          if d >= _min and d <= _max
            return d
          if d < _min
            options.goSleep() unless @el.draggable("option", "disabled")
            return _min
          if d > _max
            options.awake() unless @el.draggable("option", "disabled")
            return _max
      stop: (e, ui) =>
        @currentDim = $(ui.helper)[dim]() unless @el.draggable("option", "disabled")
  hasActive: ->
    for controller in @controllers
      if controller.isActive()
          return true
    false

Spine.Manager.extend
  deactivate_: ->
    console.log 'deactivate'
    @constructor.apply @, arguments