Spine ?= require("spine")
$      = Spine.$

Spine.Manager.include
  sleep: true
  height: (func) ->
    @currentHeight = func.call @
  alive: (el, axis = 'x') ->
    return unless el
    @el = el
    @axis = if axis is 'y' then 'top' else 'left'
    @el.draggable
      axis: @axis
      handle: '.draghandle'
      start: (e, ui) =>
        return if @sleep
        @currentHeight = $(ui.helper).height()
      drag: (e, ui) =>
        return if @sleep
        _ori = ui.originalPosition[@axis]
        _pos = ui.position[@axis]
        _cur = @currentHeight
        $(ui.helper).height ->
          _cur-_pos+_ori
      stop: (e, ui) =>
        return if @sleep
        @currentHeight = $(ui.helper).height()

Spine.Manager.extend
  notify: (t) ->
    #alert(t)