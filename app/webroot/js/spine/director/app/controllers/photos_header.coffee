Spine           = require("spine")
$               = Spine.$
Gallery         = require('models/gallery')
Album           = require('models/album')
Photo           = require('models/photo')
User            = require('models/user')
GalleriesAlbum  = require('models/galleries_album')
AlbumsPhoto     = require('models/albums_photo')

class PhotosHeader extends Spine.Controller
  
  events:
    'click .gal'                      : 'backToGalleries'
    'click .alb'                      : 'backToAlbums'

  template: (item) ->
    $("#headerPhotosTemplate").tmpl item

  constructor: ->
    super
    Gallery.bind('create update destroy', @proxy @render)
    Album.bind('change', @proxy @render)
    Album.bind('change:selection', @proxy @render)
    Photo.bind('change', @proxy @render)
    Photo.bind('refresh', @proxy @render)
    Spine.bind('change:selectedGallery', @proxy @render)
    Spine.bind('change:selectedAlbum', @proxy @render)
    Album.bind('collection:changed', @proxy @render)
    
    
  backToGalleries: (e) ->
    console.log 'PhotosHeader::backToGalleries'
    @navigate '/galleries/'
    e.preventDefault()
    
  backToAlbums: (e) ->
    console.log 'PhotosHeader::backToAlbums'
    @navigate '/gallery', Gallery.record?.id or ''
    e.preventDefault()
    
  change:  ->
    @render()
    
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
    
  count: ->
    if Album.record
      AlbumsPhoto.filter(Album.record.id, key: 'album_id').length
    else
      Photo.filter()
    
  activated: ->
    @render()

module?.exports = PhotosHeader