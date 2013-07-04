Spine       = require("spine")
$           = Spine.$
Drag        = require("plugins/drag")
Album       = require('models/album')
Gallery     = require('models/gallery')

class PhotoHeader extends Spine.Controller
  
  @extend Drag
  
  events:
    'click .gal'    : 'backToGalleries'
    'click .alb'    : 'backToAlbums'
    'click .pho'    : 'backToPhotos'
    'dragenter'     : 'dragenter'
    'dragend'       : 'dragend'
    'drop'          : 'drop'

  template: (item) ->
    $("#headerPhotoTemplate").tmpl item

  constructor: ->
    super
    Gallery.bind('change', @proxy @change)
    Album.bind('change', @proxy @change)
    Photo.bind('change', @proxy @change)

  backToGalleries: (e) ->
#    Album.trigger('activate')
#    Spine.trigger('show:galleries')
    @navigate '/galleries/'
    
    e.stopPropagation()
    e.preventDefault()
    
  backToAlbums: (e) ->
#    Gallery.trigger('activate', Gallery.record)
#    Spine.trigger('show:albums')
    @navigate '/gallery', Gallery.record?.id or ''
    
    e.stopPropagation()
    e.preventDefault()
    
  backToPhotos: (e) ->
#    Spine.trigger('show:photos')
    @navigate '/gallery', (Gallery.record.id or '') + '/' + (Album.record?.id or '')
    
    e.stopPropagation()
    e.preventDefault()

  change: ->
    console.log 'PhotoHeader::change'
    @render()
    
  render: ->
    @html @template  Photo.record
    
  drop: (e) ->
    e.stopPropagation()
    e.preventDefault()
    
module?.exports = PhotoHeader