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
      @item.html @template @current
    else unless Album.count()
      @item.html $("#noSelectionTemplate").tmpl({type: '<label><span class="enlightened">Create a album!</span></label>'})
    else
      @item.html $("#noSelectionTemplate").tmpl({type: '<label><span class="enlightened">No photo selected</span></label>'})
    @el
  
  save: (el) ->
    console.log 'PhotoEditView::save'
    if @current
      atts = el.serializeForm?() or @editEl.serializeForm()
      @current.updateChangedAttributes(atts)
 
  saveOnKeyup: (e) =>
    code = e.charCode or e.keyCode
    
    switch code
      when 32 # SPACE
        e.stopPropagation() 
      when 9 # TAB
        e.stopPropagation()
    
    @save @editEl
    
  click: (e) ->
    e.stopPropagation()
    e.preventDefault()

module?.exports = PhotoEditView