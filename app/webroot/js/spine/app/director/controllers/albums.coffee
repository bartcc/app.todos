Spine ?= require("spine")
$      = Spine.$

class AlbumsView extends Spine.Controller

  elements:
    ".show"               : "showEl"
    ".edit"               : "editEl"
    ".show .content"      : "showContent"
    ".edit .content"      : "editContent"
    "#views"              : "views"
    ".draggable"          : "draggable"
    '.showEditor'         : 'editorBtn'
    '.showAlbum'          : 'albumBtn'
    '.showUpload'         : 'uploadBtn'
    '.showGrid'           : 'gridBtn'
    '.items'              : 'items'
    
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
    $("#albumsTemplate").tmpl items

  constructor: ->
    super
    @editEl.hide()
    @list = new Spine.AlbumList
      el: @items,
      template: @template
    Album.bind("refresh", @proxy @loadJoinTables)
    Album.bind("change", @proxy @change)
    #Album.bind("change", @proxy @testbind)
    Spine.App.bind('save', @proxy @save)
    Spine.App.bind("change:gallery", @proxy @galleryChange)
    @bind("toggle:view", @proxy @toggleView)
    @create = @edit

    $(@views).queue("fx")
    
  testbind: ->
    console.log 'Album changed'

  loadJoinTables: ->
    AlbumsImage.records = Album.joinTableRecords

  change: (item, mode) ->
    if(!item.destroyed)
      console.log 'Albums::change'
      console.log item.id
      @current = item
      @render()
      @[mode]?(item)

  render: ->
    #console.log 'Albums::render'
    joinedItems = GalleriesAlbum.filter(@gallery.id)#Spine.App.galleryList.current.id
    items = for val in joinedItems
      Album.find(val.album_id)
      
    @list.render items
    @editContent.html $("#editAlbumTemplate").tmpl @current
    @focusFirstInput(@editEl)
    @
  
  galleryChange: (item) ->
    console.log 'Albums::galleryChange'
    @gallery = item
    @render()

  focusFirstInput: (el) ->
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
    Spine.App.trigger('save', @editEl)

module?.exports = AlbumsView