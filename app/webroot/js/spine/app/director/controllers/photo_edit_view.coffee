Spine ?= require("spine")
$      = Spine.$

class PhotoEditView extends Spine.Controller

  elements:
    '.content'        : 'item'
    '.editPhoto'      : 'editEl'
    
  events:
    'click'           : 'click'
    'keydown'         : 'saveOnEnter'
    
  template: (item) ->
    $('#editPhotoTemplate').tmpl(item)
  
  constructor: ->
    super
    Spine.bind('change:selectedPhoto', @proxy @change)
    Spine.bind('change:selectedAlbum', @proxy @change)
    Spine.bind('change:selectedGallery', @proxy @change)
  
  change: (item) ->
    if item?.constructor.className is 'Photo'
      @current = item
        
    @render @current
  
  render: (item) ->
    selection = Album.selectionList()

    unless selection?.length
      @item.html $("#noSelectionTemplate").tmpl({type: '<label class="label"><span class="enlightened">No photo selected</span></label>'})
    else if selection?.length > 1
      @item.html $("#noSelectionTemplate").tmpl({type: '<label class="label"><span class="enlightened">Multiple selection</span></label>'})
    else unless item
      unless Album.count()
        @item.html $("#noSelectionTemplate").tmpl({type: '<label class="label"><span class="enlightened">Create a album!</span></label>'})
      else
        @item.html $("#noSelectionTemplate").tmpl({type: '<label class="label"><span class="enlightened">Select a album!</span></label>'})
    else
      @item.html @template item
    @el
  
  save: (el) ->
    console.log 'PhotoView::save'
    if @current
      atts = el.serializeForm?() or @editEl.serializeForm()
      @current.updateChangedAttributes(atts)
      Album.updateSelection [@current.id]

  saveOnEnter: (e) =>
    return if(e.keyCode != 13)
    @save @editEl
    
  click: (e) ->
    e.stopPropagation()
    e.preventDefault()
    false

module?.exports = PhotoEditView