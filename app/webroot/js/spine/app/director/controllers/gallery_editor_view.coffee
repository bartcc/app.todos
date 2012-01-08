Spine ?= require("spine")
$      = Spine.$

class GalleryEditorView extends Spine.Controller

#  @extend Spine.Controller.Toolbars
  
  elements:
    ".content"            : "editContent"
    '.optDestroy'         : 'destroyBtn'
    '.optSave'            : 'saveBtn'
    '.toolbar'            : 'toolbarEl'
    
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
    @toolbar = new ToolbarView
      el: @toolbarEl
      template: @toolsTemplate
    Gallery.bind "change", @proxy @change
    Spine.bind('save:gallery', @proxy @save)
    Spine.bind('change:selectedGallery', @proxy @change)
#    Spine.bind('change:toolbar', @proxy @changeToolbar)
    @bind('save:gallery', @proxy @save)
#    @bind('render:toolbar', @renderToolbar)

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
    tools = Toolbar.filter list
    @toolbar.change tools
    @refreshElements()

  renderToolbar: (el) ->
    @[el]?.html @toolsTemplate @currentToolbar
    @refreshElements()
    
  destroy: (e) ->
    return if $(e.currentTarget).hasClass('disabled')
    Spine.trigger('destroy:gallery')
  
  save: (el) ->
    return if $(el.currentTarget).hasClass('disabled')
    if @current and Gallery.record
      atts = el.serializeForm?() or @el.serializeForm()
      @current.updateChangedAttributes(atts)
    App.contentManager.change(App.showView)
    #@openPanel('album', App.showView.btnAlbum)

  saveOnEnter: (e) =>
    console.log 'GalleryEditorView::saveOnEnter'
    return if(e.keyCode != 13)
    @trigger('save:gallery', @)

module?.exports = GalleryEditorView