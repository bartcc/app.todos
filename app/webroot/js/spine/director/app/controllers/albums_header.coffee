Spine           = require("spine")
$               = Spine.$
Gallery         = require('models/gallery')
Album           = require('models/album')
Photo           = require('models/photo')
GalleriesAlbum  = require('models/galleries_album')
AlbumsPhoto     = require('models/albums_photo')

class AlbumsHeader extends Spine.Controller
  
  events:
    'click .gal'                     : 'backToGalleries'
  
  constructor: ->
    super
    Gallery.bind('change', @proxy @render)
    Gallery.bind('change:selection', @proxy @render)
    Album.bind('refresh', @proxy @render)
    Album.bind('change', @proxy @render)
    Album.bind('change:collection', @proxy @render)

  render: ->
    return unless @isActive()
    console.log 'AlbumsHeader::render'
    @html @template
      model       : Gallery
      modelAlbum  : Album
      modelPhoto  : Photo
      modelGas    : GalleriesAlbum
      modelAps    : AlbumsPhoto
      gallery     : Gallery.record
      album       : Album.record
      photo       : Photo.record
      author  : User.first().name
        
    @refreshElements()
    
  count: ->
    if Gallery.record
      filterOptions =
        model: 'Gallery'
        key:'gallery_id'
      Album.filterRelated(Gallery.record.id, filterOptions).length
    else
      Album.filter()
      
  backToGalleries: (e) ->
    @navigate '/galleries/'
    e.preventDefault()
    
  activated: ->
    @render()
    
module?.exports = AlbumsHeader