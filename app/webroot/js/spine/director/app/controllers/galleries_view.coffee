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
    
  events:
    'click .item'             : 'click'
    
  headerTemplate: (items) ->
    $("#headerGalleryTemplate").tmpl(items)

  template: (items) ->
    $("#galleriesTemplate").tmpl(items)

  constructor: ->
    super
    @el.data('current',
      model: Gallery
      models: Gallery
    )
    @type = 'Gallery'
    @list = new GalleriesList
      el: @items
      template: @template
      parent: @
    @header.template = @headerTemplate
    @viewport = @list.el
    Gallery.one('refresh', @proxy @render)
    Gallery.bind('destroy', @proxy @destroy)
    Gallery.bind('refresh:gallery', @proxy @render)
    Gallery.bind('activate', @proxy @activateRecord)
    Spine.bind('show:galleries', @proxy @show)

  render: (items) ->
    return unless @isActive()
    if Gallery.count()
      items = Gallery.records.sort Gallery.nameSort
      @list.render items
    else  
      @list.el.html '<label class="invite"><span class="enlightened">This Application has no galleries. &nbsp;<button class="opt-CreateGallery dark large">New Gallery</button>'
          
  show: ->
    App.showView.trigger('change:toolbarOne', ['Default'])
    App.showView.trigger('change:toolbarTwo', ['Slideshow'])
    App.showView.trigger('canvas', @)
    
  activated: ->
    @render()
    
  activateRecord: (idOrRecord, ModelOrRecord) ->
    Gallery.current idOrRecord
    unless ModelOrRecord
      Album.trigger('activate', Gallery.selectionList())

  click: (e) ->
    App.showView.trigger('change:toolbarOne', ['Default'])
    item = $(e.currentTarget).item()
    @select(item)
    
  select: (item) ->
    Gallery.trigger('activate', item.id)
    
  destroy: (item) ->
    albums = Gallery.albums(item.id)
    Album.trigger('destroy:join', albums, item)
        
    item.removeSelectionID()
    
  newAttributes: ->
    if User.first()
      name   : 'New Name'
      user_id : User.first().id
      author: User.first().name
    else
      User.ping()
  
module?.exports = GalleriesView