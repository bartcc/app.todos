Spine       = require("spine")
KeyEnhancer = require("plugins/key_enhancer")
Gallery     = require("models/gallery")
$           = Spine.$

class GalleryEditView extends Spine.Controller
  
  @extend KeyEnhancer
  
  elements:
    '.editGallery'    : 'editEl'
    '.optCreate'      : 'createGalleryEl'

  events:
#    'click'           : 'click'
    'keyup'        : 'saveOnEnter'
    'click .optCreate': 'createGallery'
    
  template: (item) ->
    $('#editGalleryTemplate').tmpl item

  constructor: ->
    super
    Spine.bind('change:selectedGallery', @proxy @render)
    Gallery.bind "refresh", @proxy @refresh
    Gallery.bind "refresh change", @proxy @change

  change: (item, mode) ->
    console.log 'GalleryEditView::change'
    @render()

  refresh: ->
    @render()

  render: ->
    console.log 'GalleryEditView::render'
#    return unless @isActive()
    if Gallery.record
      @editEl.html @template Gallery.record
    else
      unless Gallery.count()
        @editEl.html $("#noSelectionTemplate").tmpl({type: '<label class="invite"><span class="enlightened">Director has no gallery yet &nbsp;<button class="optCreate dark large">New Gallery</button></span></label>'})
      else
        @editEl.html $("#noSelectionTemplate").tmpl({type: '<label><span class="enlightened">Select a gallery!</span></label>'})
    @editEl

  saveOnEnter: (e) ->
    console.log 'GalleryEditView::saveOnEnter'
    return unless (e.keyCode is 13)
    atts = @editEl.serializeForm()
    Gallery.record.updateChangedAttributes(atts)
    
  createGallery: ->
    Spine.trigger('create:gallery')
    
  click: (e) ->
    e.stopPropagation()
    e.preventDefault()

module?.exports = GalleryEditView