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

    Gallery.bind("refresh change", @proxy @render)
    Spine.bind('render:count', @proxy @renderCount)
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
    @galleryItems = items
    @list.render items

  renderCount: ->
    for item in @galleryItems
      $('#'+item.id).html(Album.filter(item.id).length)

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
    #return if target.id is @oldtargetID
    #@oldtargetID = target.id
    $('li').removeClass('nodrop')


  dropComplete: (source, target) ->
    console.log 'dropComplete'

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

    
    selection = Gallery.selectionList()
    newSelection = selection.slice(0)
    newSelection.push source.id unless source.id in selection
      
    albums = []
    Album.each (record) ->
      albums.push record unless newSelection.indexOf(record.id) is -1
    
    currentTarget = Gallery.record
    Spine.trigger('create:albumJoin', target, albums)
    target.save()
    console.log selection
    
  newAttributes: ->
    name: 'New Gallery'
    author: 'No Author'

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