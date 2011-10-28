Spine ?= require("spine")
$      = Spine.$

class AlbumsShowView extends Spine.Controller
  
  @extend Spine.Controller.Drag
  @extend Spine.Controller.Toolbars
  
  elements:
    ".content"                : "content"
    "#views .views"           : "views"
    ".content .sortable"      : "sortable"
    '.optEditGallery'         : 'btnEditGallery'
    '.optCreateGallery'       : 'btnCreateGallery'
    '.optDestroyGallery'      : 'btnDestroyGallery'
    '.optGallery'             : 'btnGallery'
    '.optAlbum'               : 'btnAlbum'
    '.optUpload'              : 'btnUpload'
    '.optGrid'                : 'btnGrid'
    '.content .items'         : 'items'
    '.content .items .item'   : 'item'
    '.header'                 : 'header'
    '.toolbar'                : 'toolBar'
    
  events:
    "click .optCreateAlbum"           : "createAlbum"
    "click .optDestroyAlbum"          : "destroyAlbum"
    "click .optEditGallery"           : "editGallery"
    "click .optCreateGallery"         : "createGallery"
    "click .optDestroyGallery"        : "destroyGallery"
    "click .optEmail"                 : "email"
    "click .optGallery"               : "toggleGallery"
    "click .optAlbum"                 : "toggleAlbum"
    "click .optUpload"                : "toggleUpload"
    "click .optGrid"                  : "toggleGrid"
    'dblclick .draghandle'            : 'toggleDraghandle'
    'sortupdate .items'               : 'sortupdate'
    'dragstart  .items .thumbnail'    : 'dragstart'
    'dragenter  .items .thumbnail'    : 'dragenter'
    'dragover   .items .thumbnail'    : 'dragover'
    'dragleave  .items .thumbnail'    : 'dragleave'
    'drop       .items .thumbnail'    : 'drop'
    'dragend    .items .thumbnail'    : 'dragend'
    'dragenter  .content'             : 'dragenter'
    'dragover   .content'             : 'dragover'
    'dragleave  .content'             : 'dragleave'
    'drop       .content'             : 'drop'
    'dragend    .content'             : 'dragend'

  albumsTemplate: (items) ->
    $("#albumsTemplate").tmpl items

  toolsTemplate: (items) ->
    $("#toolsTemplate").tmpl items

  headerTemplate: (items) ->
    $("#headerTemplate").tmpl items
 
  constructor: ->
    super
    @list = new AlbumList
      el: @items
      template: @albumsTemplate
            
    Album.bind("ajaxError", Album.errorHandler)
    Spine.bind('create:album', @proxy @create)
    Spine.bind('destroy:album', @proxy @destroy)
    Spine.bind("destroy:albumJoin", @proxy @destroyJoin)
    Spine.bind("create:albumJoin", @proxy @createJoin)
    Album.bind("update", @proxy @render)
    Album.bind("destroy", @proxy @render)
    Spine.bind('change:selectedGallery', @proxy @change)
    Spine.bind('change:toolbar', @proxy @changeToolbar)
    GalleriesAlbum.bind("change", @proxy @render)
    @bind("toggle:view", @proxy @toggleView)
    @bind('render:toolbar', @proxy @renderToolbar)
    
    @changeToolbar @toolbar if @toolbar
    @activeControl = @btnGallery
    @create = @edit = @editGallery
    @show = @showGallery

    $(@views).queue("fx")

  children: (sel) ->
    @el.children(sel)

  change: (item, mode) ->
    console.log 'AlbumsShowView::change'
    @current = item
    @render()
    @[mode]?(item)

  render: (items, mode) ->
    console.log 'AlbumsShowView::render'
    
    Spine.trigger('render:galleryItem')
    
    if (!@current) or (@current.destroyed)
      items = Album.filter()
    else
      items = Album.filter(@current.id)
      
    
    # make .content element sensitive for drop by injecting target of type Gallery
    tmplItem = $.tmplItem(@content)
    tmplItem.data = Gallery.record or {}
    
    @list.render items
    @renderHeader items
    #@initSortables() #interferes with html5 dnd!
   
  renderHeader: (items) ->
    console.log 'AlbumsShowView::renderHeader'
    values = {record: Gallery.record, count: items.length}
    @header.html @headerTemplate values

  renderToolbar: ->
    console.log 'AlbumsShowView::renderToolbar'
    @toolBar.html @toolsTemplate @currentToolBar
    @refreshElements()
  
  initSortables: ->
    sortOptions = {}
    @items.sortable sortOptions

  newAttributes: ->
    if User.first()
      title   : 'New Title'
      user_id : User.first().id
    else
      User.ping()
  
  create: ->
    console.log 'AlbumsShowView::create'
    Gallery.emptySelection()
    album = new Album(@newAttributes())
    album.save()
    Gallery.updateSelection([album.id])
    @render album
    Spine.trigger('create:albumJoin', Gallery.record, album) if Gallery.record
    @openPanel('album', App.albumsShowView.btnAlbum)

  destroy: ->
    console.log 'AlbumsShowView::destroy'
    list = Gallery.selectionList().slice(0)
    albums = []
    Album.each (record) =>
      albums.push record unless list.indexOf(record.id) is -1
      
    if Gallery.record
      Gallery.emptySelection()
      Spine.trigger('destroy:albumJoin', Gallery.record, albums)
    else
      for album in albums
        if Album.exists(album.id)
          Album.removeFromSelection(Gallery, album.id)
          album.destroy() 
        

  createJoin: (target, albums) ->
    console.log 'AlbumsShowView::createJoin'
    return unless target and target instanceof Gallery

    unless Album.isArray albums
      records = []
      records.push(albums)
    else records = albums

    for record in records
      ga = new GalleriesAlbum
        gallery_id: target.id
        album_id: record.id
      ga.save()

    target.save()
  
  destroyJoin: (target, albums) ->
    console.log 'AlbumsShowView::destroyJoin'
    return unless target and target instanceof Gallery

    unless Album.isArray albums
      records = []
      records.push(albums)
    else records = albums

    albums = Album.toID(records)

    gas = GalleriesAlbum.filter(target.id)
    for ga in gas
      unless albums.indexOf(ga.album_id) is -1
        Album.removeFromSelection Gallery, ga.album_id
        ga.destroy()

    target.save()

  createAlbum: (e) ->
    console.log 'AlbumsShowView::createAlbum'
    Spine.trigger('create:album') unless $(e.currentTarget).hasClass('disabled')
  
  destroyAlbum: (e) ->
    Spine.trigger('destroy:album') unless $(e.currentTarget).hasClass('disabled')

  showGallery: ->
    App.albumsManager.change(App.albumsShowView)

  editGallery: (e) ->
    return if $(e.currentTarget).hasClass('disabled')
    App.albumsEditView.render()
    App.albumsManager.change(App.albumsEditView)
    #@focusFirstInput App.albumsEditView.el

  createGallery: (e) ->
    return if $(e.currentTarget).hasClass('disabled')
    Spine.trigger('create:gallery')
  
  destroyGallery: (e) ->
    return if $(e.currentTarget).hasClass('disabled')
    Spine.trigger('destroy:gallery')
  
  email: ->
    return if ( !@current.email ) 
    window.location = "mailto:" + @current.email

  renderViewControl: (controller, controlEl) ->
    active = controller.isActive()

    $(".options .opt").each ->
      if(@ == controlEl)
        $(@).toggleClass("active", active)
      else
        $(@).removeClass("active")

  animateView: ->
    hasActive = ->
      if App.hmanager.hasActive()
        return App.hmanager.enableDrag()
      App.hmanager.disableDrag()
    
    
    height = ->
      App.hmanager.currentDim
      if hasActive() then parseInt(App.hmanager.currentDim)+"px" else "8px"
    
    @views.animate
      height: height()
      400

  toggleGallery: (e) ->
    @changeToolbar Gallery
    @trigger("toggle:view", App.gallery, e.target)

  toggleAlbum: (e) ->
    @changeToolbar Album
    @trigger("toggle:view", App.album, e.target)

  toggleUpload: (e) ->
    @changeToolbar 'Upload'
    @trigger("toggle:view", App.upload, e.target)

  toggleGrid: (e) ->
    @changeToolbar 'Grid'
    @trigger("toggle:view", App.grid, e.target)

  toggleView: (controller, control) ->
    isActive = controller.isActive()
    
    if(isActive)
      App.hmanager.trigger("change", false)
    else
      @activeControl = $(control)
      App.hmanager.trigger("change", controller)
    
    @renderViewControl controller, control
    @animateView()
  
  toggleDraghandle: ->
    @activeControl.click()
    
module?.exports = AlbumsShowView