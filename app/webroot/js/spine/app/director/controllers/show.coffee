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
    '.optGallery .ui-icon'    : 'btnGallery'
    '.optAlbum .ui-icon'      : 'btnAlbum'
    '.optPhoto .ui-icon'      : 'btnPhoto'
    '.optUpload .ui-icon'     : 'btnUpload'
    '.optSlideshow .ui-icon'  : 'btnSlideshow'
    '.toolbar'                : 'toolbarEl'
    '.props'                  : 'propsEl'
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
    "click .optGallery .ui-icon"      : "toggleGalleryShow"
    "click .optAlbum .ui-icon"        : "toggleAlbumShow"
    "click .optPhoto .ui-icon"        : "togglePhotoShow"
    "click .optUpload .ui-icon"       : "toggleUploadShow"
    "click .optSlideshow .ui-icon"    : "toggleSlideshowShow"
    "click .optGallery"               : "toggleGallery"
    "click .optAlbum"                 : "toggleAlbum"
    "click .optPhoto"                 : "togglePhoto"
    "click .optUpload"                : "toggleUpload"
    "click .optSlideshow"             : "toggleSlideshow"
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
    Gallery.bind('change', @proxy @changeToolbar)
    Album.bind('change', @proxy @changeToolbar)
    Photo.bind('change', @proxy @changeToolbar)
    Spine.bind('change:toolbar', @proxy @changeToolbar)
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
    @el.data
      current: controller.el.data().current.record
      className: controller.el.data().current.className
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
    @deselect()
  
  destroyAlbum: (e) ->
    Spine.trigger('destroy:album')
    @deselect()

  destroyPhoto: (e) ->
    Spine.trigger('destroy:photo')
    @deselect()

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
    
  toggleGalleryShow: (e) ->
    @trigger("toggle:view", App.gallery, e.target)
    e.stopPropagation()
    e.preventDefault()
    false
    
  toggleGallery: (e) ->
    @changeToolbar 'Gallery', e.target

  toggleAlbumShow: (e) ->
    @trigger("toggle:view", App.album, e.target)
    e.stopPropagation()
    e.preventDefault()
    false

  toggleAlbum: (e) ->
    @changeToolbar 'Album'
    
  togglePhotoShow: (e) ->
    @trigger("toggle:view", App.photo, e.target)
    e.stopPropagation()
    e.preventDefault()
    false
    
  togglePhoto: (e) ->
    @changeToolbar 'Photo', e.target, App.showView.initSlider

  toggleUploadShow: (e) ->
    @trigger("toggle:view", App.upload, e.target)
    e.stopPropagation()
    e.preventDefault()
    false
    
  toggleUpload: (e) ->
    @changeToolbar 'Upload', e.target

  toggleSlideshowShow: (e) ->
    @trigger("toggle:view", App.slideshow, e.target)
    e.stopPropagation()
    e.preventDefault()
    false

  toggleSlideshow: (e) ->
    @changeToolbar 'Slideshow', e.target
  
  toggleView: (controller, control) ->
    isActive = controller.isActive()
    
    if(isActive)
      App.hmanager.trigger("change", false)
    else
      @activeControl = $(control)
      App.hmanager.trigger("change", controller)
    
    @propsEl.find('.ui-icon').removeClass('ui-icon-carat-1-s')
    $(control).toggleClass('ui-icon-carat-1-s', !isActive)
    @renderViewControl controller, control
    @animateView()
  
  toggleDraghandle: ->
    @activeControl.click()
    
  initControl: (control) ->
    if Object::toString.call(control) is "[object String]"
      @activeControl = @[control]
    else
      @activeControl = control
      
  deselect: =>
    item = @el.data().current
    className = @el.data().className
    switch className
      when 'Photo'
        -> # nothing to do here
      when 'Album'
        Spine.Model['Album'].emptySelection()
        Photo.current()
        Spine.trigger('photo:exposeSelection')
        Spine.trigger('change:selectedPhoto', item)
      when 'Gallery'
        Spine.Model['Gallery'].emptySelection()
        Album.current()
        Spine.trigger('album:exposeSelection')
        Spine.trigger('album:activate')
      else
        Gallery.current()
        Spine.trigger('gallery:exposeSelection')
        Spine.trigger('gallery:activate')
        
    @changeToolbar()
    @current.items.deselect()
    
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