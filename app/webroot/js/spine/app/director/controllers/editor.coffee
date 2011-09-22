Spine ?= require("spine")
$      = Spine.$

class EditorView extends Spine.Controller
  
  elements:
    '.editEditor'  : 'editEl'

  events:
    "keydown"    : "save"
    
  template: (item) ->
    $('#editGalleryTemplate').tmpl item

  constructor: ->
    super
    Spine.App.bind('change:gallery', @proxy @change)

  render: ->
    if @current and @current.reload?()
      @current.reload()
      @editEl.html @template @current
    else
      @editEl.html $("#noSelectionTemplate").tmpl({type: 'a gallery!'})
    @

  change: (item) ->
    @current = item
    @render()

  save: (e) ->
    return if(e.keyCode != 13)
    Spine.App.trigger('save:gallery', @editEl)

module?.exports = EditorView