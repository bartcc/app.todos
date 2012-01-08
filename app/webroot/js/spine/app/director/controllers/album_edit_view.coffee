Spine ?= require("spine")
$      = Spine.$

class AlbumEditView extends Spine.Controller
  
  elements:
    '.content'    : 'item'
    '.editAlbum'  : 'editEl'
    'form'        : 'formEl'

  events:
    'click'         : 'click'
    'keydown'       : 'saveOnEnter'
    'change select' : 'changeSelected'
  
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
    console.log 'Album::change'
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
    console.log 'AlbumView::render'
    selection = Gallery.selectionList()

    unless selection?.length
      @item.html $("#noSelectionTemplate").tmpl({type: '<label class="label"><span class="enlightened">Select or create an album</span></label>'})
    else if selection?.length > 1
      @item.html $("#noSelectionTemplate").tmpl({type: '<label class="label"><span class="enlightened">Multiple selection</span></label>'})
    else unless item
      unless Gallery.count()
        @item.html $("#noSelectionTemplate").tmpl({type: '<label class="label"><span class="enlightened">Create a gallery</span></label>'})
      else
        @item.html $("#noSelectionTemplate").tmpl({type: '<label class="label"><span class="enlightened">Select a gallery</span></label>'})
    else
      @item.html @template item
    @el

  save: (el) ->
    console.log 'AlbumView::save'
    if @current
      atts = el.serializeForm?() or @editEl.serializeForm()
      @current.updateChangedAttributes(atts)
      Gallery.updateSelection [@current.id]
      Spine.trigger('expose:sublistSelection', Gallery.record)

  saveOnEnter: (e) =>
    console.log e.keyCode
    @save @editEl if(e.keyCode == 13)
    if (e.keyCode == 9)
      e.stopPropagation()
#      e.preventDefault()
    

  click: (e) ->
    e.stopPropagation()
    e.preventDefault()
    false

module?.exports = AlbumEditView