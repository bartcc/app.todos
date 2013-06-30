Spine         = require("spine")
$             = Spine.$
Drag          = require("plugins/drag")
Gallery       = require('models/gallery')
GalleriesList = require("controllers/galleries_list")
AlbumsPhoto   = require('models/albums_photo')
Extender      = require('plugins/controller_extender')

class GalleriesView extends Spine.Controller
  
  @extend Drag
  @extend Extender
  
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
    Gallery.bind('refresh', @proxy @refresh)
    AlbumsPhoto.bind('change', @proxy @change)
    AlbumsPhoto.bind('refresh', @proxy @refresh)
    Spine.bind('show:galleries', @proxy @show)

  change: (item, mode) ->
    console.log 'GalleriesView::change'
    return unless item.constructor.className is 'Gallery'
    switch mode
      when 'create'
        @create item
#      when 'update'
#        @update item
#      when 'destroy'
#        @destroy item
#    @render item
    
  refresh: ->
    items = Gallery.all().sort Gallery.nameSort
    @render items
  
  render: (items) ->
    console.log 'GalleriesView::render'
    if Gallery.count()
      @list.render items
    else  
      @list.el.html '<label class="invite"><span class="enlightened">This Application has no galleries. &nbsp;<button class="optCreateGallery dark large">New Gallery</button>'
      
    @header.render()
    
  show: ->
    App.showView.trigger('change:toolbarOne', ['Default'])
    App.showView.trigger('change:toolbarTwo', [''])
    App.showView.trigger('canvas', @)
    @list.exposeSelection(Gallery.record)
    @list.updateTemplates()
    
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