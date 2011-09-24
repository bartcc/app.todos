Spine ?= require("spine")
$      = Spine.$

class GalleryView extends Spine.Controller
  
  elements:
    '.editGallery'  : 'editEl'

  events:
    "keydown"    : "saveOnEnter"
    
  template: (item) ->
    $('#editGalleryTemplate').tmpl item

  constructor: ->
    super
    Spine.App.bind('change:selectedGallery', @proxy @change)
    Gallery.bind "update", @proxy @change

  change: (item) ->
    console.log 'Gallery::change'
    @current = item
    @render()

  render: ->
    if @current# and @current.reload?()
      #@current.reload()
      @editEl.html @template @current
    else
      missing         = 'Select a Gallery and an Album!'
      missingGallery  = 'Select a Gallery!'
      @editEl.html $("#noSelectionTemplate").tmpl({type: if Gallery.record then missing else missingGallery})
    @

  save: (el) ->
    if @current
      atts = el.serializeForm?() or @editEl.serializeForm()
      @current.updateChangedAttributes(atts)

  saveOnEnter: (e) ->
    return if(e.keyCode != 13)
    @save @editEl

module?.exports = EditorView