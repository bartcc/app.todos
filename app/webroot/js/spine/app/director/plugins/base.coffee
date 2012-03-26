Spine ?= require("spine")
$      = Spine.$
Model  = Spine.Model

Model.Base =

  extended: ->

    Extend =
      
      counter: 0
      
    @extend Extend