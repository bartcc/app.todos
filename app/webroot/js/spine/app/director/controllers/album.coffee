Spine ?= require("spine")
$      = Spine.$

class AlbumView extends Spine.Controller
  
  events:
    "click .item": "click"
    
  constructor: ->
    super
    @bind("change", @change)

  click: ->
    console.log 'click'

module?.exports = AlbumView