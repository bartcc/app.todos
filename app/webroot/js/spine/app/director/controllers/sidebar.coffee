Spine ?= require("spine")
$      = Spine.$

class SidebarView extends Spine.Controller

  @extend Spine.Controller.Drag

  elements:
    'input'                 : 'input'
    '.items'                : 'items'
    '.droppable'            : 'droppable'
    '.inner'                : 'inner'

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
    Spine.bind('drag:over', @proxy @dragOver)
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
    console.log 'Sidebar::renderSubList'
    albums = Album.filter(id)
    # inject albums count
    albums.push {flash: 'no albums'} unless albums.length
    $('#'+id+' ul').html @subListTemplate(albums)

  dragStart: (e, controller) ->
    console.log 'Sidebar::dragStart'
    el = $(e.target)
    event = e.originalEvent
    Spine.dragItem.targetEl = null

    # check for drags from sublist and set its origin
    if el.parents('ul.sublist').length
      id = el.parents('li.item')[0].id
      Spine.dragItem.origin = Gallery.find(id) if id and Gallery.exists(id)
      fromSidebar = true
      selection = []
    else
      selection = Gallery.selectionList()

    # make an unselected item part of selection only if there is nothing selected yet
    if !(Spine.dragItem.source.id in selection) and !(selection.length)
      selection.push Spine.dragItem.source.id
      Spine.trigger('exposeSelection', selection) unless fromSidebar
      
    @clonedSelection = selection.slice(0)
    if @clonedSelection.length > 1
      if @isCtrlClick(e)
        event.dataTransfer.setDragImage(App.ALBUM_DOUBLE_COPY, 60, 60)
      else
        event.dataTransfer.setDragImage(App.ALBUM_DOUBLE_MOVE, 60, 60)
    if @clonedSelection.length == 1
      if @isCtrlClick(e)
        event.dataTransfer.setDragImage(App.ALBUM_SINGLE_COPY, 60, 60)
      else
        event.dataTransfer.setDragImage(App.ALBUM_SINGLE_MOVE, 60, 60)
        

  dragEnter: (e) =>
    console.log 'Sidebar::dragEnter'
    el = $(e.target)

    # hack because e.relaedTarget is not implemented in webkit's dragleave event
    closest = (el.closest('.item')) or []
    if closest.length
      id = closest.attr('id')
      target = closest.item()
      source = Spine.dragItem?.source
      origin = Spine.dragItem?.origin or Gallery.record

      Spine.dragItem.closest?.removeClass('over nodrop')
      Spine.dragItem.closest = closest
      if @validateDrop target, source, origin
        Spine.dragItem.closest.addClass('over')
      else
        Spine.dragItem.closest.addClass('over nodrop')
        

    if id and @_id != id
      @_id = id
      Spine.dragItem.closest?.removeClass('over')

  dragOver: (e) =>

  dragLeave: (e) =>

  dropComplete: (target, e) =>
    console.log 'Sidebar::dropComplete'
    Spine.dragItem.closest?.removeClass('over nodrop')
    source = Spine.dragItem?.source
    origin = Spine.dragItem?.origin or Gallery.record
    
    return unless @validateDrop target, source, origin

    albums = []
    Album.each (record) =>
      albums.push record unless @clonedSelection.indexOf(record.id) is -1
    
    Spine.trigger('create:albumJoin', target, albums)
    Spine.trigger('destroy:albumJoin', origin, albums) unless @isCtrlClick(e)
    
  validateDrop: (target, source, origin) =>
    unless (source instanceof Album)
      return false
    unless (target instanceof Gallery)
      return false
    unless (origin.id != target.id)
      return false

    items = GalleriesAlbum.filter(target.id)
    for item in items
      if item.album_id is source.id
        return false
    return true

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
        return @galleryName(proposal + '_1')
    return proposal

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
      speed
      => @clb()

module?.exports = SidebarView