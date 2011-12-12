Spine ?= require("spine")
$      = Spine.$

class AlbumsHeader extends Spine.Controller
  
  elements:
    '.closeView'           : 'closeViewEl'
    
  events:
    'click .closeView'     : 'closeView'
  
  constructor: ->
    super

  change: (item) ->
    @current = item
    @render()
    
  render: ->
    @html @template
      record: @current
      count: @count()
    
  count: ->
    if Gallery.record
      GalleriesAlbum.filter(Gallery.record.id, key:'gallery_id').length
    else
      Album.all().length
      
  closeView: ->
    console.log 'AlbumsHeader::closeView'
    Spine.trigger('gallery:exposeSelection', Gallery.record)
    Spine.trigger('show:galleries')
    
module?.exports = AlbumsHeader