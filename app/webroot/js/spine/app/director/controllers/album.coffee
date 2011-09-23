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
    Spine.App.bind('change:album', @proxy @change)

  change: (item) ->
    @render()

  render: ->
    albumid = @albumid()
    album = Album.find(albumid) if Album.exists(albumid)
    if album
      @current = album
      @item.html @template album
      @focusFirstInput(@editEl)
    else
      nogallery = 'a Gallery and an Album!'
      noalbum = 'an Album!'
      @item.html $("#noSelectionTemplate").tmpl({type: if Gallery.record then noalbum else nogallery})
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
    @change()

  saveOnEnter: (e) =>
    return if(e.keyCode != 13)
    @save @editEl

  click: ->
    console.log 'click'

module?.exports = AlbumView