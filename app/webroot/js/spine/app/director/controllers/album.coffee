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
    album = item if item instanceof Album
    @current = album
    @render()

  render: () ->
    console.log 'Album::render'
    if @current
      @item.html @template @current
      @focusFirstInput(@editEl)
    else
      console.log Album.record
      missing = 'Select a Gallery and an Album!'
      missingAlbum = if Album.record then 'Select an Album!' else 'Create an Album!'
      @item.html $("#noSelectionTemplate").tmpl({type: if Gallery.record then missingAlbum else missing})
    @

  save: (el) ->
    console.log 'Album::save'
    atts = el.serializeForm?() or @editEl.serializeForm()
    @current.updateChangedAttributes(atts)

  saveOnEnter: (e) =>
    return if(e.keyCode != 13)
    @save @editEl

  click: ->
    console.log 'click'

module?.exports = AlbumView