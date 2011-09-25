Spine ?= require("spine")
$      = Spine.$

class AlbumsShowView extends Spine.Controller

  elements:
    ".content"                : "showContent"
    "#views .views"           : "views"
    ".draggable"              : "draggable"
    '.optGallery'             : 'btnGallery'
    '.optAlbum'               : 'btnAlbum'
    '.optUpload'              : 'btnUpload'
    '.optGrid'                : 'btnGrid'
    '.content .items'         : 'items'
    '.header'                 : 'header'
    
  events:
    "click .optEdit"      : "edit"
    "click .optEmail"     : "email"
    "click .optGallery"   : "toggleGallery"
    "click .optAlbum"     : "toggleAlbum"
    "click .optUpload"    : "toggleUpload"
    "click .optGrid"      : "toggleGrid"
    'dblclick .draghandle': 'toggleDraghandle'

  template: (items) ->
    $("#albumsTemplate").tmpl items

  constructor: ->
    super
    @list = new Spine.AlbumList
      el: @items,
      template: @template
    Album.bind("change", @proxy @render)
    Spine.App.bind('save:gallery', @proxy @save)
    @bind('save:gallery', @proxy @save)
    Spine.App.bind('change:selectedGallery', @proxy @change)
    Gallery.bind "change", @proxy @renderHeader
    @bind("toggle:view", @proxy @toggleView)
    @create = @edit

    $(@views).queue("fx")
    
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
      joinedItems = GalleriesAlbum.filter(@current.id)
      items = for val in joinedItems
        Album.find(val.album_id)
    else
      items = Album.filter()
      
    @renderHeader()
    @list.render items, album
   
  renderHeader: (item) ->
    console.log 'AlbumsShowView::renderHeader'
    gallery = item or @current
    console.log name
    if gallery
      @header.html '<h2>Albums for Gallery ' + gallery.name + '</h2>'
    else
      @header.html '<h2>Albums Overview</h2>'

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
    @trigger("toggle:view", App.gallery, e.target)

  toggleAlbum: (e) ->
    @trigger("toggle:view", App.album, e.target)

  toggleUpload: (e) ->
    @trigger("toggle:view", App.upload, e.target)

  toggleGrid: (e) ->
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