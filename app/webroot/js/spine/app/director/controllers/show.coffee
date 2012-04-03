class ShowView extends Spine.Controller

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
    '.optQuickUpload'         : 'btnQuickUpload'
    '.optFullScreen'          : 'btnFullScreen'
    '.optSlideshow'           : 'btnSlideshow'
    '.toolbarOne'             : 'toolbarOneEl'
    '.toolbarTwo'             : 'toolbarTwoEl'
    '.props'                  : 'propsEl'
    '.galleries'              : 'galleriesEl'
    '.albums'                 : 'albumsEl'
    '.photos'                 : 'photosEl'
    '.photo'                  : 'photoEl'
    '.slideshow'              : 'slideshowEl'
    '.slider'                 : 'slider'
    '.close'                  : 'btnClose'
    '.optAlbum'               : 'btnAlbum'
    '.optGallery'             : 'btnGallery'
    '.optPhoto'               : 'btnPhoto'
    '.optUpload'              : 'btnUpload'
    
  events:
    'click .optQuickUpload:not(.disabled)'           : 'toggleQuickUpload'
    'click .optOverview:not(.disabled)'              : 'showOverview'
    'click .optPrevious:not(.disabled)'              : 'showPrevious'
    'click .optShowModal:not(.disabled)'             : 'showModal'
    'click .optFullScreen:not(.disabled)'            : 'toggleFullScreen'
    'click .optCreateGallery:not(.disabled)'         : 'createGallery'
    'click .optCreateAlbum:not(.disabled)'           : 'createAlbum'
    'click .optCreatePhoto:not(.disabled)'           : 'createPhoto'
    'click .optDestroyGallery:not(.disabled)'        : 'destroyGallery'
    'click .optDestroyAlbum:not(.disabled)'          : 'destroyAlbum'
    'click .optDestroyPhoto:not(.disabled)'          : 'destroyPhoto'
    'click .optEditGallery:not(.disabled)'           : 'editGallery' # for the large edit view
    'click .optGallery:not(.disabled)'               : 'toggleGalleryShow'
    'click .optAlbum:not(.disabled)'                 : 'toggleAlbumShow'
    'click .optPhoto:not(.disabled)'                 : 'togglePhotoShow'
    'click .optUpload:not(.disabled)'                : 'toggleUploadShow'
    'click .optShowAllAlbums:not(.disabled)'         : 'showAllAlbums'
    'click .optShowAllPhotos:not(.disabled)'         : 'showAllPhotos'
    'click .optSlideshowAutoStart:not(.disabled)'    : 'toggleSlideshowAutoStart'
    'click .optShowSlideshow:not(.disabled)'         : 'showSlideshow'
    'click .optSlideshowPlay:not(.disabled)'         : 'slideshowPlay'
    'click .optClose:not(.disabled)'                 : 'toggleDraghandle'
    'click .optSelectAll:not(.disabled)'             : 'selectAll'
    'click .draghandle'                              : 'toggleDraghandle'
    'click .draghandle.optClose'                     : 'closeDraghandle'
    'click .items'                                   : 'deselect'
    'slidestop .slider'                              : 'sliderStop'
    'slidestart .slider'                             : 'sliderStart'

  constructor: ->
    super
    @silent = true
    @toolbarOne = new ToolbarView
      el: @toolbarOneEl
    @toolbarTwo = new ToolbarView
      el: @toolbarTwoEl
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
      assocControl: 'optGallery'
      header: @galleriesHeader
      parent: @
    @albumsView = new AlbumsView
      el: @albumsEl
      className: 'items'
      header: @albumsHeader
      parentModel: 'Gallery'
      parent: @
    @photosView = new PhotosView
      el: @photosEl
      className: 'items'
      header: @photosHeader
      parentModel: 'Album'
      parent: @
    @photoView = new PhotoView
      el: @photoEl
      className: 'items'
      header: @photoHeader
      parent: @
      parentModel: 'Photo'
    @slideshowView = new SlideshowView
      el: @slideshowEl
      className: 'items'
      header: false
      parent: @
      parentModel: 'Photo'
      subview: true
    
    @bind('canvas', @proxy @canvas)
    @bind('change:toolbarOne', @proxy @changeToolbarOne)
    @bind('change:toolbarTwo', @proxy @changeToolbarTwo)
    @bind('toggle:view', @proxy @toggleView)
    @toolbarOne.bind('refresh', @proxy @refreshToolbar)
    
    Gallery.bind('change', @proxy @changeToolbarOne)
    Album.bind('change', @proxy @changeToolbarOne)
    Photo.bind('change', @proxy @changeToolbarOne)
    Spine.bind('change:selectedAlbum', @proxy @refreshToolbars)
    
    Spine.bind('show:allPhotos', @proxy @showAllPhotos)
    Spine.bind('show:allAlbums', @proxy @showAllAlbums)
    
    @current = @albumsView
    @slideshowMode = App.SILENTMODE
    @sOutValue = 74 # size thumbs initially are shown (slider setting)
    @thumbSize = 240 # size thumbs are created serverside (should be as large as slider max for best quality)
    @slideshowAutoStart = true
    @edit = @editGallery
    
    @canvasManager = new Spine.Manager(@galleriesView, @albumsView, @photosView, @photoView, @slideshowView)
    @canvasManager.change @current
    @headerManager = new Spine.Manager(@galleriesHeader, @albumsHeader, @photosHeader, @photoHeader)
    @headerManager.change @albumsHeader
