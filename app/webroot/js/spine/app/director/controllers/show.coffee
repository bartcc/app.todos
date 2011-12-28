class ShowView extends Spine.Controller

  @extend Spine.Controller.Toolbars
  
  elements:
    '#views .views'           : 'views'
    '.galleriesHeader'        : 'galleriesHeaderEl'
    '.albumsHeader'           : 'albumsHeaderEl'
    '.photosHeader'           : 'photosHeaderEl'
    '.photoHeader'            : 'photoHeaderEl'
    '.header'                 : 'albumHeader'
    '.optOverview'            : 'btnOverview'
    '.optEditGallery'         : 'btnEditGallery'
    '.optGallery'             : 'btnGallery'
    '.optAlbum'               : 'btnAlbum'
    '.optPhoto'               : 'btnPhoto'
    '.optUpload'              : 'btnUpload'
    '.optSlideshow'           : 'btnSlideshow'
    '.toolbar'                : 'toolbarEl'
    '.galleries'              : 'galleriesEl'
    '.albums'                 : 'albumsEl'
    '.photos'                 : 'photosEl'
    '.photo'                  : 'photoEl'
    '#slider'                 : 'slider'
    
  events:
    "click .optOverview"              : "showOverview"
#    "click .optPhotos"                : "showPhotos"
#    "click .optAlbums"                : "showAlbums"
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
#    "click .optThumbsize"             : "showSlider"
    'dblclick .draghandle'            : 'toggleDraghandle'
    'click .items'                    : "deselect" 
    'fileuploadprogress'              : "uploadProgress" 
    'fileuploaddone'                  : "uploadDone"
    'slide #slider'                   : 'sliderSlide'
    'slidestop #slider'               : 'sliderStop'
    'slidestart #slider'              : 'sliderStart'
    
  toolsTemplate: (items) ->
    $("#toolsTemplate").tmpl items

  constructor: ->
  
#    @toolBar = new Toolbar()
    super
    @photoHeader = new PhotoHeader
      el: @photoHeaderEl
    @photosHeader = new PhotosHeader
      el: @photosHeaderEl
    @albumsHeader = new AlbumsHeader
      el: @albumsHeaderEl
    @galleriesHeader = new GalleriesHeader
      el: @galleriesHeaderEl
    @galleriesView = new GalleriesView
      el: @galleriesEl
      className: 'items'
      header: @galleriesHeader
      parent: @
    @albumsView = new AlbumsView
      el: @albumsEl
      className: 'items'
      header: @albumsHeader
      parent: @
      parentModel: 'Gallery'
    @photosView = new PhotosView
      el: @photosEl
      className: 'items'
      header: @photosHeader
      parent: @
      parentModel: 'Album'
    @photoView = new PhotoView
      el: @photoEl
      className: 'items'
      header: @photoHeader
      parent: @
      parentModel: 'Photo'
    
    Spine.bind('change:canvas', @proxy @changeCanvas)
    Gallery.bind('change', @proxy @renderToolbar)
    Album.bind('change', @proxy @renderToolbar)
    Photo.bind('change', @proxy @renderToolbar)
    @bind('change:toolbar', @proxy @changeToolbar)
    @bind("toggle:view", @proxy @toggleView)
    @current = @albumsView
    @sOutValue = 110
    
    if @activeControl
      @initControl @activeControl
    else throw 'need initial control'
    @edit = @editGallery
    
    @canvasManager = new Spine.Manager(@galleriesView, @albumsView, @photosView, @photoView)
    @canvasManager.change @current
    @headerManager = new Spine.Manager(@galleriesHeader, @albumsHeader, @photosHeader, @photoHeader)
    @headerManager.change @albumsHeader
    
  changeCanvas: (controller) ->
    console.log 'ShowView::changeCanvas'
    @current = controller
    @el.data current:@current.el.data()
    @canvasManager.change controller
    @headerManager.change controller.header
    
  renderToolbar: ->
    console.log 'ShowView::renderToolbar'
    @toolbarEl.html @toolsTemplate @currentToolbar
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
    Spine.trigger('show:albums')
  
  showAllAlbums: ->
    Spine.trigger('show:allAlbums')
  
  showPhotos: (e) ->
    Spine.trigger('show:photos')
  
  createGallery: (e) ->
    Spine.trigger('create:gallery')
  
  createPhoto: (e) ->
    Spine.trigger('create:photo')
  
  createAlbum: (e) ->
    Spine.trigger('create:album')
  
  editGallery: (e) ->
    Spine.trigger('edit:gallery')
    #@focusFirstInput App.galleryEditView.el

  editAlbum: (e) ->
    Spine.trigger('edit:album')

  destroyGallery: (e) ->
    Spine.trigger('destroy:gallery')
  
  destroyAlbum: (e) ->
    Spine.trigger('destroy:album')

  destroyPhoto: (e) ->
    Spine.trigger('destroy:photo')

  showOverview: (e) ->
    Spine.trigger('show:overview')

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
    @changeToolbar 'Gallery'
#    @toolbar.change 'Gallery'
    @trigger("toggle:view", App.gallery, e.target)

  toggleAlbum: (e) ->
    @changeToolbar 'Album'
#    @toolbar.change 'Album'
    @trigger("toggle:view", App.album, e.target)
    
  togglePhoto: (e) ->
    @changeToolbar 'Photo', App.showView.initSlider
#    @toolbar.change 'Photo'
    @trigger("toggle:view", App.photo, e.target)

  toggleUpload: (e) ->
    @changeToolbar 'Upload'
#    @toolbar.change 'Upload'
    @trigger("toggle:view", App.upload, e.target)

  toggleSlideshow: (e) ->
    @changeToolbar 'Slideshow'
#    @toolbar.change 'Slideshow'
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
    item = @el.data().current
    switch item.constructor.className
      when 'Photo'
        ->
      when 'Album'
        Spine.Model['Album'].emptySelection()
        Photo.current()
        Spine.trigger('photo:exposeSelection')
        Spine.trigger('change:selectedPhoto', item)
      when 'Gallery'
        Spine.Model['Gallery'].emptySelection()
        Album.current()
        Spine.trigger('album:exposeSelection')
        Spine.trigger('change:selectedAlbum', item)
      else
        Gallery.current()
        Spine.trigger('gallery:exposeSelection')
        Spine.trigger('change:selectedGallery', false)
        
    @trigger('change:toolbar')
    @current.items.deselect()
    
    e.stopPropagation()
    e.preventDefault()
    false
    
  uploadProgress: (e, coll) ->
    console.log coll
    
  uploadDone: (e, coll) ->
    console.log coll
    
  sliderInValue: (val) ->
    val = val or @sOutValue
    @sInValue=(val/2)-20
    
  sliderOutValue: ->
    val = @slider.slider('value')
    @sOutValue=(val+20)*2
    
  initSlider: =>
    inValue = @sliderInValue()
    @refreshElements()
    @slider.slider
      orientation: 'horizonatal'
      value: inValue
    
  showSlider: ->
    @initSlider()
#    @slider.toggle()
    @sliderOutValue()
    @sliderInValue()
      
  sliderStart: =>
    @photosView.list.sliderStart()
    
  sliderSlide: =>
    @photosView.list.size @sliderOutValue()
    
  sliderStop: =>
    # rerender thumbnails on the server to its final size
#    @slider.toggle()