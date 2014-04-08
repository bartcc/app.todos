Spine       = require("spine")
$           = Spine.$
KeyEnhancer = require("plugins/key_enhancer")
Extender    = require('plugins/controller_extender')
AlbumsPhoto = require('models/albums_photo')

class PhotoEditView extends Spine.Controller

#  @extend KeyEnhancer
  @extend Extender
  
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
    Photo.bind('current', @proxy @changeSelection)
    Album.bind('current', @proxy @changeSelection)
    Gallery.bind('current', @proxy @changeSelection)
    Photo.bind('change', @proxy @change)
    Photo.bind('current', @proxy @show)
    AlbumsPhoto.bind('change', @proxy @changeFromAlbumsPhoto)
  
  activated: ->
    @render()
  
  show: (item, changed) ->
    @trigger('active')
    @changeSelection item, changed
  
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
    console.log 'PhotoEditView::render'
    if item and !item.destroyed 
      @item.html @template item
      @focusFirstInput()
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