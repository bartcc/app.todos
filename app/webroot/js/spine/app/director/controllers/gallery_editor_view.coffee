Spine ?= require("spine")
$      = Spine.$

class GalleryEditorView extends Spine.Controller

  @extend Spine.Controller.Toolbars
  
  elements:
    ".content"            : "editContent"
    '.optDestroy'         : 'destroyBtn'
    '.optSave'            : 'saveBtn'
    '.toolbar'            : 'toolBar'
    
  events:
    "click .optEdit"      : "edit"
    "click .optEmail"     : "email"
    "click .optDestroy"   : "destroy"
    "click .optSave"      : "save"
    "keydown"             : "saveOnEnter"

  template: (item) ->
    $("#editGalleryTemplate").tmpl item

  toolsTemplate: (items) ->
    $("#toolsTemplate").tmpl items
    
  constructor: ->
    super
    Gallery.bind "change", @proxy @change
    Spine.bind('save:gallery', @proxy @save)
    Spine.bind('change:selectedGallery', @proxy @change)
    @bind('save:gallery', @proxy @save)
    @bind('render:toolbar', @proxy @renderToolbar)

  change: (item, mode) ->
    console.log 'GalleryEditView::change'
    @current = item unless item?.destroyed
    @render @current

  render: (item) ->
    console.log 'GalleryEditView::render'
    @current = item if item
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
    @changeToolbar 'GalleryEdit'
    @

  renderToolbar: ->
    console.log 'GalleryEditView::renderToolbar'
    @toolBar.html @toolsTemplate @currentToolbar
    @refreshElements()
    
  destroy: (e) ->
    console.log 'GalleryEditView::destroy'
    return if $(e.currentTarget).hasClass('disabled')
    Spine.trigger('destroy:gallery')
  
  save: (el) ->
    console.log 'GalleryEditView::save'
    return if $(el.currentTarget).hasClass('disabled')
    if @current and Gallery.record
      atts = el.serializeForm?() or @el.serializeForm()
      @current.updateChangedAttributes(atts)
    App.contentManager.change(App.showView)
    #@openPanel('album', App.showView.btnAlbum)

  saveOnEnter: (e) =>
    console.log 'GalleryEditView::saveOnEnter'
    return if(e.keyCode != 13)
    @trigger('save:gallery', @)

module?.exports = GalleryEditorView