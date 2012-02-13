Spine ?= require("spine")
$      = Spine.$

class PhotosHeader extends Spine.Controller
  
  events:
    'click .closeView .gal'     : 'backToGalleries'
    'click .closeView .alb'     : 'backToAlbums'

  template: (item) ->
    $("#headerPhotosTemplate").tmpl item

  constructor: ->
    super
    Album.bind('change', @proxy @change)
    Photo.bind('change', @proxy @change)
    
  backToGalleries: ->
    console.log 'PhotosHeader::closeView'
    Spine.trigger('show:galleries')
    
  backToAlbums: ->
    console.log 'PhotosHeader::closeView'
    Spine.trigger('show:albums')

  change:  ->
    @render()
    
  render: ->
    @html @template
      gallery: Gallery.record
      album: Album.record
      photo: Photo.record
      count:  @count()
    
  count: ->
    if Album.record
      AlbumsPhoto.filter(Album.record.id, key: 'album_id').length
    else
      Photo.all().length

module?.exports = PhotosHeader