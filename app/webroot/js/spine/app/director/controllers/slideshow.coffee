Spine ?= require("spine")
$      = Spine.$

class SlideshowView extends Spine.Controller

  events:
    "click .item": "click"
    
  constructor: ->
    super
    @bind("change", @change)

module?.exports = SlideshowView