Spine ?= require("spine")
$      = Spine.$

class GalleriesHeader extends Spine.Controller
  
  elements:
    '.closeView'           : 'closeViewEl'
    
  events:
    'click .closeView'     : 'closeView'
  
  constructor: ->
    super

  render: ->
    @html @template
      count: @count()
    
  count: ->
    Gallery.all().length
    
  closeView: ->
    console.log 'GalleriesHeader::closeView'
    Spine.trigger('show:overview')
  
    
module?.exports = GalleriesHeader