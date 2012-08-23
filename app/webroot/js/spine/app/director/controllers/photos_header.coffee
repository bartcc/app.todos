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
    
  backToGalleries: (e) ->
    console.log 'PhotosHeader::backToGalleries'
#    Spine.trigger('show:galleries')
    @navigate '/galleries/'
    e.stopPropagation()
    e.preventDefault()
    
  backToAlbums: (e) ->
    console.log 'PhotosHeader::backToAlbums'
    @navigate '/gallery', Gallery.record?.id or ''
    e.stopPropagation()
    e.preventDefault()
    
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