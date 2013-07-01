Spine           = require("spine")
$               = Spine.$
Model           = Spine.Model
Controller      = Spine.Controller
Manager         = require('spine/lib/manager')
Gallery         = require('models/gallery')
Album           = require('models/album')
Photo           = require('models/photo')
ToolbarView     = require("controllers/toolbar_view")
AlbumsView      = require("controllers/albums_view")
PhotoHeader     = require('controllers/photo_header')
PhotosHeader    = require('controllers/photos_header')
PhotoView       = require('controllers/photo_view')
PhotosView      = require('controllers/photos_view')
AlbumsHeader    = require('controllers/albums_header')
GalleriesView   = require('controllers/galleries_view')
GalleriesHeader = require('controllers/galleries_header')
SlideshowView   = require('controllers/slideshow_view')
Extender        = require('plugins/controller_extender')

class ShowView extends Spine.Controller

  @extend Extender

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
    '.optPrevious'            : 'btnPrevious'
    '.optSidebar'             : 'btnSidebar'
    '.optFullScreen'          : 'btnFullScreen'
    '.optSlideshowPlay'       : 'btnSlideshowPlay'
    '.toolbarOne'             : 'toolbarOneEl'
    '.toolbarTwo'             : 'toolbarTwoEl'
    '.props'                  : 'propsEl'
    '.galleries'              : 'galleriesEl'
    '.albums'                 : 'albumsEl'
    '.photos'                 : 'photosEl'
    '.photo'                  : 'photoEl'
    '.slideshow'              : 'slideshowEl'
    
    '.slider'                 : 'slider'
    '.optAlbum'               : 'btnAlbum'
    '.optGallery'             : 'btnGallery'
    '.optPhoto'               : 'btnPhoto'
    '.optUpload'              : 'btnUpload'
    
  events:
    'click .optQuickUpload:not(.disabled)'           : 'toggleQuickUpload'
    'click .optOverview:not(.disabled)'              : 'showOverview'
    'click .optPrevious:not(.disabled)'              : 'showPrevious'
    'click .optShowModal:not(.disabled)'             : 'showModal'
    'click .optSidebar:not(.disabled)'               : 'toggleSidebar'
    'click .optFullScreen:not(.disabled)'            : 'toggleFullScreen'
    'click .optCreateGallery:not(.disabled)'         : 'createGallery'
    'click .optCreateAlbum:not(.disabled)'           : 'createAlbum'
    'click .optCreateAlbumFromSel:not(.disabled)'    : 'createAlbumFromSel'
    'click .optCreateAlbumFromSelCut:not(.disabled)' : 'createAlbumFromSelCut'
    'click .optCreatePhoto:not(.disabled)'           : 'createPhoto'
    'click .optDestroyGallery:not(.disabled)'        : 'destroyGallery'
    'click .optDestroyAlbum:not(.disabled)'          : 'destroyAlbum'
    'click .optDestroyPhoto:not(.disabled)'          : 'destroyPhoto'
    'click .optEditGallery:not(.disabled)'           : 'editGallery' # for the large edit view
    'click .optGallery:not(.disabled)'               : 'toggleGalleryShow'
    'click .optAlbum:not(.disabled)'                 : 'toggleAlbumShow'
    'click .optPhoto:not(.disabled)'                 : 'togglePhotoShow'
    'click .optUpload:not(.disabled)'                : 'toggleUploadShow'
    'click .optShowAllAlbums:not(.disabled)'         : 'showAlbumMasters'
    'click .optShowAllPhotos:not(.disabled)'         : 'showPhotoMasters'
    'click .optSlideshowAutoStart:not(.disabled)'    : 'toggleSlideshowAutoStart'
    'click .optShowSlideshow:not(.disabled)'         : 'showSlideshow'
    'click .optSlideshowPlay:not(.disabled)'         : 'slideshowPlay'
    'click .optShowAlbumMasters:not(.disabled)'      : 'showAlbumMasters'
    'click .optShowPhotoMasters:not(.disabled)'      : 'showPhotoMasters'
    'click .optClose:not(.disabled)'                 : 'toggleDraghandle'
    'click .optSelectAll:not(.disabled)'             : 'selectAll'
    'dblclick .draghandle'                           : 'toggleDraghandle'
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
      parentModel: Gallery
      parent: @
    @photosView = new PhotosView
      el: @photosEl
      className: 'items'
      header: @photosHeader
      parentModel: Album
      parent: @
    @photoView = new PhotoView
      el: @photoEl
      className: 'items'
      header: @photoHeader
      parent: @
      parentModel: Photo
    @slideshowView = new SlideshowView
      el: @slideshowEl
      className: 'items'
      header: false
      parent: @
      parentModel: 'Photo'
      subview: true
      photos: @activePhotos
    
    @bind('canvas', @proxy @canvas)
    @bind('change:toolbarOne', @proxy @changeToolbarOne)
    @bind('change:toolbarTwo', @proxy @changeToolbarTwo)
    @bind('toggle:view', @proxy @toggleView)
