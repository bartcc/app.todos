Spine ?= require("spine")
$      = Spine.$

Controller = Spine.Controller

Controller.KeyEnhancer =
  
  extended: ->
    
    Include =
        
      init: ->
        @delegateEvents(@constructor.events) if @constructor.events
        
      preventEvents: (e) ->
        e.stopPropagation()
        
    Extend =
      events:
        'keypress input'     : 'preventEvents'
        'keypress textarea'  : 'preventEvents'
        
    @include Include
    @extend Extend
