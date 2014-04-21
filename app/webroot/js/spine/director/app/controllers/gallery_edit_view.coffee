Spine       = require("spine")
KeyEnhancer = require("plugins/key_enhancer")
Extender    = require('plugins/controller_extender')
Gallery     = require("models/gallery")
$           = Spine.$

class GalleryEditView extends Spine.Controller
  
  @extend Extender
  
  events:
    'keyup'                   : 'saveOnKeyup'
    
  template: (item) ->
    $('#editGalleryTemplate').tmpl item

  constructor: ->
    super
    Gallery.bind('current', @proxy @change)

  activated: ->
    @render()

  change: (item) ->
    console.log 'GalleryEditView::change'
    @current = item
    @render()

  render: (item=@current) ->
#    @el.tooltip('destroy')
    console.log 'GalleryEditView::render'
#    return unless @isActive()
    if item and !item.destroyed 
      @html @template item
#      @focusFirstInput()
    else
      unless Gallery.count()
        @html $("#noSelectionTemplate").tmpl({type: '<label class="invite"><span class="enlightened">Director has no gallery yet &nbsp;<button class="opt-Create dark large">New Gallery</button></span></label>'})
      else
        @html $("#noSelectionTemplate").tmpl({type: '<label class="invite"><span class="enlightened">Select a gallery!</span></label>'})
    @el

  save: (el) ->
    console.log 'GalleryEditView::save'
    if gallery = Gallery.record
      atts = el.serializeForm?() or @el.serializeForm()
      gallery.updateChangedAttributes(atts)

  saveOnKeyup: (e) ->
    console.log 'GalleryEditView::saveOnEnter'
    
    code = e.charCode or e.keyCode
        
    switch code
      when 32 # SPACE
        e.stopPropagation() 
      when 9 # TAB
        e.stopPropagation()
        
    @save @el
    
  createGallery: ->
    Spine.trigger('create:gallery')
    
  click: (e) ->
    
module?.exports = GalleryEditView