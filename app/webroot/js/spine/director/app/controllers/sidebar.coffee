Spine          = require("spine")
$              = Spine.$
Gallery        = require('models/gallery')
Album          = require('models/album')
GalleriesAlbum = require('models/galleries_album')
AlbumsPhoto    = require('models/albums_photo')
User           = require("models/user")
Drag           = require("plugins/drag")
SidebarList    = require('controllers/sidebar_list')
Extender       = require("plugins/controller_extender")

class Sidebar extends Spine.Controller

  @extend Drag
  @extend Extender

  elements:
    'input'                 : 'input'
    '.flickr'               : 'flickr'
    '.items'                : 'items'
    '.inner'                : 'inner'
    '.droppable'            : 'droppable'
    '.opt-AllAlbums'        : 'albums'
    '.opt-AllPhotos'        : 'photos'
    '.expander'             : 'expander'


  events:
    'keyup input'               : 'filter'
    'click .opt-CreateAlbum'     : 'createAlbum'
    'click .opt-CreateGallery'   : 'createGallery'
    'click .opt-Refresh'         : 'refreshAll'
    'dblclick .draghandle'      : 'toggleDraghandle'

    'sortupdate .sublist'         : 'sortupdate'
    
    'dragstart  .alb.item'        : 'dragstart'
    'dragover   .gal.item'        : 'dragover' # Chrome only dispatches the drop event if this event is cancelled
    'dragenter  .gal.item'        : 'dragenter'
    'dragenter  .alb.item'        : 'dragenter'
    'dragleave  .gal.item'        : 'dragleave'
    'dragleave  .alb.item'        : 'dragleave'
    'dragend    .gal.item'        : 'dragend'
    'dragend    .alb.item'        : 'dragend'
    'drop       .gal.item'        : 'drop'
    'drop       .alb.item'        : 'drop'

  galleryTemplate: (items) ->
    $("#sidebarTemplate").tmpl(items)
    
  albumTemplate: (items) ->
    $("#albumsSublistTemplate").tmpl(items)
    
  constructor: ->
    super
    @el.width(8)
    @defaultTemplate = @galleryTemplate
    @list = new SidebarList
      el: @items,
      template: @galleryTemplate
      parent: @
      
    Gallery.one('refresh', @proxy @refresh)
    Gallery.bind("ajaxError", Gallery.errorHandler)
    Gallery.bind("ajaxSuccess", Gallery.successHandler)
    
    Spine.bind('create:gallery', @proxy @createGallery)
    Spine.bind('edit:gallery', @proxy @edit)
    Spine.bind('destroy:gallery', @proxy @destroy)
    
    @bind('drag:timeout', @proxy @expandAfterTimeout)
    @bind('drag:start', @proxy @dragStartFromSidebar)
    @bind('drag:start', @proxy @dragStart)
    @bind('drag:enter', @proxy @dragEnter)
    @bind('drag:over', @proxy @dragOver)
    @bind('drag:leave', @proxy @dragLeave)
    @bind('drag:drop', @proxy @dropComplete)
    
    @model = @defaultModel = 'Gallery'
    
  filter: ->
    @query = @input.val()
    @render()
    
  filterById: (id, model) ->
    @filter() unless model and /[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/.test(id or '')
    @query = id
    @model = model
    switch model
      when 'Album'
        @list.template = @albumTemplate
      when 'Gallery'
        @list.template = @galleryTemplate
    @render('idSelect')
    @model = @defaultModel
    @list.template = @defaultTemplate
  
  refresh: (items) ->
    @render()
    
  render: (selectType='searchSelect') ->
    model = Model[@model] or Model[@defaultModel]
    items = model.filter(@query, func: selectType)
    items = items.sort model.nameSort
    Gallery.trigger('refresh:gallery') #rerenders GalleryView
    @list.render items
      
  refreshAll: (e) ->
    App.showView.refreshElements()
    Gallery.one('refresh', @proxy @refresh)
    Photo.fetch(null, clear:true)
    Album.fetch(null, clear:true)
    Gallery.fetch(null, clear:true)
    e.preventDefault()
    e.stopPropagation()
  
  newAttributes: ->
    if User.first()
      name    : @galleryName()
      author  : User.first().name
      user_id : User.first().id
    else
      User.ping()
      
  galleryName: (proposal = 'Gallery ' + (Number)(Gallery.count()+1)) ->
    Gallery.each (record) =>
      if record.name is proposal
        return proposal = @galleryName(proposal + '_1')
    return proposal

  createGallery: ->
    console.log 'Sidebar::createGallery'
    
    cb = (rec, a) -> @updateSelectionID()
      
    gallery = new Gallery @newAttributes()
    gallery.save(done: @proxy @createCallback)
    @navigate '/gallery', gallery.id
    
    
  createCallback: ->
    gallery = Gallery.last()
    gallery.updateSelectionID()
    @navigate '/gallery', gallery.id
    
  createAlbum: ->
    Spine.trigger('create:album')
#    @navigate '/gallery', Gallery.record.id or ''
    
  destroy: (item=Gallery.record) ->
    console.log 'Sidebar::destroy'
    return unless item
    
    gas = GalleriesAlbum.filter(item.id, key: 'gallery_id')
    
    for ga in gas
      Spine.Ajax.disable ->
        ga.destroy()
        
    item.destroy()
    item.removeSelectionID()
    unless Gallery.count()
      Spine.trigger('show:galleries')
      Gallery.trigger('refresh:gallery')

  edit: ->
    App.galleryEditView.render()
    App.contentManager.change(App.galleryEditView)

  toggleDraghandle: (options) ->
    width = =>
      max = App.vmanager.currentDim
      w =  @el.width()
      if App.vmanager.sleep
        App.vmanager.awake()
        @clb = ->
        max+"px"
      else
        @clb = App.vmanager.goSleep
        '8px'
    
    w = width()
    speed = 500
    @el.animate
      width: w
      speed
      => @clb()
    
  expandAfterTimeout: (e, timer) ->
    clearTimeout timer
    galleryEl = $(e.target).closest('.gal.item')
    item = galleryEl.item()
    return unless item and item.id isnt Spine.dragItem.origin.id
    @list.expand(item, true)
    
  sortupdate: (e, o) ->
    list = o.item.parent()
    gallery = list.parent().item()
    gas = GalleriesAlbum.filter(gallery.id, key: 'gallery_id')
    result = []
    list.children().each (index) ->
      album = $(@).item()
      for ga in gas
        if ga.album_id is album.id and parseInt(ga.order) isnt index
          console.log ga.order + ' : ' + index
          ga.order = index
          result.push ga
        
          
    res.save() for res in result
    Spine.trigger('reorder', gallery)
    
  dragStartFromSidebar: (e, id) ->
#    Gallery.updateSelection(id)
    Album.trigger('activate', id)
    
module?.exports = Sidebar