Spine ?= require("spine")
$      = Spine.$

class PhotoHeader extends Spine.Controller
  
  @extend Spine.Controller.Drag
  
  events:
    'click .closeView .gal'     : 'backToGalleries'
    'click .closeView .alb'     : 'backToAlbums'
    'click .closeView .pho'     : 'backToPhotos'
    'dragenter'                 : 'dragenter'
    'dragend'                   : 'dragend'
    'drop'                      : 'drop'

  template: (item) ->
    $("#headerPhotoTemplate").tmpl item

  constructor: ->
    super
    Album.bind('change', @proxy @change)

  backToGalleries: ->
    Spine.trigger('album:activate')
    Spine.trigger('show:galleries')
    
  backToAlbums: ->
    Spine.trigger('gallery:activate', Gallery.record)
    Spine.trigger('show:albums')
    
  backToPhotos: ->
    Spine.trigger('show:photos')

  change: ->
    console.log 'PhotoHeader::change'
    @render()
    
  render: ->
    @html @template  Photo.record
    
  drop: (e) ->
    e.stopPropagation()
    e.preventDefault()
    
module?.exports = PhotoHeader