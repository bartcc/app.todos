Spine ?= require("spine")
$      = Spine.$

class AlbumsEditView extends Spine.Controller

  elements:
    ".content"                : "editContent"
    
  events:
    "click .optEdit"      : "edit"
    "click .optEmail"     : "email"
    "click .optDestroy"   : "destroy"
    "click .optSave"      : "save"
    "keydown"             : "saveOnEnter"

  template: (item) ->
    $("#editGalleryTemplate").tmpl item

  constructor: ->
    super
    Gallery.bind "change", @proxy @change
    Spine.App.bind('save:gallery', @proxy @save)
    @bind('save:gallery', @proxy @save)
    Spine.App.bind('change:selectedGallery', @proxy @change)
    @create = @edit

  change: (item, mode) ->
    console.log 'AlbumsEditView::change'
    console.log '!!!!!!!!!!!!!!'
    @current = item if !(item.destroyed)
    console.log @current
    @render @current

  render: (item) ->
    console.log 'AlbumsEditView::render'
    @current = item if item
    if @current and !(@current.destroyed)
      @editContent.html $("#editGalleryTemplate").tmpl @current
      @focusFirstInput(@editEl)
    else
      if Gallery.count()
        @editContent.html $("#noSelectionTemplate").tmpl({type: 'Select a Gallery!'})
      else
        @editContent.html $("#noSelectionTemplate").tmpl({type: 'Create a Gallery!'})
        
    @

  destroy: ->
    console.log @current
    @current.destroy()
    Gallery.record = false if !Gallery.count()

  email: ->
    return if ( !@current.email ) 
    window.location = "mailto:" + @current.email
  
  save: (el) ->
    console.log 'AlbumsEditView::save'
    if @current
      atts = el.serializeForm?() or @el.serializeForm()
      @current.updateChangedAttributes(atts)
    App.albumsManager.change(App.albumsShowView)

  saveOnEnter: (e) =>
    return if(e.keyCode != 13)
    @trigger('save:gallery', @)

module?.exports = AlbumsView