Spine ?= require("spine")
$      = Spine.$

class PhotosView extends Spine.Controller

  constructor: ->
    super
    Spine.bind('create:photo', @proxy @create)
    Spine.bind('destroy:photo', @proxy @destroy)
    Spine.bind('show:photos', @proxy @show)
    
  create: (e) ->
    console.log 'PhotoView::create'
    
  destroy: (e) ->
    console.log 'PhotosView::destroy'
    
  show: =>
    console.log 'PhotosView::show'
    console.log @
    App.canvasManager.trigger('change', @)
  

module?.exports = PhotosView