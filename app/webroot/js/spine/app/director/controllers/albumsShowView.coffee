Spine ?= require("spine")
$      = Spine.$

class AlbumsShowView extends Spine.Controller
  
  @extend Spine.Controller.Drag
  
  elements:
    ".content"                : "showContent"
    "#views .views"           : "views"
    ".content .sortable"      : "sortable"
    '.optGallery'             : 'btnGallery'
    '.optAlbum'               : 'btnAlbum'
    '.optUpload'              : 'btnUpload'
    '.optGrid'                : 'btnGrid'
    '.content .items'         : 'items'
    '.content .items .item'   : 'item'
    '.header'                 : 'header'
    '.toolbar'                : 'toolBar'
    
  events:
    "click .optCreateAlbum"                   : "create"
    "click .optDeleteAlbum"                   : "destroy"
    "click .optEdit"                          : "edit"
    "click .optEmail"                         : "email"
    "click .optGallery"                       : "toggleGallery"
    "click .optAlbum"                         : "toggleAlbum"
    "click .optUpload"                        : "toggleUpload"
    "click .optGrid"                          : "toggleGrid"
    'dblclick .draghandle'                    : 'toggleDraghandle'
    'sortupdate         .items'               : 'sortupdate'
    'dragstart          .items .item'         : 'dragstart'
    'dragenter          .items .item'         : 'dragenter'
    'dragover           .items .item'         : 'dragover'
    'dragleave          .items .item'         : 'dragleave'
    'drop               .items .item'         : 'drop'
    'dragend            .items .item'         : 'dragend'

  albumsTemplate: (items) ->
    $("#albumsTemplate").tmpl items

  toolsTemplate: (items) ->
    $("#toolsTemplate").tmpl items

  constructor: ->
    super
    @list = new Spine.AlbumList
      el: @items,
      template: @albumsTemplate
    Album.bind("create", @proxy @createJoin)
    Album.bind("destroy", @proxy @destroyJoin)
    Spine.bind("destroy:albumJoin", @proxy @destroyJoin)
    Spine.bind("create:albumJoin", @proxy @createJoin)
    Album.bind("change", @proxy @render)
    Gallery.bind("update", @proxy @renderHeader)
    Spine.bind('save:gallery', @proxy @save)
    Spine.bind('change:selectedGallery', @proxy @change)
    GalleriesAlbum.bind("destroy", @proxy @confirmed)
    GalleriesAlbum.bind("change", @proxy @render)
    @bind('save:gallery', @proxy @save)
    @bind("toggle:view", @proxy @toggleView)

    @toolBarList = []

    @create = @edit

    $(@views).queue("fx")

  confirmed: (ga) ->
    #alert 'Success! ' + Album.filter(Gallery.record.id).length + ' / ' + Gallery.record.id if ga.destroyed
    alert ga.name + 'NOT destroyed' unless ga.destroyed

  children: (sel) ->
    @el.children(sel)

  loadJoinTables: ->
    AlbumsImage.records = Album.joinTableRecords

  change: (item, mode) ->
    console.log 'AlbumsShowView::change'
    console.log mode if mode
    @current = item
    @render()
    @[mode]?(item)

  render: (album) ->
    console.log 'AlbumsShowView::render'
    
    if @current
      items = Album.filter(@current.id)
    else
      items = Album.filter()
    
    @renderHeader()
    @list.render items, (album if album instanceof Album)
    #@initSortables()
   
  renderHeader: (item) ->
    console.log 'AlbumsShowView::renderHeader'
    gallery = item or @current
    if gallery
      @header.html '<h2>Albums for Gallery ' + gallery.name + '</h2>'
    else
      @header.html '<h2>All Albums (Originals)</h2>'

  renderToolBar: ->
    @toolBar.html @toolsTemplate @toolBarList
    @refreshElements()
  
  initSortables: ->
    sortOptions = {}
    @sortable.sortable sortOptions

  create: ->
    Spine.trigger('createAlbum')
  
  destroy: ->
    Spine.trigger('destroyAlbum')
  
  createJoin: (albums) ->
    console.log 'AlbumsShowView::createJoin'
    return unless Gallery.record
    unless Album.isArray albums
      records = []
      records.push(albums)
    else records = albums.slice()
    for record in records
      ga = new GalleriesAlbum
        gallery_id: Gallery.record.id
        album_id: record.id
      ga.save()
  
  destroyJoin: (album) ->
    console.log 'AlbumsShowView::destroyJoin'
    GalleriesAlbum.each (record) ->
      if record.gallery_id is Gallery.record.id and album.id is record.album_id
        record.destroy()

  edit: ->
    App.albumsEditView.render()
    App.albumsManager.change(App.albumsEditView)

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

    @toolBar.empty() unless App.hmanager.hasActive()

  animateView: ->
    hasActive = ->
      if App.hmanager.hasActive()
        return App.hmanager.enableDrag()
      App.hmanager.disableDrag()
    
    
    height = ->
      if hasActive() then parseInt(App.hmanager.currentDim)+"px" else "7px"
    
    @views.animate
      height: height()
      400

  toggleGallery: (e) ->
    @toolBarList = [
      {name: 'Show Gallery', klass: 'optEdit'}
      {name: 'Edit Gallery', klass: 'optEdit'}
    ]
    @trigger("toggle:view", App.gallery, e.target)

  toggleAlbum: (e) ->
    @toolBarList = [
      {name: 'Create Album', klass: 'optCreateAlbum'}
      {name: 'Delete Album', klass: 'optDeleteAlbum'}
    ]
    @trigger("toggle:view", App.album, e.target)

  toggleUpload: (e) ->
    @toolBarList = [
      {name: 'Show Upload', klass: 'optEdit'}
      {name: 'Edit Upload', klass: 'optEdit'}
    ]
    @trigger("toggle:view", App.upload, e.target)

  toggleGrid: (e) ->
    @toolBarList = [
      {name: 'Show Grid', klass: 'optEdit'}
      {name: 'Edit Grid', klass: 'optEdit'}
    ]
    @trigger("toggle:view", App.grid, e.target)

  toggleView: (controller, control) ->
    isActive = controller.isActive()
    
    if(isActive)
      App.hmanager.trigger("change", false)
    else
      @activeControl = $(control)
      App.hmanager.trigger("change", controller)
    
    @renderToolBar()
    @renderViewControl controller, control
    @animateView()
  
  toggleDraghandle: ->
    @activeControl.click()

module?.exports = AlbumsView