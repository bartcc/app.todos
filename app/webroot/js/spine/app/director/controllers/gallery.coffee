Spine ?= require("spine")
$      = Spine.$

class GalleryView extends Spine.Controller
  
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
    Gallery.bind "change", @proxy @change

  change: (item, mode) ->
    console.log 'Gallery::change'
    @render()

  render: ->
    console.log 'Gallery::render'
    if Gallery.record
      @editEl.html @template Gallery.record
    else
      unless Gallery.count()
        @editEl.html $("#noSelectionTemplate").tmpl({type: '<label class="invite"><span class="dimmed invite">Director has no gallery yet &nbsp;</span><button class="optCreate dark invite">New Gallery</button></label>'})
      else
        @editEl.html $("#noSelectionTemplate").tmpl({type: '<label><span class="dimmed">Select a gallery!</span></label>'})
    @

  saveOnEnter: (e) ->
    return if(e.keyCode != 13)
    Spine.trigger('save:gallery', @editEl)
    
  createGallery: ->
    Spine.trigger('create:gallery')
    
  click: (e) ->
    console.log 'click'
    
    e.stopPropagation()
    e.preventDefault()
    false

module?.exports = GalleryView