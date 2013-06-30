Spine = require("spine")
$      = Spine.$

class AlbumsHeader extends Spine.Controller
  
  events:
    'click .gal'     : 'backToGalleries'
  
  constructor: ->
    super

  change: (item) ->
    @current = item
    @render()
    
  render: ->
    console.log 'AlbumsHeader::render'
    @html @template
      record: @current
      count: @count()
    
    unless Gallery.record
      $('.hoverinfo', @el).addClass('red')
    else
      $('.hoverinfo', @el).removeClass('red')
    
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
    
module?.exports = AlbumsHeader