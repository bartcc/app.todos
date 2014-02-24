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
ActionWindow    = require("controllers/action_window")
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
    '#slideshow'              : 'slideshowEl'
    '#modal-action'           : 'modalActionEl'
    
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
    'click .optCreatePhotoFromSel:not(.disabled)'    : 'createPhotoFromSel'
    'click .optCreatePhotoFromSelCut:not(.disabled)' : 'createPhotoFromSelCut'
    'click .optCreateAlbumFromSel:not(.disabled)'    : 'createAlbumFromSel'
    'click .optCopyAlbums'                           : 'copyAlbums'
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
    'click .optOpenSlideshow:not(.disabled)'         : 'slideshowOpen'
    'click .optShowAlbumMasters:not(.disabled)'      : 'showAlbumMasters'
    'click .optShowPhotoMasters:not(.disabled)'      : 'showPhotoMasters'
    'click .optShowPhotoSelection:not(.disabled)'    : 'showPhotoSelection'
    'click .optShowAlbumSelection:not(.disabled)'    : 'showAlbumSelection'
    'click .optClose:not(.disabled)'                 : 'toggleDraghandle'
    'click .optSelectAll:not(.disabled)'             : 'selectAll'
    'dblclick .draghandle'                           : 'toggleDraghandle'
    'click .draghandle.optClose'                     : 'toggleDraghandle'
    'click .items'                                   : 'deselect'
    'slidestop .slider'                              : 'sliderStop'
    'slidestart .slider'                             : 'sliderStart'

  constructor: ->
    super
    @silent = true
    @actionWindow = new ActionWindow
      el: @modalActionEl
    @toolbarOne = new ToolbarView
      el: @toolbarOneEl
    @toolbarTwo = new ToolbarView
      el: @toolbarTwoEl
    @photoHeader = new PhotoHeader
      el: @photoHeaderEl
      parent: @
    @photosHeader = new PhotosHeader
      el: @photosHeaderEl
      parent: @
    @albumsHeader = new AlbumsHeader
      el: @albumsHeaderEl
      parent: @
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
      photos: Gallery.activePhotos
    
    @bind('canvas', @proxy @canvas)
    @bind('change:toolbarOne', @proxy @changeToolbarOne)
    @bind('change:toolbarTwo', @proxy @changeToolbarTwo)
    @bind('toggle:view', @proxy @toggleView)
    @toolbarOne.bind('refresh', @proxy @refreshToolbar)
    
    Gallery.bind('change', @proxy @changeToolbarOne)
    Album.bind('change', @proxy @changeToolbarOne)
    Photo.bind('change', @proxy @changeToolbarOne)
    Photo.bind('refresh', @proxy @refreshToolbars)
    Spine.bind('change:selectedAlbum', @proxy @refreshToolbars)
    Spine.bind('albums:copy', @proxy @copyAlbums)
    Spine.bind('photos:copy', @proxy @copyPhotos)
    
    @sOutValue = 160 # size thumbs initially are shown (slider setting)
    @sliderRatio = 50
    @thumbSize = 240 # size thumbs are created serverside (should be as large as slider max for best quality)
    @current = @galleriesView
    
    @canvasManager = new Spine.Manager(@galleriesView, @albumsView, @photosView, @photoView, @slideshowView)
    @headerManager = new Spine.Manager(@galleriesHeader, @albumsHeader, @photosHeader, @photoHeader)
    
    # setup visibility of view stack
    @active()
    @galleriesView.active()
    
    # switch to assigned start view
    @canvasManager.change @galleriesView
    @headerManager.change @galleriesHeader
    @trigger('change:toolbarOne')
    
  previousLocation: (sameAllowed) ->
    console.log 'ShowView::previousLocation'
