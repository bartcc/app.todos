Spine ?= require("spine")
$      = Spine.$

class AlbumEditView extends Spine.Controller
  
  elements:
    '.content'    : 'item'
    '.editAlbum'  : 'editEl'
    'form'        : 'formEl'

  events:
    'keydown'       : 'saveOnEnter'
  
  template: (item) ->
    $('#editAlbumTemplate').tmpl item

  constructor: ->
    super
    Spine.bind('change:selectedAlbum', @proxy @change)
    Spine.bind('change:selectedGallery', @proxy @change)

  changeSelected: (e) ->
    el = $(e.currentTarget)
    id = el.val()
    album = Album.find(id)
    album.updateSelection [album.id]
    Spine.trigger('album:activate')

  change: (item, mode) ->
    console.log 'AlbumEditView::change'
    if item?.constructor.className is 'Album'
      @current = item
    else
      firstID = Gallery.selectionList()[0]
      if Album.exists(firstID)
        @current = Album.find(firstID)
      else
        @current = false
        
    @render @current, mode

  render: (item, mode) ->
    console.log 'AlbumEditView::render'
#    return unless @isActive()
    selection = Gallery.selectionList()
    if item and selection?.length is 1
      @item.html @template item
    else
      unless selection?.length
        @item.html $("#noSelectionTemplate").tmpl({type: '<label><span class="enlightened">Select or create an album</span></label>'})
      else if selection?.length > 1
        @item.html $("#noSelectionTemplate").tmpl({type: '<label><span class="enlightened">Multiple selection</span></label>'})
    
    
    
#    else unless item
#      unless Gallery.count()
#        @item.html $("#noSelectionTemplate").tmpl({type: '<label class="label"><span class="enlightened">Create a gallery</span></label>'})
#      else
#        @item.html $("#noSelectionTemplate").tmpl({type: '<label class="label"><span class="enlightened">Select a gallery</span></label>'})
    
    @el

  save: (el) ->
    console.log 'AlbumEditView::save'
    if @current
      atts = el.serializeForm?() or @editEl.serializeForm()
      @current.updateChangedAttributes(atts)
      Gallery.updateSelection [@current.id]
      Spine.trigger('expose:sublistSelection', Gallery.record)

  saveOnEnter: (e) =>
    @save @editEl if(e.keyCode == 13)
    if (e.keyCode == 9)
      e.stopPropagation()

  click: (e) ->
    e.stopPropagation()
    e.preventDefault()

module?.exports = AlbumEditView