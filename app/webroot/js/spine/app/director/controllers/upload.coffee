Spine ?= require("spine")
$      = Spine.$

class UploadView extends Spine.Controller
  events:
    "click .item": "click"
    
  constructor: ->
    super
    @bind("change", @change)
    
module?.exports = UploadView