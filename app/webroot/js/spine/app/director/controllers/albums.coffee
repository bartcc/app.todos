Spine ?= require("spine")
$      = Spine.$

class AlbumsView extends Spine.Controller

  elements:
    ".show"                         : "showEl"
    ".edit"                         : "editEl"
    ".show .content"                : "showContent"
    ".edit .content"                : "editContent"
    "#views"                        : "views"
    ".draggable"                    : "draggable"
    '.showEditor'                   : 'editorBtn'
    '.showAlbum'                    : 'albumBtn'
    '.showUpload'                   : 'uploadBtn'
    '.showGrid'                     : 'gridBtn'
    '.content .items'               : 'items'
    '.content .editAlbum .item'     : 'albumEditor'
    '.header'                       : 'header'
    
  events:
    "click .optEdit"      : "edit"
    "click .optEmail"     : "email"
    "click .showEditor"   : "toggleEditor"
    "click .showAlbum"    : "toggleAlbum"
    "click .showUpload"   : "toggleUpload"
    "click .showGrid"     : "toggleGrid"
    "click .optDestroy"   : "destroy"
    "click .optSave"      : "save"
    "keydown"             : "saveOnEnter"
    'dblclick .draghandle': 'toggleDraghandle'

  template: (items) ->
    #items = {album: items, gallery: @current}
    $("#albumsTemplate").tmpl items

  constructor: ->
    super
    @editEl.hide()
    @list = new Spine.AlbumList
      el: @items,
      template: @template
      editor: @albumEditor
    #Album.bind("refresh", @proxy @loadJoinTables)
    Album.bind("change", @proxy @render)
    Spine.App.bind('save:gallery', @proxy @save)
    Spine.App.bind("change:gallery", @proxy @galleryChange)
    #Spine.App.bind("change:album", @proxy @galleryChange)
    @bind("toggle:view", @proxy @toggleView)
    @create = @edit

    $(@views).queue("fx")
    
  loadJoinTables: ->
    AlbumsImage.records = Album.joinTableRecords

  change: (item, mode) ->
    console.log 'Albums::change'
    @current = item
    console
    @render()
    @[mode]?(item)

  galleryChange: (item, mode) ->
    console.log 'Albums::galleryChange'
    @current = item
    #@gallery = item
    @change item, mode

  render: ->
    console.log 'Albums::render'

    joinedItems = GalleriesAlbum.filter(@current?.id or null)
    items = for val in joinedItems
      Album.find(val.album_id)
    
    @header.html '<h2>Albums for Gallery ' + @current.name + '</h2>'
    @list.render items
    
    #render Gallery Editor
    if @current
      @editContent.html $("#editGalleryTemplate").tmpl @current
      @focusFirstInput(@editEl)
      
    @
    
  focusFirstInput_: (el) ->
    return unless el
    $('input', el).first().focus().select() if el.is(':visible')
    el

  show: (item) ->
    @showEl.show 0, @proxy ->
      @editEl.hide()

  
  edit: (item) ->
    @editEl.show 0, @proxy ->
      @showEl.hide()
      @focusFirstInput(@editEl)

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
      for controller in App.hmanager.controllers
        if controller.isActive()
          return App.hmanager.enableDrag()
      App.hmanager.disableDrag()

    height = ->
      if hasActive() then App.hmanager.currentDim+"px" else "7px"

    $(@views).animate
      height: height()
      400

  toggleEditor: (e) ->
    @trigger("toggle:view", App.editor, e.target)

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
    atts = el.serializeForm?() or @editEl.serializeForm()
    @current.updateChangedAttributes(atts)
    @show()

  saveOnEnter: (e) =>
    return if(e.keyCode != 13)
    Spine.App.trigger('save:gallery', @editEl)

module?.exports = AlbumsView