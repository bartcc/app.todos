Spine = require("spine")
$      = Spine.$
Controller = Spine.Controller

Controller.KeyEnhancer =
  
  extended: ->
    
    Include =
        
      init: ->
        @delegateEvents(@constructor.events) if @constructor.events
        
      stopPropagation: (e) ->
        e.stopPropagation()
        
    Extend =
      events:
        'keypress input'     : 'stopPropagation'
        'keypress textarea'  : 'stopPropagation'
        
    @include Include
    @extend Extend

module?.exports = Controller.KeyEnhancer