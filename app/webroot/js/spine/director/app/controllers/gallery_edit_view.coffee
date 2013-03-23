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
    'keyup .galleryEditor'  : 'showTooltip'
    'keyup'                 : 'saveOnEnter'
    'click .optCreate'      : 'createGallery'
    
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
    
  # Lazily show the tooltip that tells you to press `enter` to save
  # a new todo item, after one second.
  showTooltip_: (e) ->
    tooltip = @$(".ui-tooltip-top");
    val = @input.val()
    tooltip.fadeOut()
    if (@tooltipTimeout) then clearTimeout(@tooltipTimeout)
    return if (val == '' or val is @input.attr('placeholder'))
    show = ->
      tooltip.show().fadeIn()
    @tooltipTimeout = setTimeout(show, 1000)
    
  initPopover: ->
    popoverEl = @$('a[data-toggle=popover]')
    po = $().popover()
    console.log popoverEl
    console.log po
    
    
  # Lazily show the tooltip that tells you to press `enter` to save
  # a new todo item, after one second.
  showTooltip: (e) ->
    tooltipEl = @$('input[data-toggle=tooltip]')
      
      
    console.log 'GallerEditView::showTooltip'
    tooltipEl.tooltip
      trigger: 'manual'
      container: '.galleryEditor'
     
    window.tooltip = tooltip = tooltipEl.data('tooltip')
    
    input = @$('input.name')
    val = input.val()
    
    if (@tooltipTimeout)
      clearTimeout(@tooltipTimeout)
      
    if val is Gallery.record.name
      tooltipEl.tooltip('hide')
      return
#    return if tooltip.tip().parent().length
    show = ->
      tooltipEl.tooltip('show') unless tooltip.tip().parent().length
      
    @tooltipTimeout = setTimeout(show, 1000)
    
  showPopover: (e) ->
    popoverEl = @$('input[data-toggle=popover]')
      
    input = @$('input.name')
    val = input.val()
      
    console.log 'GallerEditView::showPopover'
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