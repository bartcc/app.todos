Spine ?= require("spine")
$      = Spine.$

class SidebarView extends Spine.Controller

  @extend Spine.Controller.Drag

  elements:
    'input'                 : 'input'
    '.items'                : 'items'
    '.droppable'            : 'droppable'
    '.inner'                : 'inner'

  #Attach event delegation
  events:
    "click button"          : "create"
    "keyup input"           : "filter"
    "dblclick .draghandle"  : 'toggleDraghandle'

    'dragstart .items .item': 'dragstart'
    'dragenter .items .item': 'dragenter'
    'dragover  .items .item': 'dragover'
    'dragleave .items .item': 'dragleave'
    'drop      .items .item': 'drop'
    'dragend   .items .item': 'dragend'

  #Render template
  template: (items) ->
    $("#galleriesTemplate").tmpl(items)

  subListTemplate: (items) -> $('#albumsSubListTemplate').tmpl(items)

  constructor: ->
    super
    @el.width(300)
    @list = new GalleryList
      el: @items,
      template: @template
    Gallery.bind("refresh change", @proxy @render)
    Gallery.bind("ajaxError", Gallery.errorHandler)
    Spine.bind('render:galleryItem', @proxy @renderItem)
    Spine.bind('render:subList', @proxy @renderSubList)
    Spine.bind('create:gallery', @proxy @create)
    Spine.bind('destroy:gallery', @proxy @destroy)
    Spine.bind('drag:start', @proxy @dragStart)
    Spine.bind('drag:enter', @proxy @dragEnter)
    Spine.bind('drag:leave', @proxy @dragLeave)
    Spine.bind('drag:drop', @proxy @dropComplete)

  filter: ->
    @query = @input.val();
    @render();

  render: (item, mode) ->
    console.log 'Sidebar::render'
    items = Gallery.filter @query, 'searchSelect'
    items = items.sort Gallery.nameSort
    @galleryItems = items
    @list.render items, item, mode

  renderItem: ->
    console.log 'Sidebar::renderItem'
    for item in @galleryItems
      $('.cta', '#'+item.id).html(Album.filter(item.id).length)
      @renderSubList item.id

  renderSubList: (id) ->
    albums = Album.filter(id)
    $('#sub-'+id).html @subListTemplate(albums)

  dragStart: (e) ->
    console.log 'Sidebar::dragStart'
    el = $(e.target)
    # check for drags from sublist
    if el.parent()[0].id
      fromSidebar = true
      parent_id = el.parent()[0].id
      id = parent_id.replace ///(^sub-)()///, ''
      Spine.dragItem.origin = Gallery.find(id) if id and Gallery.exists(id)
      selection = []
    else
      selection = Gallery.selectionList()

    # make an unselected item part of selection
    unless Spine.dragItem.source.id in selection and selection.length
      selection.push Spine.dragItem.source.id
      Spine.trigger('exposeSelection', selection) unless fromSidebar
      
    @clonedSelection = selection.slice(0)

  dragEnter: (e) ->
    el = $(e.target)
    target = el.item()
    if target
      #$(e.target).removeClass('nodrop')
      items = GalleriesAlbum.filter(target.id)
      for item in items
        if item.album_id in @clonedSelection
          el.addClass('nodrop')
    else
      console.log 'no target.id'
      console.log el

  dragLeave: (e) ->
    return

  dropComplete: (target, e) ->
    console.log 'Sidebar::dropComplete'

    source = Spine.dragItem?.source
    origin = Spine.dragItem?.origin or Gallery.record

    unless source instanceof Album
      alert 'You should only drop Albums here'
      return
    unless (target instanceof Gallery)
      return
    unless (origin.id != target.id)
      return

    items = GalleriesAlbum.filter(target.id)
    for item in items
      if item.album_id is source.id
        alert 'Album already exists in Gallery'
        return

    albums = []
    Album.each (record) =>
      albums.push record unless @clonedSelection.indexOf(record.id) is -1
    
    Spine.trigger('create:albumJoin', target, albums)
    Spine.trigger('destroy:albumJoin', origin, albums) unless @isCtrlClick(e)
    
  newAttributes: ->
    if User.first()
      name    : 'New Gallery'
      author  : User.first().name
      user_id : User.first().id
    else
      User.ping()

  create: ->
    console.log 'Sidebar::create'
    @openPanel('gallery', App.albumsShowView.btnGallery)
    gallery = new Gallery @newAttributes()
    gallery.save()

  destroy: ->
    console.log 'Sidebar::destroy'
    Gallery.record.destroy() if Gallery.record
    Gallery.current() if !Gallery.count()

  toggleDraghandle: ->
    
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
      speed#speed
      => @clb()

module?.exports = SidebarView