Spine       = require("spine")
KeyEnhancer = require("plugins/key_enhancer")
$           = Spine.$

class PhotoEditView extends Spine.Controller

  @extend KeyEnhancer
  
  elements:
    '.content'        : 'item'
    '.editPhoto'      : 'editEl'
    
  events:
    'click'           : 'click'
    'keyup'           : 'saveOnKeyup'
    
  template: (item) ->
    $('#editPhotoTemplate').tmpl(item)
  
  constructor: ->
    super
    Spine.bind('change:selectedPhoto', @proxy @change)
    Spine.bind('change:selectedAlbum', @proxy @change)
    Spine.bind('change:selectedGallery', @proxy @change)
  
  change: ->
    first = Album.selectionList()[0] if Album.selectionList().length
    @current = Photo.record or Photo.exists(first)
    @render()
  
  render: () ->
    if @current
      console.log 'switch 1'
      @item.html @template @current
    else unless Album.count()
      console.log 'switch 2'
      @item.html $("#noSelectionTemplate").tmpl({type: '<label><span class="enlightened">Create a album!</span></label>'})
    else
      console.log 'switch 3'
      @item.html $("#noSelectionTemplate").tmpl({type: '<label><span class="enlightened">No photo selected</span></label>'})
    @el
  
  save: (el) ->
    console.log 'PhotoEditView::save'
    if @current
      atts = el.serializeForm?() or @editEl.serializeForm()
      @current.updateChangedAttributes(atts)
 
  saveOnKeyup: (e) =>
    @save @editEl #if(e.keyCode == 13)
    e.stopPropagation() if (e.keyCode == 9)
    
  click: (e) ->
    e.stopPropagation()
    e.preventDefault()
    false

module?.exports = PhotoEditView