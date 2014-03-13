Spine = require("spine")
$      = Spine.$
Controller = Spine.Controller

Controller.KeyEnhancer =
  
  extended: ->
    
    Extend =
      events:
        'keyup'              : 'keyup'
        'keypress input'     : 'stopPropagation'
        'keypress textarea'  : 'stopPropagation'
        
    Include =
        
      init: ->
        @delegateEvents(@constructor.events) if @constructor.events
        
      stopPropagation: (e) ->
        e.stopPropagation()
        
      keyup: (e) ->
        console.log e
        console.log @
        
    @include Include
    @extend Extend

module?.exports = Controller.KeyEnhancer