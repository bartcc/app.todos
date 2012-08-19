Spine ?= require("spine")
$      = Spine.$

class PhotosHeader extends Spine.Controller
  
  events:
    'click .gal'     : 'backToGalleries'
    'click .alb'     : 'backToAlbums'

  template: (item) ->
    $("#headerPhotosTemplate").tmpl item

  constructor: ->
    super
    
  backToGalleries: ->
#    console.log 'PhotosHeader::backToGalleries'
#    Spine.trigger('show:galleries')
    @navigate '/galleries/'
    
  backToAlbums: ->
    console.log 'PhotosHeader::backToAlbums'
    @navigate '/gallery', Gallery.record.id

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