#    return @prevLocation
    return @prevLocation
    if @prevLocation is location.hash
      console.log location.hash
      return '/galleries/'
    else
      @prevLocation
    
  canvas: (controller) ->
    console.log 'ShowView::canvas'
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
    
  renderViewControl: (controller) ->
    App.hmanager.change(controller)
  
  createGallery: (e) ->
    Spine.trigger('create:gallery')
    e.preventDefault()
  
  createPhoto: (e) ->
    Spine.trigger('create:photo')
    e.preventDefault()
  
  createAlbum: ->
    Spine.trigger('create:album')
    
    if Gallery.record
      @navigate '/gallery', Gallery.record.id, Album.last()
    else
      @showAlbumMasters()
  
  createPhotoFromSel: (e) ->
    @copyPhotosToAlbum()
    e.preventDefault()
    
  createPhotoFromSelCut: (e) ->
    @movePhotosToAlbum()
    e.preventDefault()
  
  createAlbumFromSel: (e) ->
    @copyPhotosToNewAlbum()
    e.preventDefault()
    
  createAlbumFromSelCut: (e) ->
    @createAlbumMove()
    e.preventDefault()
  
  copyPhotosToNewAlbum: (photos, gallery=Gallery.record) ->
    return
    Spine.trigger('create:album', gallery, photos: photos)
    
    if gallery?.id
      @navigate '/gallery', gallery.id#, Album.last().id
    else
      @showAlbumMasters()
      
  copyAlbums: (albums, gallery) ->
    console.log albums
    console.log gallery
    Album.trigger('create:join', albums, gallery)
    @navigate '/gallery', gallery.id
      
  copyPhotos: (photos, gallery, album) ->
    Photo.trigger('create:join', photos, album)
    if gallery
      @navigate '/gallery', gallery.id, album.id
    else
      @navigate '/gallery', '', album.id
      
  copyPhotosToAlbum: ->
    @photosToAlbum Album.selectionList()
      
  movePhotosToAlbum: ->
    @photosToAlbum Album.selectionList(), Album.record
  
  photosToAlbum: (photos, album) ->
    target = Gallery.record
    Spine.trigger('create:album', target,
      photos: photos
      from:album
    )
    
    if target?.id
      @navigate '/gallery', target.id, Album.last().id
    else
      @navigate '/gallery/', Album.last().id
  
  createAlbumCopy: (albums=Gallery.selectionList(), target=Gallery.record) ->
    for id in albums
      if Album.exists(id)
        photos = Album.photos(id).toID()
        
        Spine.trigger('create:album', target
          photos: photos
        )
        
    if target
      Gallery.updateSelection albums, target.id
      @navigate '/gallery', target.id
    else
      @showAlbumMasters()
      
  createAlbumMove: (albums=Gallery.selectionList(), target=Gallery.record) ->
    for id in albums
      if Album.exists(id)
        photos = Album.photos(id).toID()
        Spine.trigger('create:album', target
          photos: photos
          from:Album.record
        )
    
    if Gallery.record
      @navigate '/gallery', target.id
    else
      @showAlbumMasters()
  
  editGallery: (e) ->
    Spine.trigger('edit:gallery')

  editAlbum: (e) ->
    Spine.trigger('edit:album')

  destroyGallery: (e) ->
    Spine.trigger('destroy:gallery')
    
    @navigate '/galleries/'
    
    @deselect()
  
  destroyAlbum: (e) ->
    Spine.trigger('destroy:album')
    @deselect()

  destroyPhoto: (e) ->
    Spine.trigger('destroy:photo')
    @deselect()

  toggleGalleryShow: (e) ->
    @trigger('toggle:view', App.gallery, e.target)
    e.preventDefault()
    
  toggleGallery: (e) ->
    @changeToolbarOne ['Gallery']
    @refreshToolbars()
    e.preventDefault()

  toggleAlbumShow: (e) ->
    @trigger('toggle:view', App.album, e.target)
    @refreshToolbars()
    e.preventDefault()

  toggleAlbum: (e) ->
    @changeToolbarOne ['Album']
    @refreshToolbars()
    e.preventDefault()
    
  togglePhotoShow: (e) ->
    @trigger('toggle:view', App.photo, e.target)
    @refreshToolbars()
    e.preventDefault()
    
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
    res = App.slideshow.data('bs.modal').options.toggleAutostart()
    @refreshToolbars()
    res
    
  isAutoplay: ->
    @slideshowView.autoplay
  
  toggleDraghandle: ->
    @animateView()
    
  toggleQuickUpload: ->
    @quickUpload !@isQuickUpload()
    @refreshToolbars()
  
  quickUpload: (active) ->
