Spine = require("spine")
$     = Spine.$
Log   = Spine.Log
Spine.Manager = require('spine/lib/manager')

Spine.Manager.extend.Log

Spine.Manager.extend

  deactivate: ->
    @log 'deactivate'
    @constructor.apply @, arguments
    
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
      manager: @
      initSize: -> 500
      disabled: false
      sleep: false
      axis: 'x'
      min: -> 20
      max: -> 300
      tol: 10
      handle: '.draghandle'
      goSleep: ->
      awake: ->
    options = $.extend({}, defaults, opts)
    ori = if options.axis is 'y' then 'top' else 'left'
    dim = if options.axis is 'y' then 'height' else 'width'
    rev = if options.axis is 'y' then 1 else -1
    min = (options.min)
    max = (options.max)
    @sleep = (options.sleep)
    @currentDim = options.initSize.call @
    @disableDrag() if options.disabled
    @goSleep = =>
      @sleep = true
      options.goSleep()
      @trigger('sleep')
    @awake = =>
      @sleep = false
      options.awake()
      @trigger('awake')
    el.draggable
      create: (e, ui) =>
        @el.css({position: 'inherit'})
      axis: options.axis
      handle: options.handle
      start: (e, ui) =>
        @currentDim = $(ui.helper)[dim]()
#        @dragging = true
      stop: (e, ui) =>
        unless @el.draggable("option", "disabled")
          @currentDim = $(ui.helper)[dim]() unless @sleep 
#        @dragging = false
      drag: (e, ui) =>
        _ori = ui.originalPosition[ori]
        _pos = ui.position[ori]
        _cur = @currentDim
        _max = max.call @
        _min = min.call @
        $(ui.helper)[dim] =>
          d = (_cur+_ori)-(_pos*rev)
          if !@sleep
            if d >= _min and d <= _max
              return d
            if d < _min
              @goSleep() unless @el.draggable("option", "disabled")
              return _min
            if d > _max
              return _max
          else if d >= _min
            @awake() unless @el.draggable("option", "disabled")
            return d
          
  hasActive: ->
    for controller in @controllers
      if controller.isActive()
          return @controller = @last = controller
    false
  
  active: ->
    @hasActive()
  
  lastActive: ->
    @last or @controllers[0]
  
  externalUI: (controller) ->
    activeController = controller or @lastActive()
    $(activeController.externalClass, @external.el)
    