Spine ?= require("spine")
$      = Spine.$

class Album extends Spine.Controller
  
  elements:
    '.editAlbum'  : 'editEl'

  events:
    "keydown"    : "save"
    
  template: (item) ->
    $('#editContactTemplate').tmpl item

  constructor: ->
    super
    Spine.App.bind('change', @proxy @change)
#    Spine.App.bind('render', @proxy @render)

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

module?.exports = Album