#    console.log $('#fileupload').data()
    $('#fileupload').data('blueimpFileupload').options['autoUpload'] = active
    
  isQuickUpload: ->
    $('#fileupload').data('blueimpFileupload').options['autoUpload']
    
  toggleView: (controller) ->
    if(controller.isActive())
      App.hmanager.trigger('change', false)
      @closeView()
    else
      App.hmanager.trigger('change', controller)
      @openView()
      @renderViewControl controller
    
#    @propsEl.find('.ui-icon').removeClass('ui-icon-carat-1-s')
#    $(control).toggleClass('ui-icon-carat-1-s', !controller.isActive())
    
  closeView: ->
    return unless App.hmanager.el.hasClass('open')
    @animateView()
  
  openView: ->
    return if App.hmanager.el.hasClass('open')
    @animateView()
    
  animateView: ->
    hasActive = ->
      if App.hmanager.hasActive()
        return App.hmanager.enableDrag()
      false
    
    isOpen = ->
      App.hmanager.el.hasClass('open')
    
    height = ->
      h = unless isOpen()
        parseInt(App.hmanager.currentDim)+'px'
      else
        '25px'
      h
    
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
      when 'Gallery'
        Album.trigger('activate', Gallery.emptySelection())
      when 'Album'
        Photo.trigger('activate', Album.emptySelection())
      when 'Poto'
        ->
      when 'Slideshow'
        ->
      else
        Gallery.trigger('activate')
        App.sidebar.list.closeAllSublists()
        
    @changeToolbarOne()
    @current.items.deselect()
    
  selectAll: (e) ->
    root = @current.el.children('.items')
    return unless root.children('.item').length
    list = []
    root.children().each (index, el) ->
      item = $(@).item()
      list.unshift item
#      item?.addRemoveSelection()
    @current.list?.select(list)
    @changeToolbarOne()
    
  uploadProgress: (e, coll) ->
    
  uploadDone: (e, coll) ->
#    console.log coll
    
  sliderInValue: (val) ->
    val = val or @sOutValue
    @sInValue=(val/2)-@sliderRatio
    
  sliderOutValue: (value) ->
    val = value || @slider.slider('value')
    @sOutValue=(val+@sliderRatio)*2
    
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

  slideshowOpen: (e) =>
    @navigate '/slideshow', (Math.random() * 16 | 0), 1
    
  slideshowPlay: (e) =>
    @slideshowView.trigger('play')
    
  showOverview: (e) ->
    @navigate '/overview/'

  showSlideshow: (e) ->
    @slideshowMode = App.SILENTMODE
    @navigate '/slideshow/'
    
  showPrevious: =>
    @navigate @previousLocation()
  
  showModal: (options) ->
    opts =
      header: 'New Header'
      body  : Gallery.all()
      footer: 'New Footer'
      info  : 'Test Info'
    opts = $.extend({}, opts, options)
    @actionWindow.show(opts)
    
  showPhotosTrash: ->
    Photo.inactive()
    
  showAlbumsTrash: ->
    Album.inactive()

  showAlbumMasters: ->
    @navigate '/gallery/'
    
  showPhotoMasters: ->
    @navigate '/gallery//'
    
  showPhotoSelection: ->
    if Gallery.record
      @navigate '/gallery', Gallery.record.id, Gallery.selectionList()[0] or ''
    else
      @navigate '/gallery','', Gallery.selectionList()[0] or ''
    
  showAlbumSelection: ->
    @navigate '/gallery', Gallery.record.id or ''

module?.exports = ShowView