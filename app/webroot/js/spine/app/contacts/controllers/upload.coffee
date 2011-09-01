Spine ?= require("spine")
$      = Spine.$

class Upload extends Spine.Controller
  events:
    "click .item": "click"
    
  constructor: ->
    super
    @bind("change", @change)
    
module?.exports = Upload