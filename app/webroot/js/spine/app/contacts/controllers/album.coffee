Spine ?= require("spine")
$      = Spine.$

class Album extends Spine.Controller
  events:
    "click .item": "click"
    
  constructor: ->
    super
    @bind("change", @change)
    
module?.exports = Album