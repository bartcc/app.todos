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
    '.optEditGallery'         : 'btnEditGallery'
    '.optGallery'             : 'btnGallery'
    '.optAlbum'               : 'btnAlbum'
    '.optPhoto'               : 'btnPhoto'
    '.optUpload'              : 'btnUpload'
    '.optGrid'                : 'btnGrid'
#    '.header'                 : 'header'
    '.toolbar'                : 'toolBar'
    
    
  events:
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
    "click .optGrid"                  : "toggleGrid"
    'dblclick .draghandle'            : 'toggleDraghandle'
    'click .items'                    : "deselect" 
    
    
  toolsTemplate: (items) ->
    $("#toolsTemplate").tmpl items

#  headerTemplate: (className, items) ->
#    switch className
#      when 'Album'
#        items.gallery = Gallery.record
#        $("#headerAlbumTemplate").tmpl items
#      when 'Gallery'
#        $("#headerGalleryTemplate").tmpl items
      
    
  constructor: ->
    super
    Spine.bind('render:header', @proxy @renderHeader)
    Spine.bind('change:canvas', @proxy @changeCanvas)
    @bind('change:toolbar', @proxy @changeToolbar)
    @bind('render:toolbar', @proxy @renderToolbar)
    @bind("toggle:view", @proxy @toggleView)
    
    
#    @albumsView = new AlbumsView
#      el: @albumsEl
#      toolbar: 'Gallery'
#    @imagesView = new ImagesView
#      el: @imagesEl
      
    if @activeControl
      @initControl @activeControl
    else throw 'need initial control'
    @edit = @editGallery
    
#    @contentManager = new Spine.Manager(@albumsView, @imagesView)
    
  changeCanvas: (controller) ->
    App.canvasManager.trigger('change', controller)
    @current = controller
      
#  renderHeader: (model, items) ->
#    console.log 'ShowView::renderHeader'
#    values = {record: model.record, count: items.length}
#    @header.html @headerTemplate model.className, values

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
    console.log e
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
    
  initControl: (control) ->
    if Object::toString.call(control) is "[object String]"
      @activeControl = @[control]
    else
      @activeControl = control
      
  deselect: (e) ->
    item = $(e.currentTarget).item()
    item?.emptySelection()
    $('.item', @current.el).removeClass('active')
    console.log item
    Spine.trigger('expose:sublistSelection', Gallery.record) if item instanceof Gallery
    
    e.stopPropagation()
    e.preventDefault()
    false