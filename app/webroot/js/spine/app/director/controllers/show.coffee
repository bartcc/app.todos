class ShowView extends Spine.Controller

  @extend Spine.Controller.Toolbars
  
  elements:
    '#views .views'           : 'views'
    '.photosHeader'           : 'photosHeaderEl'
    '.albumsHeader'           : 'albumsHeaderEl'
    '.header'                 : 'albumHeader'
    '.optOverview'            : 'btnOverview'
    '.optEditGallery'         : 'btnEditGallery'
    '.optGallery'             : 'btnGallery'
    '.optAlbum'               : 'btnAlbum'
    '.optPhoto'               : 'btnPhoto'
    '.optUpload'              : 'btnUpload'
    '.optSlideshow'           : 'btnSlideshow'
    '.toolbar'                : 'toolBar'
    '.albums'                 : 'albumsEl'
    '.photos'                 : 'photosEl'
    
  events:
    "click .optOverview"              : "overview"
    "click .optPhotos"                : "showPhotos"
    "click .optAlbums"                : "showAlbums"
    "click .optCreatePhoto"           : "createPhoto"
    "click .optDestroyPhoto"          : "destroyPhoto"
    "click .optShowPhotos"            : "showPhotos"
    "click .optCreateAlbum"           : "createAlbum"
    "click .optShowAllAlbums"         : "showAllAlbums"
    "click .optDestroyAlbum"          : "destroyAlbum"
    "click .optEditGallery"           : "editGallery"
    "click .optCreateGallery"         : "createGallery"
    "click .optDestroyGallery"        : "destroyGallery"
    "click .optEmail"                 : "email"
    "click .optGallery"               : "toggleGallery"
    "click .optAlbum"                 : "toggleAlbum"
    "click .optPhoto"                 : "togglePhoto"
    "click .optUpload"                : "toggleUpload"
    "click .optSlideshow"             : "toggleSlideshow"
    'dblclick .draghandle'            : 'toggleDraghandle'
    'click .items'                    : "deselect" 
    
  toolsTemplate: (items) ->
    $("#toolsTemplate").tmpl items

  constructor: ->
    super
    @albumsHeader = new AlbumsHeader
      el: @albumsHeaderEl
    @photosHeader = new PhotosHeader
      el: @photosHeaderEl
    @albumsView = new AlbumsView
      el: @albumsEl
      className: 'items'
      header: @albumsHeader
      parent: @
    @photosView = new PhotosView
      el: @photosEl
      className: 'items'
      header: @photosHeader
      parent: @
    
    Spine.bind('change:canvas', @proxy @changeCanvas)
    Gallery.bind('change', @proxy @renderToolbar)
    Album.bind('change', @proxy @renderToolbar)
    Photo.bind('change', @proxy @renderToolbar)
    @bind('change:toolbar', @proxy @changeToolbar)
    @bind('render:toolbar', @proxy @renderToolbar)
    @bind("toggle:view", @proxy @toggleView)
    @current = @albumsView
    
    if @activeControl
      @initControl @activeControl
    else throw 'need initial control'
    @edit = @editGallery
    
    @canvasManager = new Spine.Manager(@albumsView, @photosView)
    @canvasManager.change @current
    @headerManager = new Spine.Manager(@albumsHeader, @photosHeader)
    @headerManager.change @albumsHeader
    
  changeCanvas: (controller) ->
    console.log 'ShowView::changeCanvas'
    @current = controller
    @el.data current:@current.el.data()
    @canvasManager.change controller
    @headerManager.change controller.header
    

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
  
  showGallery: ->
    App.contentManager.change(App.showView)
  
  showAlbums: (e) ->
    return if $(e.currentTarget).hasClass('disabled')
    Spine.trigger('show:albums')
  
  showAllAlbums: ->
    Gallery.record = false
    Spine.trigger('change:selectedGallery', false)
  
  showPhotos: (e) ->
    return if $(e.currentTarget).hasClass('disabled')
    Spine.trigger('show:photos')
  
  createGallery: (e) ->
    return if $(e.currentTarget).hasClass('disabled')
    Spine.trigger('create:gallery')
  
  createPhoto: (e) ->
    return if $(e.currentTarget).hasClass('disabled')
    Spine.trigger('create:photo')
  
  createAlbum: (e) ->
    return if $(e.currentTarget).hasClass('disabled')
    Spine.trigger('create:album')
  
  editGallery: (e) ->
    return if $(e.currentTarget).hasClass('disabled')
    App.galleryEditView.render()
    App.contentManager.change(App.galleryEditView)
    #@focusFirstInput App.galleryEditView.el

  editAlbum: (e) ->
    return if $(e.currentTarget).hasClass('disabled')
    Spine.trigger('edit:album')

  destroyGallery: (e) ->
    return if $(e.currentTarget).hasClass('disabled')
    Spine.trigger('destroy:gallery')
  
  destroyAlbum: (e) ->
    return if $(e.currentTarget).hasClass('disabled')
    Spine.trigger('destroy:album')

  destroyPhoto: (e) ->
    return if $(e.currentTarget).hasClass('disabled')
    Spine.trigger('destroy:photo')

  overview: (e) ->
    Spine.trigger('overview')

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

  toggleSlideshow: (e) ->
    @changeToolbar 'Slideshow'
    @trigger("toggle:view", App.slideshow, e.target)
  
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
    
  initControl: (control) ->
    if Object::toString.call(control) is "[object String]"
      @activeControl = @[control]
    else
      @activeControl = control
      
  deselect: (e) =>
    console.log 'ShowView::deselect'
    item = @el.data().current or @el.data()
    switch item.constructor.className
      when 'Album'
        Spine.Model['Album'].emptySelection(item.id) if item
        Photo.current()
        Spine.trigger('photo:exposeSelection')
        Spine.trigger('change:selectedPhoto', item)
      when 'Gallery'
        Spine.Model['Gallery'].emptySelection(item.id) if item
        Album.current()
        Spine.trigger('album:exposeSelection')
        Spine.trigger('change:selectedAlbum', item)
    
    if @current then $('.item', @current.el).removeClass('active')
    @renderToolbar()
    
    e.stopPropagation()
    e.preventDefault()
    false