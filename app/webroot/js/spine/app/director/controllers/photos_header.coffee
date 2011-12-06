Spine ?= require("spine")
$      = Spine.$

class PhotosHeader extends Spine.Controller
  
  elements:
    '.closeView'           : 'closeViewEl'
    
  events:
    'click .closeView'     : 'closeView'

  constructor: ->
    super

  closeView: ->
    console.log 'AlbumsHeader::closeView'
    Spine.trigger('show:albums')

module?.exports = PhotosHeader