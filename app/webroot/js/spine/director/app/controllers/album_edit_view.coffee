Spine           = require("spine")
$               = Spine.$
KeyEnhancer     = require("plugins/key_enhancer")
Extender        = require('plugins/controller_extender')
GalleriesAlbum  = require('models/galleries_album')

class AlbumEditView extends Spine.Controller
  
#  @extend KeyEnhancer
  @extend Extender
  
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
    Album.bind('current', @proxy @changeSelection)
#    Gallery.bind('current', @proxy @changeSelection)
    Album.bind('change', @proxy @change)
    GalleriesAlbum.bind('change', @proxy @changeFromGalleriesAlbum)

  change: (item, mode) ->
    if item.destroyed
      @current = null
      @render() 
  
  changeFromGalleriesAlbum: (ga, mode) ->
    switch mode
      when 'destroy'
        item = Album.exists ga.albums_id
        @current = null
        @render()
  
  changeSelection: (item, changed) ->
    return unless changed
    @current = item
    @render item

  render: (item=@current) ->
    console.log 'AlbumEditView::render'
    if item and !item.destroyed 
      @item.html @template item
#      @focusFirstInput()
    else
      @item.html $("#noSelectionTemplate").tmpl({type: '<label><span class="enlightened">Select or create an album</span></label>'})
    
    @el

  save: (el) ->
    console.log 'AlbumEditView::save'
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

module?.exports = AlbumEditView