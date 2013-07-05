Spine       = require("spine")
KeyEnhancer = require("plugins/key_enhancer")
$     = Spine.$

class AlbumEditView extends Spine.Controller
  
  @extend KeyEnhancer
  
  elements:
    '.content'    : 'item'
    '.editAlbum'  : 'editEl'
    'form'        : 'formEl'

  events:
    'keyup'         : 'saveOnKeyup'
  
  template: (item) ->
    $('#editAlbumTemplate').tmpl item

  constructor: ->
    super
    Spine.bind('change:selectedAlbum', @proxy @change)
    Spine.bind('change:selectedGallery', @proxy @change)


  change: (item, changed) ->
    console.log 'AlbumEditView::change'
    return unless changed
    @current = Album.record
    @render()

  render: (item = Album.record) ->
    console.log 'AlbumEditView::render'
    if item
      @item.html @template item
    else
      @item.html $("#noSelectionTemplate").tmpl({type: '<label><span class="enlightened">Select or create an album</span></label>'})
    
    @el

  save: (el) ->
    console.log 'AlbumEditView::save'
    if @current
      atts = el.serializeForm?() or @editEl.serializeForm()
      @current.updateChangedAttributes(atts)
      Spine.trigger('expose:sublistSelection')

  saveOnKeyup: (e) =>
    @save @editEl
    e.stopPropagation() if (e.keyCode == 9)
      

  click: (e) ->
    e.stopPropagation()
    e.preventDefault()

module?.exports = AlbumEditView