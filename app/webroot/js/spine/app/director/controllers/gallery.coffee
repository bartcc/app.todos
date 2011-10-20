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
    Spine.bind('change:selectedGallery', @proxy @change)
    Gallery.bind "change", @proxy @change

  change: (item) ->
    console.log 'Gallery::change'
    @current = item# if !(item?.destroyed)
    @render()

  render: ->
    console.log 'Gallery::render'
    if @current and !(@current.destroyed)
      @editEl.html @template @current
      #@focusFirstInput(@editEl)
    else
      unless Gallery.count()
        @editEl.html $("#noSelectionTemplate").tmpl({type: 'Create a Gallery!'})
      else
        @editEl.html $("#noSelectionTemplate").tmpl({type: 'Select a Gallery!'})
#      missing         = 'Select a Gallery and an Album!'
#      missingGallery  = if Gallery.count() then 'Select a Gallery!' else 'Create a Gallery'
#      @editEl.html $("#noSelectionTemplate").tmpl({type: if Gallery.record then missing else missingGallery})
    @

  saveOnEnter: (e) ->
    return if(e.keyCode != 13)
    Spine.trigger('save:gallery', @editEl)
    

module?.exports = EditorView