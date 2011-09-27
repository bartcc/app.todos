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
    '.tools'                  : 'tools'
    
  events:
    "click .optEdit"      : "edit"
    "click .optEmail"     : "email"
    "click .optGallery"   : "toggleGallery"
    "click .optAlbum"     : "toggleAlbum"
    "click .optUpload"    : "toggleUpload"
    "click .optGrid"      : "toggleGrid"
    'dblclick .draghandle': 'toggleDraghandle'

  albumsTemplate: (items) ->
    $("#albumsTemplate").tmpl items

  toolsTemplate: (items) ->
    $("#toolsTemplate").tmpl items

  constructor: ->
    super
    @list = new Spine.AlbumList
      el: @items,
      template: @albumsTemplate
    Album.bind("change", @proxy @render)
    Gallery.bind "update", @proxy @renderHeader
    Spine.App.bind('save:gallery', @proxy @save)
    Spine.App.bind('change:selectedGallery', @proxy @change)
    @bind('save:gallery', @proxy @save)
    @bind("toggle:view", @proxy @toggleView)

    @toolBar = {}

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
    if gallery
      @header.html '<h2>Albums for Gallery ' + gallery.name + '</h2>'
    else
      @header.html '<h2>Albums Overview</h2>'

  renderToolBar: ->
    console.log @toolBar
    console.log 'AlbumsShowView::renderTools'
    @tools.html @toolsTemplate @toolBar
    @refreshElements()

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
    @toolBar.names = ['Edit Gallery', 'Show Gallery']
    @trigger("toggle:view", App.gallery, e.target)

  toggleAlbum: (e) ->
    @toolBar.names = ['Edit Album', 'Show Album']
    #@toolBar['edit'] = 'Edit Album'
    #@toolBar['show'] = 'Show Album'
    @trigger("toggle:view", App.album, e.target)

  toggleUpload: (e) ->
    @toolBar.names = ['Edit Upload', 'Show Upload']
    @trigger("toggle:view", App.upload, e.target)

  toggleGrid: (e) ->
    @toolBar.names = ['Edit Grid', 'Show Grid']
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