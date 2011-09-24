Spine ?= require("spine")
$      = Spine.$

class AlbumView extends Spine.Controller
  
  elements:
    '.item'       : 'item'
    '.editAlbum'  : 'editEl'

  events:
    "click .item"  : "click"
    'keydown'         : 'saveOnEnter'
  
  template: (item) ->
    $('#editAlbumTemplate').tmpl item

  constructor: ->
    super
    Album.bind('change', @proxy @change)
    Spine.App.bind('change:selectedAlbum', @proxy @change)
    Spine.App.bind('change:selectedGallery', @proxy @change)

  change: (item) ->
    console.log 'Album::change'
    @render(item if item instanceof Album)

  render: (item) ->
    console.log 'Album::render'
    if item
      @current = item
      @item.html @template item
      @focusFirstInput(@editEl)
    else
      missing = 'Select a Gallery and an Album!'
      missingAlbum = 'Select an Album!'
      @item.html $("#noSelectionTemplate").tmpl({type: if Gallery.record then missingAlbum else missing})
    @

  albumid: ->
    gal = Gallery.selected()
    albid = gal.selectedAlbumId
    gal.selectedAlbumId

  selected: ->
    App.sidebar

  save: (el) ->
    atts = el.serializeForm?() or @editEl.serializeForm()
    @current.updateChangedAttributes(atts)

  saveOnEnter: (e) =>
    return if(e.keyCode != 13)
    @save @editEl

  click: ->
    console.log 'click'

module?.exports = AlbumView