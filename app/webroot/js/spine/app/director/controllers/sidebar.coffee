class Sidebar extends Spine.Controller

  @extend Spine.Controller.Drag

  elements:
    'input'                 : 'input'
    '.items'                : 'items'
    '.inner'                : 'inner'
    '.droppable'            : 'droppable'
    '.optAllAlbums'         : 'albums'
    '.optAllPhotos'         : 'photos'

  events:
    "keyup input"           : "filter"
    "click button.create"   : "create"
    'click .optAllGalleries': 'allGalleries'
    'click .optAllAlbums'   : 'allAlbums'
    'click .optAllPhotos'   : 'allPhotos'
    "dblclick .draghandle"  : 'toggleDraghandle'

    'dragstart  .items .item'        : 'dragstart'
    'dragenter  .items .item'        : 'dragenter'
    'dragover   .items .item'        : 'dragover'
    'dragleave  .items .item'        : 'dragleave'
    'drop       .items .item'        : 'drop'
    'dragend    .items .item'        : 'dragend'

#    'dragenter .items .item': 'dragenter'
#    'dragover  .items .item': 'dragover'
#    'dragend   .items .item': 'dragend'
#    'dragleave'             : 'dragleave'
#    'drop'                  : 'drop'

  template: (items) ->
    $("#sidebarTemplate").tmpl(items)

  constructor: ->
    super
    @el.width(350)
    @list = new SidebarList
      el: @items,
      template: @template
      
    Gallery.bind("refresh change", @proxy @render)
    Gallery.bind("ajaxError", Gallery.errorHandler)
    
    Spine.bind('create:gallery', @proxy @create)
    Spine.bind('edit:gallery', @proxy @edit)
    Spine.bind('destroy:gallery', @proxy @destroy)
    Spine.bind('drag:start', @proxy @dragStart)
    Spine.bind('drag:enter', @proxy @dragEnter)
    Spine.bind('drag:over', @proxy @dragOver)
    Spine.bind('drag:leave', @proxy @dragLeave)
    Spine.bind('drag:drop', @proxy @dropComplete)
    Spine.bind('show:allPhotos', @proxy @showAllPhotos)
    Spine.bind('show:allAlbums', @proxy @showAllAlbums)

  filter: ->
    @query = @input.val();
    @render();

  render: (item, mode) ->
    console.log 'Sidebar::render'
    items = Gallery.filter @query, func: 'searchSelect'
    items = items.sort Gallery.nameSort
    @list.render items, item, mode

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
      Spine.dragItem.origin = Gallery.find(id) if id and Gallery.exists(id)
    else
      switch source.constructor.className
        when 'Album'
          selection = Gallery.selectionList()
        when 'Photo'
          selection = Album.selectionList()
      

    # make an unselected item part of selection only if there is nothing selected yet
    if !(source.id in selection)# and !(selection.length)
      source.emptySelection().push source.id
      switch source.constructor.className
        when 'Album'
          Spine.trigger('album:activate') unless fromSidebar
        when 'Photo'
          Spine.trigger('photo:activate')
      
    @clonedSelection = selection.slice(0)

  dragEnter: (e) =>
    return unless Spine.dragItem
    el = $(e.target).closest('.data')
    dataEl = $(e.target).closest('.data')
    data = dataEl.tmplItem?.data or dataEl.data()
    target = el.data()?.current?.record or el.item()
    source = Spine.dragItem?.source
    origin = Spine.dragItem?.origin or Gallery.record
    Spine.dragItem.closest?.removeClass('over nodrop')
    Spine.dragItem.closest = el
    if @validateDrop target, source, origin
      Spine.dragItem.closest.addClass('over')
    else
      Spine.dragItem.closest.addClass('over nodrop')
        

    id = el.attr('id')
    if id and @_id != id
      @_id = id
      Spine.dragItem.closest?.removeClass('over')

  dragOver: (e) =>

  dragLeave: (e) =>

  dropComplete: (e) =>
    console.log 'Sidebar::dropComplete'
    return unless Spine.dragItem
    Spine.dragItem.closest.removeClass('over nodrop')
    target = Spine.dragItem.closest.data()?.current?.record or Spine.dragItem.closest.item()
    source = Spine.dragItem.source
    origin = Spine.dragItem.origin
    
    return unless @validateDrop target, source, origin
    
    switch source.constructor.className
      when 'Album'
        console.log 'Source is Album'
        albums = []
        Album.each (record) =>
          albums.push record unless @clonedSelection.indexOf(record.id) is -1

        Album.trigger('create:join', target, albums)
        Album.trigger('destroy:join', origin, albums) unless @isCtrlClick(e)
        
      when 'Photo'
        photos = []
        Photo.each (record) =>
          photos.push record unless @clonedSelection.indexOf(record.id) is -1

        Photo.trigger('create:join', target, photos)
        Photo.trigger('destroy:join', origin, photos) unless @isCtrlClick(e)
        
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

  create: ->
    console.log 'Sidebar::create'
    @openPanel('gallery', App.showView.btnGallery)
    gallery = new Gallery @newAttributes()
    gallery.save()

  destroy: ->
    console.log 'Sidebar::destroy'
    if Gallery.record
      gas = GalleriesAlbum.filter(Gallery.record.id, key: 'gallery_id')
      for ga in gas
        Spine.Ajax.disable ->
          ga.destroy()
      Gallery.record.destroy()
      Gallery.current() if !Gallery.count()

  edit: ->
    App.galleryEditView.render()
    App.contentManager.change(App.galleryEditView)

  toggleDraghandle: (options) ->
    return if options?.close and App.vmanager.sleep
      
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
  
  allGalleries: ->
    Spine.trigger('show:galleries')
  
  allAlbums: ->
    Spine.trigger('show:allAlbums', true)
    
  allPhotos: ->
    Spine.trigger('show:allPhotos', true)
    
  showAllPhotos: (deselect=false) ->
    Spine.trigger('show:photos')
    if deselect
      @list.deselect()
      console.log @list
      Album.emptySelection()
#    @showAllAlbums(deselect)
    Spine.trigger('gallery:activate', false)
    Spine.trigger('album:activate', false)
    
  showAllAlbums: (deselect=false) ->
    Spine.trigger('show:albums')
    if deselect
      @list.deselect()
      console.log @list
      Gallery.emptySelection()
    Spine.trigger('gallery:activate', false)
    