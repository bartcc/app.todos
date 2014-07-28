Spine       = require("spine")
KeyEnhancer = require("plugins/key_enhancer")
Extender    = require('plugins/controller_extender')
Gallery     = require("models/gallery")
Root        = require("models/root")
$           = Spine.$

class GalleryEditView extends Spine.Controller
  
  @extend Extender
  
  events:
    'keyup'                   : 'saveOnKeyup'
    
  template: (item) ->
    $('#editGalleryTemplate').tmpl item

  constructor: ->
    super
    @bind('active', @proxy @active)
    Root.bind('change:selection', @proxy @change)

  active: ->
    @render()

  change: (parent, selection=[]) ->
    @current = Gallery.find(selection.first())
    @render()
    
  change_: (item) ->
    @current = item
    @render()

  render: () ->
    if @current 
      @html @template @current
    else
      unless Gallery.count()
        @html $("#noSelectionTemplate").tmpl({type: '<label class="invite"><span class="enlightened">Director has no gallery yet &nbsp;<button class="opt-CreateGallery dark large">New Gallery</button></span></label>'})
      else
        @html $("#noSelectionTemplate").tmpl({type: '<label class="invite"><span class="enlightened">Select a gallery!</span></label>'})
    @el

  save: (el) ->
    @log 'save'
    if gallery = Gallery.record
      atts = el.serializeForm?() or @el.serializeForm()
      gallery.updateChangedAttributes(atts)

  saveOnKeyup: (e) ->
    @log 'saveOnEnter'
    
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