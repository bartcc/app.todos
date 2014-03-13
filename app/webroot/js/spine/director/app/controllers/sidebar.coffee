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
    '.optAllAlbums'         : 'albums'
    '.optAllPhotos'         : 'photos'
    '.expander'             : 'expander'


  events:
    'keyup input'               : 'filter'
    'click .optCreateAlbum'     : 'createAlbum'
    'click .optCreateGallery'   : 'createGallery'
    'click .optRefresh'         : 'refreshAll'
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

  template: (items) ->
    $("#sidebarTemplate").tmpl(items)
    
  constructor: ->
    super
    @el.width(8)
    @list = new SidebarList
      el: @items,
      template: @template
      parent: @
      
    Gallery.one('refresh', @proxy @refresh)
    Gallery.bind("ajaxError", Gallery.errorHandler)
    Gallery.bind("ajaxSuccess", Gallery.successHandler)
    
    Spine.bind('create:gallery', @proxy @createGallery)
    Spine.bind('edit:gallery', @proxy @edit)
    Spine.bind('destroy:gallery', @proxy @destroy)
    
    @bind('drag:timeout', @proxy @expandAfterTimeout)
    @bind('drag:start', @proxy @dragStart)
    @bind('drag:enter', @proxy @dragEnter)
    @bind('drag:over', @proxy @dragOver)
    @bind('drag:leave', @proxy @dragLeave)
    @bind('drag:drop', @proxy @dropComplete)
    
  filter: ->
    @query = @input.val();
    @render();
  
  refresh: (items) ->
    console.log 'Sidebar::refresh'
    @render()
    
  render: ->
    console.log 'Sidebar::render'
    items = Gallery.filter(@query, func: 'searchSelect')
    items = items.sort Gallery.nameSort
    @list.render items
      
  refreshAll: (e) ->
    App.showView.refreshElements()
    Gallery.one('refresh', @proxy @refresh)
    Photo.fetch(null, clear:true)
    Album.fetch(null, clear:true)
    Gallery.fetch(null, clear:true)
    e.preventDefault()
    e.stopPropagation()
  
  dragStart: (e, controller) ->
    el = $(e.currentTarget)
    event = e.originalEvent
    Spine.dragItem.targetEl = null
    source = Spine.dragItem.source
    # check for drags from sublist and set its origin
    if el.parents('ul.sublist').length
      fromSidebar = true
      selection = [source.id]
      id = el.parents('li.item')[0].id
      Spine.dragItem.origin = Gallery.find(id) if (id and Gallery.exists(id))
    else
      switch source.constructor.className
        when 'Album'
          selection = Gallery.selectionList()
        when 'Photo'
          selection = Album.selectionList()
      
    # make an unselected item part of selection only if there is nothing selected yet
    return unless Album.isArray(selection)
    if !(source.id in selection)# and !(selection.length)
      list = source.emptySelection().push source.id
      
    Spine.clonedSelection = selection.slice(0)

  dragEnter: (e) ->
    el = $(e.target).closest('.data')
    data = el.tmplItem?.data or el.data()
    target = el.data()?.current?.record or el.item()
    source = Spine.dragItem?.source
    origin = Spine.dragItem?.origin or Gallery.record
    Spine.dragItem.closest?.removeClass('over nodrop')
    Spine.dragItem.closest = el
    if @validateDrop target, source, origin
      Spine.dragItem.closest.addClass('over')
    else
      if target?.id isnt origin?.id
        Spine.dragItem.closest.addClass('nodrop')
        

#    id = el.attr('id')
#    if id and @_id != id
#      @_id = id
#      Spine.dragItem.closest?.removeClass('over nodrop')

  dragOver: (e) =>

  dragLeave: (e) =>

  dropComplete: (e, record) ->
    Spine.dragItem.closest?.removeClass('over nodrop')
    target = Spine.dragItem.closest?.data()?.current?.record or Spine.dragItem.closest?.item()
    source = Spine.dragItem.source
    origin = Spine.dragItem.origin
    
    return unless @validateDrop target, source, origin
    
    switch source.constructor.className
      when 'Album'
        albums = Album.toRecords(Spine.clonedSelection)
        for album in albums
          album.createJoin(target) if target
          album.destroyJoin(origin) if origin  unless @isCtrlClick(e)
          
      when 'Photo'
        photos = []
        Photo.each (record) =>
          photos.push record unless Spine.clonedSelection.indexOf(record.id) is -1
        
        Photo.trigger('create:join', photos.toID(), target)
        Photo.trigger('destroy:join', photos.toID(), origin) unless @isCtrlClick(e)
        
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
    console.log 'Sidebar::create'
    
    cb = -> @updateSelectionID()
      
    gallery = new Gallery @newAttributes()
    gallery.save(done: cb)
    
  createCallback: ->
#    @navigate '/gallery', @id
    
  createAlbum: ->
    Spine.trigger('create:album')
    @navigate '/gallery', Gallery.record.id or ''
    
  destroy: (item=Gallery.record) ->
    console.log 'Sidebar::destroy'
    return unless item
    
    gas = GalleriesAlbum.filter(item.id, key: 'gallery_id')
    
    for ga in gas
      Spine.Ajax.disable ->
        ga.destroy()
        
#    if Gallery.record?.id is item.id
#      Gallery.current() #unless Gallery.count()
      
    item.destroy()
    item.removeSelectionID()
    unless Gallery.count()
      Spine.trigger('show:galleries')
      Gallery.trigger('refreshOnEmpty')

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
    console.log 'expandAfterTimeout'
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
          ga.order = index
          result.push ga
          
    res.save() for res in result
    Spine.trigger('reorder', gallery)
    
module?.exports = Sidebar