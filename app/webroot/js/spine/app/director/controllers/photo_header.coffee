Spine ?= require("spine")
$      = Spine.$

class PhotoHeader extends Spine.Controller
  
  @extend Spine.Controller.Drag
  
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

  backToGalleries: ->
#    Spine.trigger('album:activate')
#    Spine.trigger('show:galleries')
    @navigate '/galleries/'
    
  backToAlbums: ->
#    Spine.trigger('gallery:activate', Gallery.record)
#    Spine.trigger('show:albums')
    @navigate '/gallery', Gallery.record.id
    
  backToPhotos: ->
#    Spine.trigger('show:photos')
    @navigate '/gallery', Gallery.record.id + '/' + Album.record.id

  change: ->
    console.log 'PhotoHeader::change'
    @render()
    
  render: ->
    @html @template  Photo.record
    
  drop: (e) ->
    e.stopPropagation()
    e.preventDefault()
    
module?.exports = PhotoHeader