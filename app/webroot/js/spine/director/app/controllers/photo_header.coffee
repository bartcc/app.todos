Spine           = require("spine")
$               = Spine.$
Album           = require('models/album')
Gallery         = require('models/gallery')
AlbumsPhoto     = require('models/albums_photo')
GalleriesAlbum  = require('models/galleries_album')
Extender        = require("plugins/controller_extender")

class PhotoHeader extends Spine.Controller
  
  @extend Extender
  
  events:
    'click .gal'    : 'backToGalleries'
    'click .alb'    : 'backToAlbums'
    'click .pho'    : 'backToPhotos'

  template: (item) ->
    $("#headerPhotoTemplate").tmpl item

  constructor: ->
    super
    @bind('active', @proxy @active)
    Photo.bind('change:current', @proxy @render)
    Gallery.bind('change', @proxy @render)
    Album.bind('change', @proxy @render)
    Photo.bind('change', @proxy @render)

  render: ->
    return unless @isActive()
    @html @template
      model       : Album
      gallery     : Gallery.record
      album       : Album.record
      photo       : Photo.record
      modelAlbum  : Album
      modelPhoto  : Photo
      modelGas    : GalleriesAlbum
      modelAps    : AlbumsPhoto
      count       : @count()
      author      : User.first().name
      zoomed      : true
    
  count: ->
    if Album.record
      AlbumsPhoto.filter(Album.record.id, key: 'album_id').length
    else
      Photo.count()
    
  active: ->
    @render()
    
  backToGalleries: (e) ->
    @navigate '/galleries/'
    e.preventDefault()
    
  backToAlbums: (e) ->
    @navigate '/gallery', Gallery.record?.id or '', Album.record?.id or ''
    e.preventDefault()
    
  backToPhotos: (e) ->
    @navigate '/gallery', Gallery.record.id or '', Album.record?.id or ''
    e.preventDefault()
    
  drop: (e) ->
    e.stopPropagation()
    e.preventDefault()

    
module?.exports = PhotoHeader