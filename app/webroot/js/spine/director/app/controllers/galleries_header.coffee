Spine                 = require("spine")
$                     = Spine.$
GalleriesAlbum        = require('models/galleries_album')
AlbumsPhoto           = require('models/albums_photo')

class GalleriesHeader extends Spine.Controller
  
  constructor: ->
    super
    Gallery.bind('change', @proxy @render)
    Gallery.bind('change:current', @proxy @render)

  render: ->
    return unless @isActive()
    console.log 'GalleryHeader::render'
    @html @template
      model       : Gallery
      modelAlbum  : Album
      modelPhoto  : Photo
      modelGas    : GalleriesAlbum
      modelAps    : AlbumsPhoto
      author  : User.first().name
    
  count: ->
    Gallery.count()
    
  activated: ->
    @render()
  
    
module?.exports = GalleriesHeader