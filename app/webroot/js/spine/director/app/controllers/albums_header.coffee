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
    'click .opt-AlbumActionCopy'      : 'toggleActionWindow'
  
  elements:
    '.movefromright'          : 'actionMenu'
    
  constructor: ->
    super
    Gallery.bind('change', @proxy @render)
    Gallery.bind('change:selection', @proxy @render)
    Album.bind('refresh', @proxy @render)
    Album.bind('change', @proxy @render)
    GalleriesAlbum.bind('change', @proxy @render)

  render: ->
    return unless @isActive()
    console.log 'AlbumsHeader::render'
    @html @template
      model       : Gallery
      modelAlbum  : Album
      modelPhoto  : Photo
      modelGas    : GalleriesAlbum
      modelAps    : AlbumsPhoto
      author  : User.first().name
        
    @refreshElements()
    
  count: ->
    if Gallery.record
      filterOptions =
        key:'gallery_id'
        joinTable: 'GalleriesAlbum'
      Album.filterRelated(Gallery.record.id, filterOptions).length
    else
      Album.count()
      
  backToGalleries: (e) ->
    @navigate '/galleries/'
    e.stopPropagation()
    e.preventDefault()
    
  moveMenu: (list = Gallery.selectionList()) ->
    @actionMenu.toggleClass('move', !!list.length)
    
  toggleActionWindow: (e) ->
    e.stopPropagation()
    e.preventDefault()
    list = Gallery.selectionList().slice(0)
    @parent.actionWindow.open('Gallery', list)
    
  activated: ->
    @render()
    
module?.exports = AlbumsHeader