Spine           = require("spine")
$               = Spine.$
KeyEnhancer     = require("plugins/key_enhancer")
GalleriesAlbum  = require('models/galleries_album')

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
    Spine.bind('change:selectedAlbum', @proxy @changeSelection)
    Spine.bind('change:selectedGallery', @proxy @changeSelection)
    Album.bind('change', @proxy @change)
    GalleriesAlbum.bind('change', @proxy @changeFromGalleriesAlbum)

  change: (item, mode) ->
    @current = null
    @render() if item.destroyed
  
  changeFromGalleriesAlbum: (ga, mode) ->
    switch mode
      when 'destroy'
        item = Album.exists ga.albums_id
        @current = null
        @render()
  
  changeSelection: (item, changed) ->
    return unless changed
    @current = Album.record
    @render()

  render: (item=@current) ->
    console.log 'AlbumEditView::render'
    if item and !item.destroyed 
      @item.html @template item
    else
      @item.html $("#noSelectionTemplate").tmpl({type: '<label><span class="enlightened">Select or create an album</span></label>'})
    
    @el

  save: (el) ->
    console.log 'AlbumEditView::save'
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

module?.exports = AlbumEditView