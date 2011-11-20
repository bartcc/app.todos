Spine ?= require("spine")
$      = Spine.$

class SlideshowView extends Spine.Controller

  events:
    'click'           : 'click'
    
  constructor: ->
    super
    @bind("change", @change)
    
  click: (e) ->
    console.log 'click'
    
    e.stopPropagation()
    e.preventDefault()
    false

module?.exports = SlideshowView