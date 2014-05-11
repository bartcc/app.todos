Spine          = require("spine")
$              = Spine.$
Gallery        = require('models/gallery')
Album          = require('models/album')
Photo          = require('models/photo')
GalleriesAlbum = require('models/galleries_album')
AlbumsPhoto    = require('models/albums_photo')
User           = require("models/user")
Drag           = require("plugins/drag")
SidebarList    = require('controllers/sidebar_list')
Extender       = require("plugins/controller_extender")
SpineDragItem  = require('models/drag_item')

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
    'click .opt-CreateAlbum'    : 'createAlbum'
    'click .opt-CreateGallery'  : 'createGallery'
    'click .opt-Refresh'        : 'fetchAll'
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
    Spine.bind('destroy:gallery', @proxy @destroyGallery)
    
    @bind('drag:timeout', @proxy @expandAfterTimeout)
    @bind('drag:help', @proxy @dragHelp)
    @bind('drag:start', @proxy @dragStart)
    @bind('drag:enter', @proxy @dragEnter)
    @bind('drag:over', @proxy @dragOver)
    @bind('drag:leave', @proxy @dragLeave)
    @bind('drag:drop', @proxy @dragDrop)
    
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
    
  fetchAll: (e) ->
    @refreshAll()
    e.preventDefault()
    e.stopPropagation()
    
  refreshAll: ->
    @refreshElements()
    Gallery.one('refresh', @proxy @refresh)
    Album.trigger('refresh:one')
    Photo.trigger('refresh:one')
    App.fetchAll()
    
  render: (selectType='searchSelect') ->
    model = Model[@model] or Model[@defaultModel]
    items = model.filter(@query, func: selectType)
    items = items.sort model.nameSort
    Gallery.trigger('refresh:gallery') #rerenders GalleryView
    @list.render items
  
  newAttributes: ->
    if User.first()
      name    : @galleryName()
      author  : User.first().name
      user_id : User.first().id
    else
      User.ping()
      
  galleryName: (proposal = 'Gallery ' + (->
    s = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
    index = if (i = Gallery.count()+1) < s.length then i else (i % s.length)
    s.split('')[index])()) ->
    Gallery.each (record) =>
      if record.name is proposal
        return proposal = @galleryName(proposal + proposal.split(' ')[1][0])
    return proposal

  createGallery: (options={}) ->
    @log 'createGallery'
    
    cb = (gallery) ->
      gallery.updateSelectionID()
      
      if options.albums
        Album.trigger('create:join', options.albums, gallery)
        Album.trigger('destroy:join', options.albums, options.deleteFromOrigin) if options.deleteFromOrigin
        
      unless /^#\/galleries\/$/.test(location.hash)
        @navigate '/gallery', gallery.id
      else
        Gallery.trigger('activate', gallery.id)
        
      
    gallery = new Gallery @newAttributes()
    gallery.one('ajaxSuccess', @proxy cb)
    gallery.save()
    
  createAlbum: ->
    Spine.trigger('create:album')
    
  destroyGallery: (id) ->
    @log 'destroy'
    return unless item = Gallery.find id
    
    item.destroy()

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
    return unless item and item.id isnt Spine.DragItem.originRecord.id
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
          ga.order = index
          result.push ga
        
          
    res.save(ajax:false) for res in result
    gallery.save()
    Spine.trigger('reorder', gallery)
    
module?.exports = Sidebar