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
    Photo.bind('change', @proxy @change)
    Album.bind('change:selection', @proxy @fromSelection)
    Album.bind('current', @proxy @fromAlbum)
    Gallery.bind('current', @proxy @fromGallery)
    AlbumsPhoto.bind('change', @proxy @changeFromAlbumsPhoto)
  
  activated: ->
    @render()
  
  show: (album) ->
    @trigger('active')
  
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
  
  fromSelection: (selection) ->
    id = selection[0]
    record = Photo.exists(id) #if photo
    @current =  record or false
    @trigger('active')
    @render()
  
  fromAlbum: (album, same) ->
    id = album.selectionList().first() if album
    @current =  Photo.exists(id) or false
    @render()
  
  fromGallery: (gallery, same) ->
    id = gallery.selectionList().first() if gallery
    @fromAlbum Album.exists(id) or false
  
  changeSelection: (list) ->
    @current = Photo.exists(list[0])
    @render @current
  
  render: (item=@current) ->
    if item and !item.destroyed 
      @item.html @template item
#      @focusFirstInput()
    else
      info = ''
      info += '<label class="invite"><span class="enlightened">No photo selected.</span></label>' unless Album.selectionList().length and !Album.count()
      info += '<label class="invite"><span class="enlightened">You should create an album first to catalogue your photos.</span></label>' unless Album.count()
      @item.html $("#noSelectionTemplate").tmpl({type: info})
    @el
  
  save: (el) ->
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