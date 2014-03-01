Spine = require("spine")
$      = Spine.$
Gallery         = require('models/gallery')
GalleriesAlbum  = require('models/galleries_album')

class AlbumsHeader extends Spine.Controller
  
  events:
    'click .gal'                     : 'backToGalleries'
    'click .optAlbumActionCopy'      : 'toggleActionWindow'
  
  elements:
    '.movefromright'          : 'actionMenu'
    
  constructor: ->
    super
    Gallery.bind('change:selection', @proxy @moveMenu)
    Album.bind('change', @proxy @render)
    GalleriesAlbum.bind('change', @proxy @render)
    Gallery.bind('refresh change', @proxy @render)

  render: ->
    return unless @isActive()
    console.log 'AlbumsHeader::render'
    @html @template
      record: Gallery.record
      count: @count()
      author: User.first().name
    @delay(@moveMenu, 500)
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
    @actionMenu.toggleClass('down', !!list.length)
    
  toggleActionWindow: (e) ->
    e.stopPropagation()
    e.preventDefault()
    list = Gallery.selectionList().slice(0)
    @parent.actionWindow.open('Gallery', list)
    
  activated: ->
    @render()
    
module?.exports = AlbumsHeader