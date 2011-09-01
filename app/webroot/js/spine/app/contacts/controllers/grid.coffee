Spine ?= require("spine")
$      = Spine.$

class Grid extends Spine.Controller
  events:
    "click .item": "click"
    
  constructor: ->
    super
    @bind("change", @change)
    
module?.exports = Grid