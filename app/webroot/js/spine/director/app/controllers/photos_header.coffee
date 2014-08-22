Spine           = require("spine")
$               = Spine.$
Gallery         = require('models/gallery')
Album           = require('models/album')
Photo           = require('models/photo')
User            = require('models/user')
GalleriesAlbum  = require('models/galleries_album')
AlbumsPhoto     = require('models/albums_photo')
Extender        = require("plugins/controller_extender")

class PhotosHeader extends Spine.Controller
  
  @extend Extender
  
  events:
    'click .gal'       : 'backToGalleries'
    'click .alb'       : 'backToAlbums'

  template: (item) ->
    $("#headerPhotosTemplate").tmpl item

  constructor: ->
    super
    @bind('active', @proxy @active)
    Gallery.bind('create update destroy', @proxy @render)
    Album.bind('change', @proxy @render)
    Album.bind('change:selection', @proxy @render)
    Photo.bind('change', @proxy @render)
    Photo.bind('refresh', @proxy @render)
    Gallery.bind('change:current', @proxy @render)
    Album.bind('change:current', @proxy @render)
    Album.bind('change:collection', @proxy @render)
    
    
  backToGalleries: (e) ->
    @log 'backToGalleries'
    @navigate '/galleries/'
    e.preventDefault()
    
  backToAlbums: (e) ->
    @log 'backToAlbums'
    @navigate '/gallery', Gallery.record?.id or ''
    e.preventDefault()
    
  goUp: (e) ->
    @navigate '/gallery', Gallery.record.id or ''
    e.preventDefault()
    e.stopPropagation()
    
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
    
  active: ->
    @render()

module?.exports = PhotosHeader