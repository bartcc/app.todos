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

  constructor: ->
    super
    @list = new Spine.GalleryList
      el: @items,
      template: @template

    Gallery.bind "refresh change", @proxy @render
    Spine.bind('drag:drop', @proxy @dropComplete)
    Spine.bind('drag:over', @proxy @dragOver)
    Spine.bind('drag:leave', @proxy @dragLeave)

  filter: ->
    @query = @input.val();
    @render();

  render: (item) ->
    console.log 'Sidebar::render'
    items = Gallery.filter @query, 'searchSelect'
    items = items.sort Gallery.nameSort
    @list.render items, item

  dragOver: (e) ->
    target = $(e.target).item()
    return if target.id is @oldtargetID
    @oldtargetID = target.id
    items = GalleriesAlbum.filter(target.id)
    for item in items
      if item.album_id is Spine.dragItem.id
        $(e.target).addClass('nodrop')

  dragLeave: (e) ->
    target = $(e.target).item()
    return if target.id is @oldtargetID
    @oldtargetID = target.id
    #$(e.target).removeClass('nodrop')


  dropComplete: (source, target) ->
    console.log 'dropComplete'
    items = GalleriesAlbum.filter(target.id)
    for item in items
      if item.album_id is source.id
        albumExists = true

    if albumExists
      alert 'Album already exists in Gallery'
      return
    unless source instanceof Album
      alert 'You can only drop Albums here'
      return
    
    selection = Gallery.selectionList()
    selected = source.id in selection
    selection.push source.id unless selected
      
    albums = []
    Album.each (record) ->
      albums.push record unless selection.indexOf(record.id) is -1
    
    Gallery.current(target)
    target.constructor.updateSelection selection
    Spine.trigger('create:albumJoin', albums)
    target.save()
    
  newAttributes: ->
    name: 'New Gallery'
    author: ''

  #Called when 'Create' button is clicked
  create: (e) ->
    e.preventDefault()
    @preserveEditorOpen('gallery', App.albumsShowView.btnGallery)
    gallery = new Gallery @newAttributes()
    gallery.save()
  
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