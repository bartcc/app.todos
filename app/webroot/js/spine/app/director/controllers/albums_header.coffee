Spine ?= require("spine")
$      = Spine.$

class AlbumsHeader extends Spine.Controller
  
  events:
    'click .closeView .gal'     : 'backToGalleries'
  
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
      
  backToGalleries: ->
    Spine.trigger('gallery:exposeSelection', Gallery.record)
    Spine.trigger('show:galleries')
    
module?.exports = AlbumsHeader