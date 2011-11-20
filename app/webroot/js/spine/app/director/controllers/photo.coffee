Spine ?= require("spine")
$      = Spine.$

class PhotoView extends Spine.Controller

  events:
    'click'           : 'click'
    
  constructor: ->
    super
  
  click: (e) ->
    console.log 'click'
    
    e.stopPropagation()
    e.preventDefault()
    false
  
module?.exports = PhotoView