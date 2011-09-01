Spine ?= require("spine")
$      = Spine.$

class Details extends Spine.Controller
  events:
    "click .item": "click"
    
  constructor: ->
    super
    @bind("change", @change)
    
module?.exports = Details