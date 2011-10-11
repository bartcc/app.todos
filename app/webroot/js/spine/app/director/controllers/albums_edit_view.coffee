Spine ?= require("spine")
$      = Spine.$

class AlbumsEditView extends Spine.Controller

  elements:
    ".content"            : "editContent"
    '.optDestroy'         : 'btnDestroy'
    
  events:
    "click .optEdit"      : "edit"
    "click .optEmail"     : "email"
    "click .optDestroy"   : "destroy"
    "click .optSave"      : "save"
    "keydown"             : "saveOnEnter"

  template: (item) ->
    $("#editGalleryTemplate").tmpl item

  constructor: ->
    super
    Gallery.bind "change", @proxy @change
    Spine.bind('save:gallery', @proxy @save)
    @bind('save:gallery', @proxy @save)
    Spine.bind('change:selectedGallery', @proxy @change)
    @create = @edit

  change: (item, mode) ->
    console.log 'AlbumsEditView::change'
    @current = item if !(item?.destroyed)
    @render @current

  render: (item) ->
    console.log 'AlbumsEditView::render'
    @current = item if item
    if @current and !(@current.destroyed)
      @btnDestroy.removeClass('disabled')
      @editContent.html $("#editGalleryTemplate").tmpl @current
      @focusFirstInput @el
    else
      @btnDestroy.addClass('disabled')
      @btnDestroy.unbind('click')
      if Gallery.count()
        @editContent.html $("#noSelectionTemplate").tmpl({type: 'Select a Gallery!'})
      else
        @editContent.html $("#noSelectionTemplate").tmpl({type: 'Create a Gallery!'})
        
    @

  destroy: ->
    console.log 'AlbumsEditView::destroy'
    return unless Gallery.record
    Spine.trigger('destroy:gallery')
  
  save: (el) ->
    console.log 'AlbumsEditView::save'
    if @current
      atts = el.serializeForm?() or @el.serializeForm()
      @current.updateChangedAttributes(atts)
    App.albumsManager.change(App.albumsShowView)
    @openPanel('album', App.albumsShowView.btnAlbum)

  saveOnEnter: (e) =>
    console.log 'AlbumsEditView::saveOnEnter'
    return if(e.keyCode != 13)
    @trigger('save:gallery', @)

module?.exports = AlbumsView