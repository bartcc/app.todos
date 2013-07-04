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

#  changeSelected: (e) ->
#    el = $(e.currentTarget)
#    id = el.val()
#    album = Album.exists(id)
#    
#    Album.trigger('activate', album.updateSelection [album.id])

  change: (item, changed) ->
    console.log 'AlbumEditView::change'
    return unless changed
    switch item?.constructor.className
      when 'Album'
        @current = item
      when 'Gallery'
        firstID = Gallery.selectionList()[0]
        if album = Album.exists(firstID)
          @current = album
        else
          @current = false
        
    @render @current, changed

  render: (item, mode) ->
    console.log 'AlbumEditView::render'
    selection = Gallery.selectionList()
    if item and selection?.length is 1
      @item.html @template item
    else
      unless selection?.length
        @item.html $("#noSelectionTemplate").tmpl({type: '<label><span class="enlightened">Select or create an album</span></label>'})
      else if selection?.length > 1
        @item.html $("#noSelectionTemplate").tmpl({type: '<label><span class="enlightened">Multiple selection</span></label>'})
    
    @el

  save: (el) ->
    console.log 'AlbumEditView::save'
    if @current
      atts = el.serializeForm?() or @editEl.serializeForm()
      @current.updateChangedAttributes(atts)
      Gallery.updateSelection [@current.id]
      Spine.trigger('expose:sublistSelection', Gallery.record)

  saveOnKeyup: (e) =>
    @save @editEl
    e.stopPropagation() if (e.keyCode == 9)
      

  click: (e) ->
    e.stopPropagation()
    e.preventDefault()

module?.exports = AlbumEditView