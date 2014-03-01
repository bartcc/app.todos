Spine       = require("spine")
$           = Spine.$
Album       = require('models/album')
Gallery     = require('models/gallery')

class PhotoHeader extends Spine.Controller
  
  events:
    'click .gal'    : 'backToGalleries'
    'click .alb'    : 'backToAlbums'
    'click .pho'    : 'backToPhotos'

  template: (item) ->
    $("#headerPhotoTemplate").tmpl item

  constructor: ->
    super
    Spine.bind('change:selectedPhoto', @proxy @render)
    Gallery.bind('change', @proxy @render)
    Album.bind('change', @proxy @render)
    Photo.bind('change', @proxy @render)

  render: ->
    return unless @isActive()
    @html @template
      gallery: Gallery.record
      album: Album.record
      item: Photo.record
    
  activated: ->
    @render()
  backToGalleries: (e) ->
    @navigate '/galleries/'
    
    e.stopPropagation()
    e.preventDefault()
    
  backToAlbums: (e) ->
    @navigate '/gallery', Gallery.record?.id or ''
    
    e.stopPropagation()
    e.preventDefault()
    
  backToPhotos: (e) ->
    @navigate '/gallery', (Gallery.record.id or '') + '/' + (Album.record?.id or '')
    
    e.stopPropagation()
    e.preventDefault()

  drop: (e) ->
    e.stopPropagation()
    e.preventDefault()

    
module?.exports = PhotoHeader