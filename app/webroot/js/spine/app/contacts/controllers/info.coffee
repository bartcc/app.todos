Spine ?= require("spine")
$      = Spine.$

class Info extends Spine.Controller
  events:
    "click .item": "click"
    
  constructor: ->
    super
    @bind("change", @change)
    
module?.exports = Info