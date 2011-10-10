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
    Album.bind('change', @proxy @change)
    Spine.bind('change:selectedAlbum', @proxy @change)
    Spine.bind('change:selectedGallery', @proxy @change)

  change: (item, mode) ->
    console.log 'Album::change'
    if item instanceof Album
      @current = item
    else
      @current = null
    @render @current

  render: (item) ->
    console.log 'Album::render'
    selection = Gallery.selectionList()

    if selection?.length is 0
      @item.html $("#noSelectionTemplate").tmpl({type: 'Select or Create an Album!'})
    else if selection?.length > 1
      @item.html $("#noSelectionTemplate").tmpl({type: 'Multiple Selection'})
    else unless item
      @item.html $("#noSelectionTemplate").tmpl({type: 'Select an Gallery!'})
    else
      @item.html @template item
      @focusFirstInput(@editEl)
    @

  save: (el) ->
    console.log 'Album::save'
    if @current
      atts = el.serializeForm?() or @editEl.serializeForm()
      @current.updateChangedAttributes(atts)

  saveOnEnter: (e) =>
    return if(e.keyCode != 13)
    @save @editEl

  click: ->
    console.log 'click'

  

module?.exports = AlbumView