Spine ?= require("spine")
$      = Spine.$

class GalleryEditView extends Spine.Controller
  
  elements:
    '.editGallery'    : 'editEl'
    '.optCreate'      : 'createGalleryEl'

  events:
    'click'           : 'click'
    'keydown'         : 'saveOnEnter'
    'click .optCreate': 'createGallery'
    
  template: (item) ->
    $('#editGalleryTemplate').tmpl item

  constructor: ->
    super
    Spine.bind('change:selectedGallery', @proxy @change)
    Gallery.bind "refresh change", @proxy @change

  change: (item, mode) ->
    console.log 'GalleryEditView::change'
    @render()

  render: ->
    console.log 'GalleryEditView::render'
    if Gallery.record
      @editEl.html @template Gallery.record
    else
      unless Gallery.count()
        @editEl.html $("#noSelectionTemplate").tmpl({type: '<div class="invite"><span class="enlightened invite">Director has no gallery yet &nbsp;<button class="optCreate dark invite">New Gallery</button></span></div>'})
      else
        @editEl.html $("#noSelectionTemplate").tmpl({type: '<label class="label"><span class="enlightened">Select a gallery!</span></label>'})
    @

  saveOnEnter: (e) ->
    console.log 'GalleryEditView::saveOnEnter'
    console.log e.keyCode
    return if(e.keyCode != 13)
    Spine.trigger('save:gallery', @editEl)
    
  createGallery: ->
    Spine.trigger('create:gallery')
    
  click: (e) ->
    console.log 'click'
    
    e.stopPropagation()
    e.preventDefault()
    false

module?.exports = GalleryEditView