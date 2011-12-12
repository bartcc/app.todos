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
    console.log 'PhotosHeader::closeView'
    Spine.trigger('gallery:exposeSelection', Gallery.record)
    Spine.trigger('show:albums')

  change: (item) ->
    @current = item
    @render()
    
  render: ->
    @html @template
      gallery: Gallery.record
      record: @current
      count:  @count()
    
  count: ->
    if Album.record
      AlbumsPhoto.filter(Album.record.id, key: 'album_id').length
    else
      Photo.all().length

module?.exports = PhotosHeader