Spine ?= require("spine")
$      = Spine.$

class PhotosView extends Spine.Controller

  template: (items) ->
    $('#photosTemplate').tmpl(items)
    
  constructor: ->
    super
    Spine.bind('create:photo', @proxy @create)
    Spine.bind('destroy:photo', @proxy @destroy)
    Spine.bind('show:photos', @proxy @show)
    
  change: (item) ->
    @current = item
    photos = Photo.filter(item?.id)
    
    @render photos
    
  render: (items) ->
    @html @template items
    
  create: (e) ->
    
  destroy: (e) ->
    
  show: (album) ->
    @change album
    Spine.trigger('change:canvas', @)
  
  save: (item) ->

module?.exports = PhotosView