#    @bind('show:previous', @proxy @showPrevious)
    @toolbarOne.bind('refresh', @proxy @refreshToolbar)
    
    Gallery.bind('change', @proxy @changeToolbarOne)
    Album.bind('change', @proxy @changeToolbarOne)
    Photo.bind('change', @proxy @changeToolbarOne)
    Photo.bind('refresh', @proxy @refreshToolbars)
    Spine.bind('change:selectedAlbum', @proxy @refreshToolbars)
    
#    Spine.bind('show:allPhotos', @proxy @showAllPhotos)
#    Spine.bind('show:allAlbums', @proxy @showAllAlbums)
    
    
    @sOutValue = 140 # size thumbs initially are shown (slider setting)
    @thumbSize = 240 # size thumbs are created serverside (should be as large as slider max for best quality)
    @current = @galleriesView
    
#    @edit = @editGallery
    
    @canvasManager = new Spine.Manager(@galleriesView, @albumsView, @photosView, @photoView, @slideshowView)
    @headerManager = new Spine.Manager(@galleriesHeader, @albumsHeader, @photosHeader, @photoHeader)
    
    # setup visibility of view stack
    @active()
    @galleriesView.active()
    
    # switch to assigned start view
    @canvasManager.change @galleriesView
    @headerManager.change @galleriesHeader
    @trigger('change:toolbarOne')
    
  previousLocation: ->
    console.log 'ShowView::previousLocation'
    if @prevLocation is location.hash
      return '/galleries/'
    else
      @prevLocation
    
  canvas: (controller) ->
    console.log 'ShowView::changeCanvas'
    @previous = @current unless @current.subview
    @current = controller
    @prevLocation = location.hash
    @el.data
      current: controller.el.data().current.record
      className: controller.el.data().current.className
    
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
  
  createAlbum: ->
    Spine.trigger('create:album')
    
    if Gallery.record
      @navigate '/gallery', Gallery.record.id, Album.last()
    else
      @showAlbumMasters()
  
  createAlbumFromSel: ->
    list = Album.selectionList()
    photos = []
    Photo.each (record) =>
      photos.push record unless list.indexOf(record.id) is -1
    Spine.trigger('create:album', photos)
    
    if Gallery.record
      @navigate '/gallery', Gallery.record.id, Album.last()
    else
      @showAlbumMasters()
  
  createAlbumFromSelCut: ->
    list = Album.selectionList()
    photos = []
    Photo.each (record) =>
      photos.push record unless list.indexOf(record.id) is -1
    Spine.trigger('create:album', photos, origin:Album.record)
    
    if Gallery.record
      @navigate '/gallery', Gallery.record.id, Album.last()
    else
      @showAlbumMasters()
  
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
    @refreshToolbars()

  toggleAlbumShow: (e) ->
    @trigger('toggle:view', App.album, e.target)
    @refreshToolbars()

  toggleAlbum: (e) ->
    @changeToolbarOne ['Album']
    @refreshToolbars()
    
  togglePhotoShow: (e) ->
    @trigger('toggle:view', App.photo, e.target)
    @refreshToolbars()
    
  togglePhoto: (e) ->
    @changeToolbarOne ['Photos', 'Slider']#, App.showView.initSlider
    @refreshToolbars()

  toggleUploadShow: (e) ->
    @trigger('toggle:view', App.upload, e.target)
    e.preventDefault()
    @refreshToolbars()
    
  toggleUpload: (e) ->
    @changeToolbarOne ['Upload']
    @refreshToolbars()

  toggleSidebar: () ->
    App.sidebar.toggleDraghandle()
    
    
  toggleFullScreen: () ->
    App.trigger('chromeless')
    @refreshToolbars()
    
  toggleFullScreen: () ->
    @slideshowView.toggleFullScreen()
    @refreshToolbars()
    
  toggleSlideshow: ->
    active = @btnSlideshow.toggleClass('active').hasClass('active')
    @slideshowView.slideshowMode(active)
    @refreshToolbars()

  toggleSlideshowAutoStart: ->
    res = App.slideshow.options.toggleAutostart()
    @refreshToolbars()
    res
    
  isAutoplay: ->
    @slideshowView.autoplay
  
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
    # toggle is disabled to unable upload-ui functionality
