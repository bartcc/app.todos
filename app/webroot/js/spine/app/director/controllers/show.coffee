class ShowView extends Spine.Controller

  @extend Spine.Controller.Toolbars
  
  elements:
    '.content.albums'         : 'albumsEl'
    '.content.images'         : 'imagesEl'
    '#views .views'           : 'views'
#    '#gallery'            : 'galleryEl'
#    '#album'              : 'albumEl'
#    '#photo'              : 'photoEl'
#    '#upload'             : 'uploadEl'
#    '#loader'             : 'loaderEl'
#    '#grid'               : 'gridEl'
    '.optGallery'             : 'btnGallery'
    '.optAlbum'               : 'btnAlbum'
    '.optUpload'              : 'btnUpload'
    '.optGrid'                : 'btnGrid'
    '.header'                 : 'header'
    '.toolbar'                : 'toolBar'
    
    
  events:
    "click .optPhotos"                : "changeToPhotosView"
    "click .optAlbums"                : "changeToAlbumsView"
    "click .optCreatePhoto"           : "createPhoto"
    "click .optDestroyPhoto"          : "destroyPhoto"
    "click .optShowPhotos"            : "showPhotos"
    "click .optCreateAlbum"           : "createAlbum"
    "click .optDestroyAlbum"          : "destroyAlbum"
    "click .optEditGallery"           : "editGallery"
    "click .optCreateGallery"         : "createGallery"
    "click .optDestroyGallery"        : "destroyGallery"
    "click .optEmail"                 : "email"
    "click .optGallery"               : "toggleGallery"
    "click .optAlbum"                 : "toggleAlbum"
    "click .optPhoto"                 : "togglePhoto"
    "click .optUpload"                : "toggleUpload"
    "click .optGrid"                  : "toggleGrid"
    'dblclick .draghandle'            : 'toggleDraghandle'
    
    
  toolsTemplate: (items) ->
    $("#toolsTemplate").tmpl items

  headerTemplate: (items) ->
    $("#headerTemplate").tmpl items
    
  constructor: ->
    super
    @bind("toggle:view", @proxy @toggleView)
    @bind('render:toolbar', @proxy @renderToolbar)

    Spine.bind('change:toolbar', @proxy @changeToolbar)
    Spine.bind('render:albums', @proxy @renderHeader)
    
#    @albumsView = new AlbumsView
#      el: @albumsEl
#      toolbar: 'Gallery'
#    @imagesView = new ImagesView
#      el: @imagesEl
      
      
    @activeControl = @btnGallery
    @edit = @editGallery
    @changeToolbar @toolbar if @toolbar
#    @contentManager = new Spine.Manager(@albumsView, @imagesView)
    
      
  changeToAlbumsView: ->
    Spine.trigger('show:albums')
    
  changeToPhotosView: ->
    Spine.trigger('show:photos')
    
  renderHeader: (items) ->
    console.log 'ShowView::renderHeader'
    values = {record: Gallery.record, count: items.length}
    @header.html @headerTemplate values

  renderToolbar: ->
    console.log 'ShowView::renderToolbar'
    @toolBar.html @toolsTemplate @currentToolbar
    @refreshElements()
    
  renderViewControl: (controller, controlEl) ->
    active = controller.isActive()

    $(".options .opt").each ->
      if(@ == controlEl)
        $(@).toggleClass("active", active)
      else
        $(@).removeClass("active")
    
  
  showPhotos: (e) ->
    return if $(e.currentTarget).hasClass('disabled')
    Spine.trigger('show:photos')
  
  createPhoto: (e) ->
    return if $(e.currentTarget).hasClass('disabled')
    Spine.trigger('create:photo')
  
  destroyPhoto: (e) ->
    return if $(e.currentTarget).hasClass('disabled')
    Spine.trigger('destroy:photo')  

  editAlbum: (e) ->
    return if $(e.currentTarget).hasClass('disabled')
    Spine.trigger('edit:album')
  
  createAlbum: (e) ->
    console.log e
    return if $(e.currentTarget).hasClass('disabled')
    Spine.trigger('create:album')
  
  destroyAlbum: (e) ->
    return if $(e.currentTarget).hasClass('disabled')
    Spine.trigger('destroy:album')  

  editGallery: (e) ->
    return if $(e.currentTarget).hasClass('disabled')
    App.galleryEditView.render()
    App.contentManager.change(App.galleryEditView)
    #@focusFirstInput App.galleryEditView.el

  createGallery: (e) ->
    return if $(e.currentTarget).hasClass('disabled')
    Spine.trigger('create:gallery')
  
  destroyGallery: (e) ->
    return if $(e.currentTarget).hasClass('disabled')
    Spine.trigger('destroy:gallery')  
  
  showGallery: ->
    App.contentManager.change(App.showView)
  
  animateView: ->
    hasActive = ->
      if App.hmanager.hasActive()
        return App.hmanager.enableDrag()
      App.hmanager.disableDrag()
    
    
    height = ->
      App.hmanager.currentDim
      if hasActive() then parseInt(App.hmanager.currentDim)+"px" else "8px"
    
    @views.animate
      height: height()
      400
    
  toggleGallery: (e) ->
    @changeToolbar Gallery
    @trigger("toggle:view", App.gallery, e.target)

  toggleAlbum: (e) ->
    @changeToolbar Album
    @trigger("toggle:view", App.album, e.target)
    
  togglePhoto: (e) ->
    @changeToolbar Photo
    @trigger("toggle:view", App.photo, e.target)

  toggleUpload: (e) ->
    @changeToolbar 'Upload'
    @trigger("toggle:view", App.upload, e.target)

  toggleGrid: (e) ->
    @changeToolbar 'Grid'
    @trigger("toggle:view", App.grid, e.target)
  
  toggleView: (controller, control) ->
    isActive = controller.isActive()
    
    if(isActive)
      App.hmanager.trigger("change", false)
    else
      @activeControl = $(control)
      App.hmanager.trigger("change", controller)
    
    @renderViewControl controller, control
    @animateView()
  
  toggleDraghandle: ->
    @activeControl.click()