Spine ?= require("spine")
$      = Spine.$

class GridView extends Spine.Controller
  events:
    "click .item": "click"
    
  constructor: ->
    super
    @bind("change", @change)

module?.exports = GridView