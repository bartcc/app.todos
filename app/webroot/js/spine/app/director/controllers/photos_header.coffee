Spine ?= require("spine")
$      = Spine.$

class PhotosHeader extends Spine.Controller
  
  events:
    'click .closeView .gal'     : 'backToGalleries'
    'click .closeView .alb'     : 'backToAlbums'

  constructor: ->
    super

  backToGalleries: ->
    console.log 'PhotosHeader::closeView'
    Spine.trigger('show:galleries')
    
  backToAlbums: ->
    console.log 'PhotosHeader::closeView'
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