Spine ?= require("spine")
$      = Spine.$

class AlbumView extends Spine.Controller
  
  elements:
    '.content'    : 'item'
    '.editAlbum'  : 'editEl'

  events:
    "click"       : "click"
    'keydown'     : 'saveOnEnter'
  
  template: (item) ->
    $('#editAlbumTemplate').tmpl item

  constructor: ->
    super
    Spine.bind('change:selectedAlbum', @proxy @change)
    Spine.bind('change:selectedGallery', @proxy @change)

  change: (item, mode) ->
    console.log 'Album::change'
    if item instanceof Album
      @current = item
    else
      @current = null
    @render @current, mode

  render: (item, mode) ->
    console.log 'Album::render'
    selection = Gallery.selectionList()

    if selection?.length is 0
      @item.html $("#noSelectionTemplate").tmpl({type: '<label><span class="dimmed">Select or create an album!</span></label>'})
    else if selection?.length > 1
      @item.html $("#noSelectionTemplate").tmpl({type: '<label><span class="dimmed">Multiple selection</span></label>'})
    else unless item
      unless Gallery.count()
        @item.html $("#noSelectionTemplate").tmpl({type: '<label><span class="dimmed">Create a gallery!</span></label>'})
      else
        @item.html $("#noSelectionTemplate").tmpl({type: '<label><span class="dimmed">Select a gallery!</span></label>'})
    else
      @item.html @template item
    @el

  save: (el) ->
    console.log 'Album::save'
    if @current
      atts = el.serializeForm?() or @editEl.serializeForm()
      @current.updateChangedAttributes(atts)
      Gallery.updateSelection [@current.id]
      Spine.trigger('expose:sublistSelection', Gallery.record)

  saveOnEnter: (e) =>
    return if(e.keyCode != 13)
    @save @editEl

  click: (e) ->
    console.log 'click'
    
    e.stopPropagation()
    e.preventDefault()
    false

module?.exports = AlbumView