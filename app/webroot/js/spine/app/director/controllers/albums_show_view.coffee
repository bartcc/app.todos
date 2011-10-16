Spine ?= require("spine")
$      = Spine.$

class AlbumsShowView extends Spine.Controller
  
  @extend Spine.Controller.Drag
  
  elements:
    ".content"                : "showContent"
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
    "click .optCreateAlbum"                   : "createAlbum"
    "click .optDestroyAlbum"                  : "destroyAlbum"
    "click .optEditGallery"                   : "editGallery"
    "click .optCreateGallery"                 : "createGallery"
    "click .optDestroyGallery"                : "destroyGallery"
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

  headerTemplate: (items) ->
    $("#headerTemplate").tmpl items

  constructor: ->
    super
    @list = new Spine.AlbumList
      el: @items,
      template: @albumsTemplate
    Spine.bind('create:album', @proxy @create)
    Spine.bind('destroy:album', @proxy @destroy)
    Spine.bind("destroy:albumJoin", @proxy @destroyJoin)
    Spine.bind("create:albumJoin", @proxy @createJoin)
    Album.bind("change", @proxy @render)
    Spine.bind('change:selectedGallery', @proxy @change)
    Spine.bind('change:selectedAlbum', @proxy @renderToolbar)
    Spine.bind('change:selection', @proxy @changeSelection)
    GalleriesAlbum.bind("change", @proxy @render)
    @bind("toggle:view", @proxy @toggleView)

    @activeControl = @btnGallery
    @create = @edit = @editGallery

    $(@views).queue("fx")

  children: (sel) ->
    @el.children(sel)

  change: (item, mode) ->
    console.log 'AlbumsShowView::change'
    console.log mode if mode
    @current = item
    @render()
    @[mode]?(item)

  render: (item) ->
    console.log 'AlbumsShowView::render'
    Spine.trigger('render:galleryItem')
    
    if @current
      items = Album.filter(@current.id)
    else
      items = Album.filter()
    
    @renderHeader(items)
    @renderToolbar()
    @list.render items, item
    #@initSortables() #interferes with html5 dnd!
   
  renderHeader: (items) ->
    console.log 'AlbumsShowView::renderHeader'
    values = {record: Gallery.record, count: items.length}
    if Gallery.record
      @header.html @headerTemplate values
    else
      @header.html '<h3>Album Originals</h3><h2>All Albums</h2>'

  renderToolbar: ->
    console.log 'AlbumsShowView::renderToolbar'
    @toolBar.html @toolsTemplate @toolBarList()
    @refreshElements()
  
  toolBarList: -> arguments[0]

  initSortables: ->
    sortOptions = {}
    @items.sortable sortOptions

  newAttributes: ->
    title: 'New Title'
    name: 'New Album'

  create: ->
    console.log 'AlbumList::create'
    album = new Album(@newAttributes())
    album.save()
    Spine.trigger('create:albumJoin', Gallery.record, album)
    @openPanel('album', App.albumsShowView.btnAlbum)

  destroy: ->
    console.log 'AlbumList::destroy'
    list = Gallery.selectionList().slice(0)
    albums = []
    Album.each (record) =>
      albums.push record unless list.indexOf(record.id) is -1

    if Gallery.record
      Spine.trigger('destroy:albumJoin', Gallery.record, albums)
    else
      for album in albums
        album.destroy() if Album.exists(album.id)

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
    return if $(e.currentTarget).hasClass('disabled')
    Spine.trigger('create:album')
  
  destroyAlbum: (e) ->
    return if $(e.currentTarget).hasClass('disabled')
    Spine.trigger('destroy:album')

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
      if hasActive() then parseInt(App.hmanager.currentDim)+"px" else "8px"
    
    @views.animate
      height: height()
      400

  changeSelection: (modelName) ->
    switch modelName
      when 'Gallery'
        @toolBarList = -> [
          {name: 'Edit Gallery', klass: 'optEditGallery', disabled: !Gallery.record}
          {name: 'New Gallery', klass: 'optCreateGallery'}
          {name: 'Delete Gallery', klass: 'optDestroyGallery', disabled: !Gallery.record}
        ]
      when 'Album'
        @toolBarList = -> [
          {name: 'New Album', klass: 'optCreateAlbum'}
          {name: 'Delete Album', klass: 'optDestroyAlbum ', disabled: !Gallery.selectionList().length}
        ]
    @renderToolbar()

  toggleGallery: (e) ->
    Spine.trigger('change:selection', 'Gallery')
    @trigger("toggle:view", App.gallery, e.target)

  toggleAlbum: (e) ->
    Spine.trigger('change:selection', 'Album')
    @trigger("toggle:view", App.album, e.target)

  toggleUpload: (e) ->
    @toolBarList = -> [
      {name: 'Show Upload', klass: ''}
      {name: 'Edit Upload', klass: ''}
    ]
    @trigger("toggle:view", App.upload, e.target)

  toggleGrid: (e) ->
    @toolBarList = -> [
      {name: 'Show Grid', klass: ''}
      {name: 'Edit Grid', klass: ''}
    ]
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

module?.exports = AlbumsView