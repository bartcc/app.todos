Spine       = require("spine")
$           = Spine.$
Model       = Spine.Model
Gallery     = require("models/gallery")
KeyEnhancer = require("plugins/key_enhancer")
ToolbarView = require("controllers/toolbar_view")

class GalleryEditorView extends Spine.Controller

  @extend KeyEnhancer
  
  elements:
    ".content"            : "editContent"
    '.optDestroy'         : 'destroyBtn'
    '.optSave'            : 'saveBtn'
    '.toolbar'            : 'toolbarEl'
    'galleryEditor input' : 'input'
    
  events:
    "click .optDestroy"   : "destroy"
    "click .optSave"      : "saveOnClick"
    "keyup"               : "save"

  template: (item) ->
    $("#editGalleryTemplate").tmpl item

  toolsTemplate: (items) ->
    $("#toolsTemplate").tmpl items
    
  constructor: ->
    super
    @toolbar = new ToolbarView
      el: @toolbarEl
      template: @toolsTemplate
    Gallery.bind "change", @proxy @change
    Spine.bind('change:selectedGallery', @proxy @change)
    Spine.bind('change:toolbar', @proxy @changeToolbar)
    @bind 'change', @proxy @changed
    @bind 'active', @proxy @changed

  changed: -> alert 'changed to galleries\' edit view'

  change: (item, mode) ->
    console.log 'GalleryEditView::change'
    @current = item unless item?.destroyed
    @render @current

  render: (item) ->
    console.log 'GalleryEditorView::render'
#    @current = item if item
    if @current and !(@current.destroyed)
      @destroyBtn.removeClass('disabled')
      @editContent.html $("#editGalleryTemplate").tmpl @current
      #@focusFirstInput @el
    else
      @destroyBtn.addClass('disabled')
      @destroyBtn.unbind('click')
      if Gallery.count()
        @editContent.html $("#noSelectionTemplate").tmpl({type: 'Select a Gallery!'})
      else
        @editContent.html $("#noSelectionTemplate").tmpl({type: 'Create a Gallery!'})
    @changeToolbar ['GalleryEdit']
    @el

  changeToolbar: (list) ->
    @toolbar.change list
    @refreshElements()

  renderToolbar: (el) ->
    @[el]?.html @toolsTemplate @currentToolbar
    @refreshElements()
    
  destroy: (e) ->
#    return if $(e.currentTarget).hasClass('disabled')
    Spine.trigger('destroy:gallery')
  
  saveOnClick: (el) ->
    return if $(el.currentTarget).hasClass('disabled')
    if Gallery.record
      atts = el.serializeForm?() or @el.serializeForm()
      Gallery.record.updateChangedAttributes(atts)
    App.contentManager.change(App.showView)

  save: (e) =>
    console.log 'GalleryEditorView::saveOnEnter'
    return unless (e.keyCode is 13)
      
    atts = @el.serializeForm()
    Gallery.record.updateChangedAttributes(atts)
    
  # Lazily show the tooltip that tells you to press `enter` to save
  # a new todo item, after one second.
  showTooltip: (e) ->
    tooltip = @$(".ui-tooltip-top");
    val = @input.val()
    tooltip.fadeOut()
    if (@tooltipTimeout) then clearTimeout(@tooltipTimeout)
    return if (val == '' or val is @input.attr('placeholder'))
    show = ->
      tooltip.show().fadeIn()
    @tooltipTimeout = setTimeout(show, 1000)

module?.exports = GalleryEditorView