Spine       = require("spine")
KeyEnhancer = require("plugins/key_enhancer")
Gallery     = require("models/gallery")
$           = Spine.$

class GalleryEditView extends Spine.Controller
  
  @extend KeyEnhancer
  
  elements:
    '.editGallery'              : 'editEl'
    '.optCreate'                : 'createGalleryEl'
    '.galleryEditor input.name' : 'input'

  events:
#    'keyup .galleryEditor'  : 'showTooltip'
    'keyup'                 : 'saveOnKeyup'
    'click .optCreate'      : 'createGallery'
    
  template: (item) ->
    $('#editGalleryTemplate').tmpl item

  constructor: ->
    super
    Spine.bind('change:selectedGallery', @proxy @render)
    Gallery.bind "refresh", @proxy @refresh

  change: (item, mode) ->
    console.log 'GalleryEditView::change'
    @current = Gallery.record
    @render()

  refresh: ->
    @render()

  render: ->
#    @el.tooltip('destroy')
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

  save: (el) ->
    console.log 'GalleryEditView::save'
    if gallery = Gallery.record
      atts = el.serializeForm?() or @editEl.serializeForm()
      gallery.updateAttributes(atts)

  saveOnKeyup: (e) ->
    console.log 'GalleryEditView::saveOnEnter'
    
    code = e.charCode or e.keyCode
        
    switch code
      when 32 # SPACE
        e.stopPropagation() 
      when 9 # TAB
        e.stopPropagation()
        
    @save @editEl
    
  createGallery: ->
    Spine.trigger('create:gallery')
    
  click: (e) ->
    e.stopPropagation()
    e.preventDefault()
    
  initPopover: ->
    popoverEl = @$('a[data-toggle=popover]')
    po = $().popover()
    console.log popoverEl
    console.log po
    
  showPopover: (e) ->
    console.log 'GallerEditView::showPopover'
    
    popoverEl = @$('input[data-toggle=popover]')
    input = @$('input.name')
    val = input.val()
      
    popoverEl.popover
      trigger: 'manual'
      container: '.galleryEditor'
      content: val
     
    window.popover = popover = popoverEl.data('popover')
    
    if (@popoverTimeout)
      clearTimeout(@popoverTimeout)
      
    if val is Gallery.record.name
      popoverEl.popover('hide')
      return
#    return if tooltip.tip().parent().length
    show = ->
      popoverEl.popover('show') #unless popover.tip().parent().length
      
    @popoverTimeout = setTimeout(show, 1000)

module?.exports = GalleryEditView