#    @el.dropdown( '.dropdown-toggle' )
    
    
  canvas: (controller) ->
    console.log 'ShowView::changeCanvas'
    @previous = @current unless @current.subview
    @current = controller
    @el.data
      current: controller.el.data().current.record
      className: controller.el.data().current.className
#    controller.trigger 'active'
#    controller.header.trigger 'active' if controller.header
    @canvasManager.change controller
    @headerManager.change controller.header
    
  changeToolbarOne: (list) ->
    @toolbarOne.change list
    @toolbarTwo.refresh()
    @refreshElements()
    
  changeToolbarTwo: (list) ->
    @toolbarTwo.change list
    @refreshElements()
    
  refreshToolbar: (toolbar, lastControl) ->
    
  refreshToolbars: ->
    console.log 'ShowView::refreshToolbars'
    @toolbarOne.refresh()
    @toolbarTwo.refresh()
    
  renderViewControl: (controller, controlEl) ->
    active = controller.isActive()

    $('.options .opt').each ->
      if(@ == controlEl)
        $(@).toggleClass('active', active)
      else
        $(@).removeClass('active')
  
  createGallery: (e) ->
    Spine.trigger('create:gallery')
  
  createPhoto: (e) ->
    Spine.trigger('create:photo')
  
  createAlbum: (e) ->
    Spine.trigger('create:album')
  
  editGallery: (e) ->
    Spine.trigger('edit:gallery')

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

  toggleGalleryShow: (e) ->
    @trigger('toggle:view', App.gallery, e.target)
#    e.stopPropagation()
    e.preventDefault()
    
  toggleGallery: (e) ->
    @changeToolbarOne ['Gallery']

  toggleAlbumShow: (e) ->
    @trigger('toggle:view', App.album, e.target)
    e.preventDefault()

  toggleAlbum: (e) ->
    @changeToolbarOne ['Album']
    
  togglePhotoShow: (e) ->
    @trigger('toggle:view', App.photo, e.target)
    e.preventDefault()
    
  togglePhoto: (e) ->
    @changeToolbarOne ['Photos', 'Slider']#, App.showView.initSlider

  toggleUploadShow: (e) ->
    @trigger('toggle:view', App.upload, e.target)
    e.preventDefault()
    
  toggleUpload: (e) ->
    @changeToolbarOne ['Upload']

  toggleFullScreen: () ->
    @slideshowView.toggleFullScreen()
    @toolbarTwo.change()
    
  toggleSlideshow: ->
    active = @btnSlideshow.toggleClass('active').hasClass('active')
    @slideshowView.slideshowMode(active)

  toggleSlideshowAutoStart: ->
    x = @slideshowAutoStart = !@slideshowAutoStart
    @refreshToolbars()
    x
  
  toggleDraghandle: ->
    UI = App.hmanager.externalUI()
    if UI.hasClass('disabled')
      UI.removeClass('disabled').click().addClass('disabled')
    else
      UI.click()
    false
    
  closeDraghandle: ->
    @toggleDraghandle()
    
  toggleQuickUpload: ->
    @refreshElements()
    active = @btnQuickUpload.find('i').toggleClass('icon-ok icon-').hasClass('icon-ok')
    @quickUpload active
    active
    
  toggleView: (controller, control) ->
    console.log 'toggleView'
    isActive = controller.isActive()
    
    if(isActive)
      App.hmanager.trigger('change', false)
    else
      @activeControl = control
      App.hmanager.trigger('change', controller)
    
    @propsEl.find('.ui-icon').removeClass('ui-icon-carat-1-s')
    $(control).toggleClass('ui-icon-carat-1-s', !isActive)
    @renderViewControl controller, control
    @animateView()
    
  animateView: ->
    hasActive = ->
      if App.hmanager.hasActive()
        return App.hmanager.enableDrag()
      false
    
    height = ->
      App.hmanager.currentDim
      if hasActive() then parseInt(App.hmanager.currentDim)+'px' else '18px'
    
    @views.animate
      height: height()
      400
      ->
        $(@).toggleClass('open')
  
  openPanel: (controller) ->
    return if @views.hasClass('open')
    App[controller].deactivate()
    ui = App.hmanager.externalUI(App[controller])
    console.log ui.click()
