Spine ?= require("spine")
$      = Spine.$

class SidebarView extends Spine.Controller

  @extend Spine.Controller.Drag

  elements:
    'input'   : 'input'
    '.items'  : 'items'
    '.droppable':  'droppable'

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
      albums = Album.filter(item.id)
      $('#'+item.id+' span.cta').html(Album.filter(item.id).length)
      @renderSubList item.id

  renderSubList: (id) ->
    albums = Album.filter(id)
    $('#sub-'+id).html @subListTemplate(albums)

  dragStart: ->
    selection = Gallery.selectionList()
    newSelection = selection.slice(0)
    newSelection.push Spine.dragItem.id unless Spine.dragItem.id in selection
    @newSelection = newSelection
    @oldtargetID = null

  dragOver: (e) ->
    target = $(e.target).item()
    return if target.id is @oldtargetID
    @oldtargetID = target.id
    items = GalleriesAlbum.filter(target.id)
    for item in items
      if item.album_id in @newSelection
        $(e.target).addClass('nodrop')
        

  dragLeave: (e) ->
    target = $(e.target).item()
    return if target.id is @oldtargetID
    @oldtargetID = target.id
    $('li').removeClass('nodrop')


  dropComplete: (target, e) ->
    console.log 'dropComplete'

    source = Spine.dragItem
    origin = Gallery.record

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
    
    console.log e
    Spine.trigger('create:albumJoin', target, albums)
    Spine.trigger('destroy:albumJoin', origin, albums) unless e.metaKey
    
  newAttributes: ->
    name: 'New Gallery'
    author: 'No Author'

  #Called when 'Create' button is clicked
  create: (e) ->
    e.preventDefault()
    @preserveEditorOpen('gallery', App.albumsShowView.btnGallery)
    gallery = new Gallery @newAttributes()
    gallery.save()

  destroy_: (item) ->
    console.log 'AlbumsEditView::destroy'
    return unless Gallery.record
    item.destroy()
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