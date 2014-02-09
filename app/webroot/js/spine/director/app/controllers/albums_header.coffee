Spine = require("spine")
$      = Spine.$

class AlbumsHeader extends Spine.Controller
  
  events:
    'click .gal'                     : 'backToGalleries'
    'click .optAlbumActionCopy'      : 'toggleActionWindow'
  
  elements:
    '.move'          : 'actionMenu'
    
  constructor: ->
    super
    Gallery.bind('change:selection', @proxy @moveMenu)

  change: (item) ->
    alert 'Album::change'
    @render()
    
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
#      GalleriesAlbum.filter(Gallery.record.id, key:'gallery_id').length
    else
      Album.all().length
      
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
    
module?.exports = AlbumsHeader