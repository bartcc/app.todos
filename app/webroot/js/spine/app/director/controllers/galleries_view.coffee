Spine ?= require("spine")
$      = Spine.$

class GalleriesView extends Spine.Controller
  
  @extend Spine.Controller.Drag
  
  elements:
    '.items'                  : 'items'
    
  headerTemplate: (items) ->
    $("#headerGalleryTemplate").tmpl(items)

  template: (items) ->
    $("#galleriesTemplate").tmpl(items)

  constructor: ->
    super
    @el.data current:
      className: null
      record: null
    @list = new GalleriesList
      el: @items
      template: @template
    @header.template = @headerTemplate
    Gallery.bind('refresh change', @proxy @change)
    GalleriesAlbum.bind('refresh change', @proxy @change)
    AlbumsPhoto.bind('refresh change', @proxy @change)
    Spine.bind('show:galleries', @proxy @show)

  change: ->
    console.log 'GalleriesView::change'
    items = Gallery.all()
    @render items
    
  render: (items) ->
    console.log 'GalleriesView::render'
      
    @list.render items
    @header.render()
    
  show: ->
    Spine.trigger('change:toolbarOne', ['Gallery'])
    Spine.trigger('gallery:activate', Gallery.record)
    Spine.trigger('change:canvas', @)
    
  newAttributes: ->
    if User.first()
      name   : 'New Name'
      user_id : User.first().id
    else
      User.ping()
  
  create: (e) ->
    console.log 'GalleriesView::create'
    Spine.trigger('create:gallery')

  destroy: (e) ->
    console.log 'GalleriesView::destroy'
    Spine.trigger('destroy:gallery')


module?.exports = GalleriesView