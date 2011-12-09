Spine ?= require("spine")
$      = Spine.$

class AlbumsHeader extends Spine.Controller
  
  constructor: ->
    super

  change: (item) ->
    @current = item
    @render()
    
  render: ->
    @html @template
      record: @current
      count: @albumCount()
    
  albumCount: ->
    GalleriesAlbum.filter(Gallery.record?.id, key:'gallery_id').length
    
module?.exports = AlbumsHeader