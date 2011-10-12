Spine ?= require("spine")
$      = Spine.$

class AlbumsView extends Spine.Controller

  elements:
    ".show"                         : "showEl"
    ".edit"                         : "editEl"
    ".show .content"                : "showContent"
    ".edit .content"                : "editContent"
    ".views"                        : "views"
    ".draggable"                    : "draggable"
    '.showGallery'                  : 'galleryBtn'
    '.showAlbum'                    : 'albumBtn'
    '.showUpload'                   : 'uploadBtn'
    '.showGrid'                     : 'gridBtn'
    '.content .items'               : 'items'
    '.content .editAlbum .item'     : 'albumEditor'
    '.header'                       : 'header'
    
  events:
    "click .optEdit"      : "edit"
    "click .optEmail"     : "email"
    "click .showGallery"  : "toggleGallery"
    "click .showAlbum"    : "toggleAlbum"
    "click .showUpload"   : "toggleUpload"
    "click .showGrid"     : "toggleGrid"
    "click .optDestroy"   : "destroy"
    "click .optSave"      : "save"
    "keydown"             : "saveOnEnter"
    'dblclick .draghandle': 'toggleDraghandle'

  template: (items) ->
    $("#albumsTemplate").tmpl items

  constructor: ->
    super
    @editEl.hide()
    @list = new Spine.AlbumList
      el: @items,
      template: @template
      editor: @albumEditor
    Album.bind("change", @proxy @render)
    Spine.bind('save:album', @proxy @save)
    @bind('save:album', @proxy @save)
    Spine.bind('change:selectedGallery', @proxy @change)
    Gallery.bind "change", @proxy @renderGalleryEditor
    Gallery.bind "change", @proxy @renderHeader
    @bind("toggle:view", @proxy @toggleView)
    @create = @edit

    $(@views).queue("fx")
    
  loadJoinTables: ->
    AlbumsImage.records = Album.joinTableRecords

  change: (item, mode) ->
    console.log 'Albums::change'
    @current = item
    @render item
    @[mode]?(item)

  render: (album) ->
    console.log 'Albums::render'
    
    if @current
      joinedItems = GalleriesAlbum.filter(@current.id)
      items = for val in joinedItems
        Album.find(val.album_id)
    else
      items = Album.filter()
      
    @renderGalleryEditor()
    @renderHeader()
    @list.render items, album
    
  renderGalleryEditor: (item) ->
    @current = item if item
    if @current
      @editContent.html $("#editGalleryTemplate").tmpl @current
      #@focusFirstInput(@editEl)
    else
      @editContent.html $("#noSelectionTemplate").tmpl({type: 'Select a Gallery!'})
    @
   
  renderHeader: (item) ->
    console.log 'Albums::renderHeader'
    
    if @current
      @header.html '<h2>Albums for Gallery ' + @current.name + '</h2>'
    else
      @header.html '<h2>Albums Overview</h2>'

  show: (item) ->
    @showEl.show 0, @proxy ->
      @editEl.hide()

  
  edit: (item) ->
    @editEl.show 0, @proxy ->
      @showEl.hide()
      #@focusFirstInput(@editEl)

  destroy: ->
    @current.destroy()

  email: ->
    return if ( !@current.email ) 
    window.location = "mailto:" + @current.email

  renderViewControl: (controller, controlEl) ->
    active = controller.isActive()

    $(".options .view").each ->
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

    $(@views).animate
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
    
    #openClose = false if openClose
    if(isActive)
      App.hmanager.trigger("change", false)
    else
      @activeControl = $(control)
      App.hmanager.trigger("change", controller)

    @renderViewControl controller, control
    @animateView()
  
  toggleDraghandle: ->
    @activeControl.click()

  save: (el) ->
    console.log 'Albums::save'
    if @current
      atts = el.serializeForm?() or @editEl.serializeForm()
      @current.updateChangedAttributes(atts)
      @show()

  saveOnEnter: (e) =>
    return if(e.keyCode != 13)
    @trigger('save:gallery', @editEl)

module?.exports = AlbumsView