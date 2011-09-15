Spine ?= require("spine")
$      = Spine.$

class Editor extends Spine.Controller
  
  elements:
    '.editEditor'  : 'editEl'

  events:
    "keydown"    : "save"
    
  template: (item) ->
    $('#editAlbumTemplate').tmpl item

  constructor: ->
    super
    Spine.App.bind('change', @proxy @change)

  render: ->
    if @current and @current.reload?()
      @current.reload()
      @editEl.html @template @current
      @

  change: (item) ->
    @current = item
    @render()

  save: (e) ->
    return if(e.keyCode != 13)
    Spine.App.trigger('save', @editEl)

module?.exports = Editor