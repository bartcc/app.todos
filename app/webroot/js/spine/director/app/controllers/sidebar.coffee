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

  events:
    'keyup input'           : 'filter'
    'click .createAlbum'    : 'createAlbum'
    'click .createGallery'  : 'createGallery'
    'dblclick .draghandle'  : 'toggleDraghandle'

    'dragstart  .items .item'        : 'dragstart'
    'dragenter  .items .item'        : 'dragenter'
    'dragleave  .items .item'        : 'dragleave'
    'dragover   .items .item'        : 'dragover' # Chrome only dispatches the drop event if this event is cancelled
    'dragend    .items .item'        : 'dragend'
    'drop       .items .item'        : 'drop'

  template: (items) ->
    $("#sidebarTemplate").tmpl(items)
    
  constructor: ->
    super
    @el.width(8)
    @list = new SidebarList
      el: @items,
      template: @template
      
    Gallery.bind('refresh', @proxy @refresh)
    Gallery.bind("ajaxError", Gallery.errorHandler)
    Gallery.bind("ajaxSuccess", Gallery.successHandler)
    
    Spine.bind('create:gallery', @proxy @createGallery)
    Spine.bind('edit:gallery', @proxy @edit)
    Spine.bind('destroy:gallery', @proxy @destroy)
    Spine.bind('drag:start', @proxy @dragStart)
    Spine.bind('drag:enter', @proxy @dragEnter)
    Spine.bind('drag:over', @proxy @dragOver)
    Spine.bind('drag:leave', @proxy @dragLeave)
    Spine.bind('drag:drop', @proxy @dropComplete)
    
  filter: ->
    @query = @input.val();
    @render();
  
  change: (item, mode) ->
    return unless mode is ('' or 'delete')
    @renderOne item, mode
  
  refresh: ->
    @render()
    
  render: ->
    console.log 'Sidebar::render'
#    console.log @query
    items = Gallery.filter(@query, func: 'searchSelect')
    items = items.sort Gallery.nameSort
#    sorted = Gallery.sortByName items
    @list.render items
      
  renderOne: (item, mode) ->
    console.log 'Sidebar::renderOne'
    @list.render item, mode
  
  dragStart: (e, controller) ->
    console.log 'Sidebar::dragStart'
    return unless Spine.dragItem
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
      switch source.constructor.className
        when 'Album'
          Album.trigger('activate', list) unless fromSidebar
        when 'Photo'
          Photo.trigger('activate', list)
      
    @clonedSelection = selection.slice(0)

  dragEnter: (e) =>
    return unless Spine.dragItem
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
      Spine.dragItem.closest.addClass('nodrop')
        

    id = el.attr('id')
    if id and @_id != id
      @_id = id
      Spine.dragItem.closest?.removeClass('over nodrop')

  dragOver: (e) =>

  dragLeave: (e) =>

  dropComplete: (e, record) =>
    console.log 'Sidebar::dropComplete'
    return unless Spine.dragItem
    Spine.dragItem.closest?.removeClass('over nodrop')
    target = Spine.dragItem.closest?.data()?.current?.record or Spine.dragItem.closest?.item()
    source = Spine.dragItem.source
    origin = Spine.dragItem.origin
    
    return unless @validateDrop target, source, origin
    
    switch source.constructor.className
      when 'Album'
        console.log 'Source is Album'
        albums = []
        Album.each (record) =>
          albums.push record unless @clonedSelection.indexOf(record.id) is -1
          
        for album in albums
          album.createJoin(target) if target
          album.destroyJoin(origin) if origin
          
#        Album.createJoin(albums, target)
#        Album.destroyJoin(albums, origin) unless @isCtrlClick(e)
#        Album.trigger('create:join', albums, target)
#        Album.trigger('destroy:join', albums, origin) unless @isCtrlClick(e)
        
      when 'Photo'
        photos = []
        Photo.each (record) =>
          photos.push record unless @clonedSelection.indexOf(record.id) is -1
        
        Photo.trigger('create:join', photos, target)
        Photo.trigger('destroy:join', photos, origin) unless @isCtrlClick(e)
        
        
  validateDrop: (target, source, origin) =>
    return unless target
    switch source.constructor.className
      when 'Album'
        unless target.constructor.className is 'Gallery'
          return false
        unless (origin.id != target.id)
          return false
          
        items = GalleriesAlbum.filter(target.id, key: 'gallery_id')
        for item in items
          if item.album_id is source.id
            return false
        return true
      when 'Photo'
        unless target.constructor.className is 'Album'
          return false
        unless (origin.id != target.id)
          return false
          
        items = AlbumsPhoto.filter(target.id, key: 'album_id')
        for item in items
          if item.photo_id is source.id
            return false
        return true
        
      else return false
  
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
    gallery = new Gallery @newAttributes()
    gallery.save()
    @navigate '/galleries/'
    
  createCallback: ->
#    @navigate '/gallery', @id
    
  createAlbum: ->
    Spine.trigger('create:album')

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
    unless Gallery.count()
      Spine.trigger('show:galleries')
      Gallery.trigger('refresh')

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

module?.exports = Sidebar