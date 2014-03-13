Spine       = require("spine")
$           = Spine.$
KeyEnhancer = require("plugins/key_enhancer")
AlbumsPhoto  = require('models/albums_photo')

class PhotoEditView extends Spine.Controller

  @extend KeyEnhancer
  
  elements:
    '.content'        : 'item'
    '.editPhoto'      : 'editEl'
    
  events:
    'click'           : 'click'
#    'keyup'           : 'saveOnKeyup'
    
  template: (item) ->
    $('#editPhotoTemplate').tmpl(item)
  
  constructor: ->
    super
    Spine.bind('change:selectedPhoto', @proxy @changeSelection)
    Spine.bind('change:selectedAlbum', @proxy @changeSelection)
    Spine.bind('change:selectedGallery', @proxy @changeSelection)
    Photo.bind('change', @proxy @change)
    AlbumsPhoto.bind('change', @proxy @changeFromAlbumsPhoto)
  
  change: (item, mode) ->
    if item.destroyed
      @current = null
      @render() 
  
  changeFromAlbumsPhoto: (ap, mode) ->
    switch mode
      when 'destroy'
        item = Photo.exists ap.photo_id
        @current = null
        @render()
  
  changeSelection: (item, changed) ->
    return unless changed
    @current = Photo.record
    @render()
  
  render: (item=@current) ->
    if item and !item.destroyed 
      @item.html @template item
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
      @current.updateAttributes(atts)
 
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