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
    @type = 'Gallery'
    @list = new GalleriesList
      el: @items
      template: @template
      parent: @
    @header.template = @headerTemplate
    @viewport = @list.el
    Gallery.bind('refreshOnEmpty', @proxy @render)
    Gallery.bind('refresh', @proxy @render)
    Spine.bind('show:galleries', @proxy @show)

  render: ->
    return unless @isActive()
    console.log 'GalleriesView::render'
    if Gallery.count()
      items = Gallery.records.sort Gallery.nameSort
      @list.render items
    else  
      @list.el.html '<label class="invite"><span class="enlightened">This Application has no galleries. &nbsp;<button class="optCreateGallery dark large">New Gallery</button>'
          
  show: ->
    App.showView.trigger('change:toolbarOne', ['Default'])
    App.showView.trigger('change:toolbarTwo', ['Slideshow'])
    App.showView.trigger('canvas', @)
    
  activated: ->
    @render()
    @list.exposeSelection()
    
  newAttributes: ->
    if User.first()
      name   : 'New Name'
      user_id : User.first().id
      author: User.first().name
    else
      User.ping()
  
  create: (e) ->
    console.log 'GalleriesView::create'
    Spine.trigger('create:gallery')

  destroy: (e) ->
    console.log 'GalleriesView::destroy'
    Spine.trigger('destroy:gallery')


module?.exports = GalleriesView