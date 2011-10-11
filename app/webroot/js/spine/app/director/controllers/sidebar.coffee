Spine ?= require("spine")
$      = Spine.$

class SidebarView extends Spine.Controller

  @extend Spine.Controller.Drag

  elements:
    'input'                 : 'input'
    '.items'                : 'items'
    '.droppable'            : 'droppable'

  #Attach event delegation
  events:
    "click button"          : "create"
    "keyup input"           : "filter"
    "dblclick .draghandle"  : 'toggleDraghandle'

    'dragstart          .items .item'         : 'dragstart'
    'dragenter          .items .item'         : 'dragenter'
    'dragover           .items .item'         : 'dragover'
    'dragleave          .items .item'         : 'dragleave'
    'drop               .items .item'         : 'drop'
    'dragend            .items .item'         : 'dragend'

  #Render template
  template: (items) ->
    $("#galleriesTemplate").tmpl(items)

  subListTemplate: (items) -> $('#albumsSubListTemplate').tmpl(items)

  constructor: ->
    super
    @list = new Spine.GalleryList
      el: @items,
      template: @template

    Gallery.bind("refresh change", @proxy @render)
    Spine.bind('render:galleryItem', @proxy @renderItem)
    Spine.bind('render:subList', @proxy @renderSubList)
    Spine.bind('create:gallery', @proxy @create)
    Spine.bind('destroy:gallery', @proxy @destroy)
    Spine.bind('drag:start', @proxy @dragStart)
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
    for item in @galleryItems
      $('#'+item.id+' span.cta').html(Album.filter(item.id).length)
      @renderSubList item.id

  renderSubList: (id) ->
    albums = Album.filter(id)
    $('#sub-'+id).html @subListTemplate(albums)

  dragStart: (e) ->
    console.log 'Sidebar::dragStart'
    # check for drags from sublist
    if $(e.target).parent()[0].id
      raw = $(e.target).parent()[0].id
      id = raw.replace ///(^sub-)()///, ''
      Spine.dragItem.origin = Gallery.find(id) if id and Gallery.exists(id)
      selection = []
    else
      selection = Gallery.selectionList()

    @newSelection = selection.slice(0)
    @newSelection.push Spine.dragItem.source.id unless Spine.dragItem.source.id in selection

  dragOver: (e) ->
    target = $(e.target).item()
    $(e.target).removeClass('nodrop')
    items = GalleriesAlbum.filter(target.id)
    for item in items
      if item.album_id in @newSelection
        $(e.target).addClass('nodrop')

  dragLeave: (e) ->
    return

  dropComplete: (target, e) ->
    console.log 'Sidebar::dropComplete'

    source = Spine.dragItem.source
    origin = Spine.dragItem.origin or Gallery.record

    unless source instanceof Album
      alert 'You can only drop Albums here'
      return
    unless target instanceof Gallery
      return

    items = GalleriesAlbum.filter(target.id)
    for item in items
      if item.album_id is source.id
        alert 'Album already exists in Gallery'
        return

    albums = []
    Album.each (record) =>
      albums.push record unless @newSelection.indexOf(record.id) is -1
    
    Spine.trigger('create:albumJoin', target, albums)
    Spine.trigger('destroy:albumJoin', origin, albums) unless @isCtrlClick(e)
    
  newAttributes: ->
    name: 'New Gallery'
    author: 'No Author'

  create: ->
    console.log 'Sidebar::create'
    @openPanel('gallery', App.albumsShowView.btnGallery)
    gallery = new Gallery @newAttributes()
    gallery.save()

  destroy: ->
    console.log 'Sidebar::destroy'
    Gallery.record.destroy()
    Gallery.current() if !Gallery.count()

  toggleDraghandle: ->
    width = =>
      width =  @el.width()
      max = App.vmanager.max()
      min = App.vmanager.min
      if width >= min and width < max-20
        max+"px"
      else
        min+'px'
    
    @el.animate
      width: width()
      400

module?.exports = SidebarView