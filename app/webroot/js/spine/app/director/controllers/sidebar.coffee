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
    Spine.bind('drag:dropped', @proxy @dropComplete)

  filter: ->
    @query = @input.val();
    @render();

  render: (item) ->
    console.log 'Sidebar::render'
    items = Gallery.filter @query, 'searchSelect'
    items = items.sort Gallery.nameSort
    @list.render items, item

  dropComplete: (source, target) ->
    console.log 'dropComplete'
    items = GalleriesAlbum.filter(target.id)
    console.log items.length
    for item in items
      if item.album_id is source.id
        albumExists = true

    if albumExists
      alert 'Album already exists in Gallery'
      return
    unless source instanceof Album
      alert 'You can only drop Albums here'
      return

    ga = new GalleriesAlbum
      album_id: source.id
      gallery_id: target.id
    ga.save()
    console.log ga
    Gallery.current(target)
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