#    active = @btnQuickUpload.find('i').toggleClass('icon-ok icon-').hasClass('icon-ok')
    active = true
    @quickUpload active
    active
  
  quickUpload: (active) ->
    options = $('#fileupload').data('fileupload').options
#    options = App.uploader.data().fileupload.options
    options.autoUpload = active
    
  isQuickUpload: ->
    true #$('#fileupload').data('fileupload').options.autoUpload
    
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
    ui.click()
    
  closePanel: (controller, target) ->
    App[controller].activate()
    target.click()
    
  deselect: (e) =>
    item = @el.data().current
    className = @el.data().className
    switch className
      when 'Album'
        Album.emptySelection()
        Spine.trigger('photo:activate')
      when 'Gallery'
        Gallery.emptySelection()
        Spine.trigger('album:activate')
      when 'Slideshow'
        ->
      else
        Gallery.current()
        Spine.trigger('gallery:exposeSelection')
        
    @changeToolbarOne()
    @current.items.deselect()
    
  selectAll: (e) ->
    root = @current.el.children('.items')
    root.children().each (index, el) ->
      item = $(@).item()
      item?.addRemoveSelection()
    @current.list?.select()
    @changeToolbarOne()
    
  uploadProgress: (e, coll) ->
    
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

  toggleShowAllPhotos: (e) ->
    @allPhotos = !@allPhotos
#    Album.current() if @allAlbums
    if @allPhotos
      @navigate '/photos/'
    else
      @navigate '/gallery', (Gallery.record?.id or '') + (Album.record?.id or '')
#    @photosView.items.toggleClass('all', @allPhotos)
    @refreshToolbars()
    @allPhotos
    
  toggleShowAllAlbums: (e) ->
    @allAlbums = !@allAlbums
    if @allAlbums
      Gallery.current() if @allAlbums
      @navigate '/albums/'
    else
      @navigate '/gallery', Gallery.record?.id or ''
    @refreshToolbars()
    @allAlbums
    
  slideshowPlay: (e) =>
    @navigate '/slideshow', (Math.random() * 16 | 0), 1
    
  activePhotos: ->
    phos = []
    albs =[]
    albs.push itm for itm in Gallery.selectionList()
    for alb in albs
      if album = Album.exists(alb)
        photos = album.photos() or []
        phos.push pho for pho in photos
    phos
    
  showOverview: (e) ->
    @navigate '/overview/'

  showSlideshow: (e) ->
    @slideshowMode = App.SILENTMODE
    @navigate '/slideshow/'
    
  showPrevious: ->
    @navigate @previousLocation()
  
  showModal: (options) ->
    opts =
      header: 'Neuer Header'
      body  : 'Neuer Body'
      footer: 'Neuer Footer'
    opts = $.extend({}, opts, options)
    @modalView.show(opts)
    
  showPhotosTrash: ->
    Photo.inactive()
    
  showAlbumsTrash: ->
    Album.inactive()

  showAlbumMasters: ->
    @navigate '/gallery/'
    
  showPhotoMasters: ->
    Gallery.emptySelection()
    @navigate '/gallery//'

module?.exports = ShowView