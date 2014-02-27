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
    @current = Photo.record
    @render()
  
  render: () ->
    if @current
      @item.html @template @current
    else
      info = ''
      info += '<label class="invite"><span class="enlightened">No photo selected.</span></label>' unless Album.selectionList().length and !Album.count()
      info += '<label class="invite"><span class="enlightened">You should create an album first to catalogue your photos.</span></label>' unless Album.count()
      @item.html $("#noSelectionTemplate").tmpl({type: info})
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