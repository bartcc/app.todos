Spine ?= require("spine")
$      = Spine.$

class AlbumView extends Spine.Controller
  
  elements:
    '.item'       : 'item'
    '.editAlbum'  : 'editEl'

  events:
    "click .item" : "click"
    'keydown'     : 'saveOnEnter'
  
  template: (item) ->
    $('#editAlbumTemplate').tmpl item

  constructor: ->
    super
    Spine.App.bind('change:album', @proxy @change)

  change: (item) ->
    @current = item
    @render()

  render: ->
    if @current
      @item.html @template @current
      @focusFirstInput(@editEl)
    else
      @item.html $("#noSelectionTemplate").tmpl({type: 'an Album!'})

  save: (el) ->
    atts = el.serializeForm?() or @editEl.serializeForm()
    @current.updateChangedAttributes(atts)

  saveOnEnter: (e) =>
    return if(e.keyCode != 13)
    @save @editEl

  click: ->
    console.log 'click'

module?.exports = AlbumView