#    target.click()
    
  closePanel: (controller, target) ->
    App[controller].activate()
    target.click()
  
  quickUpload: (active) ->
    App.uploader.fileupload 'option'
      autoUpload: active
    
  isQuickUpload: ->
    @btnQuickUpload.find('i').hasClass('icon-ok')
    
  slideshowable: ->
    $('[rel="gallery"]', @current.el).length
    #(Gallery.selectionList().length isnt 1) or !(Album.record and Album.record.contains())
    
  play: (e) ->
#    return if @slideshowMode is App.SILENTMODE
    
    elFromSelection = =>
      list = Album.selectionList()
      if list.length
        id = list[0] 
        item = Photo.find(id) if Photo.exists(id)
        root = @current.el.children('.items')
        el = root.children().forItem(item)
        return $('[rel="gallery"]', el)
    
    elFromCanvas = =>
      firstEl = $('[rel="gallery"]', @current.el).first()
    
    if @slideshowable()
      el = elFromSelection() or elFromCanvas()
      # prevent ghosted backdrops
      return if $('.modal-backdrop').length
      if @slideshowAutoStart || e?.type
        el.click()
    else
      # do nothing unless there is a seleted album
      return unless Gallery.selectionList().length
      Spine.trigger('show:photos')
      Spine.trigger('change:selectedAlbum', Album.record, true)
        
  pause: (e) ->
    
    
    modal = $('#modal-gallery').data('modal')
    isShown = modal?.isShown
    
    unless isShown
      @play(e)
    else
      $('#modal-gallery').data('modal').toggleSlideShow()
      
    false
  
  slideshowPlay: (e) ->
    @play(e)
        
  deselect: (e) =>
    item = @el.data().current
    className = @el.data().className
    switch className
      when 'Photo'
        -> # nothing to do here
      when 'Album'
        Spine.Model['Album'].emptySelection()
        Spine.trigger('photo:activate')
      when 'Gallery'
        Spine.Model['Gallery'].emptySelection()
        Spine.trigger('album:activate')
      when 'Slideshow'
        ->
      else
        ->
#        Spine.trigger('gallery:activate', false)
        
    @changeToolbarOne()
    @current.items.deselect()
    
  selectAll: (e) ->
    root = @current.el.children('.items')
    root.children().each (index, el) ->
      item = $(@).item()
      item.addRemoveSelection(true)
    @current.list?.select()
    @changeToolbarOne()
    
  uploadProgress: (e, coll) ->
#    console.log coll
    
  uploadDone: (e, coll) ->
#    console.log coll
    
  sliderInValue: (val) ->
    val = val or @sOutValue
    @sInValue=(val/2)-20
    
  sliderOutValue: (value) ->
    val = value || @slider.slider('value')
    @sOutValue=(val+20)*2
    
  initSlider: =>
    inValue = @sliderInValue()
    @refreshElements()
    @slider.slider
      orientation: 'horizonatal'
      value: inValue
      slide: (e, ui) =>
        @sliderSlide ui.value
    
  showSlider: ->
    @initSlider()
    @sliderOutValue()
    @sliderInValue()
      
  sliderStart: =>
    Spine.trigger('slider:start')
#    @photosView.list.sliderStart()
    
  sliderSlide: (val) =>
    newVal = @sliderOutValue val  
    Spine.trigger('slider:change', newVal)
    newVal
    
  sliderStop: =>
    # rerender thumbnails on the server to its final size
#    @slider.toggle()

  showOverview: (e) ->
    Spine.trigger('show:overview')

  showSlideshow: (e) ->
    @slideshowMode = App.SILENTMODE
#    @changeToolbarOne ['Chromeless']
#    @changeToolbarTwo @slideshowView.toolbar #['Slider', 'Back', 'Play', App.showView.initSlider]
    App.sidebar.toggleDraghandle(close:true)
#    @toolbarOne.clear()
#    @toolbarOne.lock()
    
    Spine.trigger('show:slideshow')
    
  showPrevious: ->
    App.sidebar.toggleDraghandle()
    @previous.show()
  
  showModal: ->
    @modalView.render
      header: 'Neuer Header'
      body  : 'Neuer Body'
      footer: 'Neuer Footer'
    @modalView.show()
    
  showAllPhotos: ->
    Spine.trigger('show:photos')
    Gallery.emptySelection()
    Album.emptySelection()
    Album.current()
    
  showAllAlbums: ->
    Spine.trigger('show:albums')
    Gallery.current()