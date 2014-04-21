Spine           = require("spine")
$               = Spine.$
Model           = Spine.Model
Controller      = Spine.Controller
Gallery         = require('models/gallery')
Album           = require('models/album')
Photo           = require('models/photo')
AlbumsPhoto     = require('models/albums_photo')
GalleriesAlbum  = require('models/galleries_album')
ToolbarView     = require("controllers/toolbar_view")
WaitView        = require("controllers/wait_view")
AlbumsView      = require("controllers/albums_view")
PhotoHeader     = require('controllers/photo_header')
PhotosHeader    = require('controllers/photos_header')
PhotoView       = require('controllers/photo_view')
PhotosView      = require('controllers/photos_view')
AlbumsHeader    = require('controllers/albums_header')
AlbumsAddView   = require('controllers/albums_add_view')
PhotosAddView   = require('controllers/photos_add_view')
GalleriesView   = require('controllers/galleries_view')
GalleriesHeader = require('controllers/galleries_header')
SlideshowView   = require('controllers/slideshow_view')
SlideshowHeader = require('controllers/slideshow_header')
OverviewHeader  = require('controllers/overview_header')
OverviewView    = require('controllers/overview_view')
Extender        = require('plugins/controller_extender')
Drag            = require("plugins/drag")
require('spine/lib/manager')

class ShowView extends Spine.Controller

  @extend Extender
  @extend Drag

  elements:
    '#views .views'           : 'views'
    '.contents'               : 'contents'
    '.items'                  : 'lists'
    '.header .galleries'      : 'galleriesHeaderEl'
    '.header .albums'         : 'albumsHeaderEl'
    '.header .photos'         : 'photosHeaderEl'
    '.header .photo'          : 'photoHeaderEl'
    '.header .overview'       : 'overviewHeaderEl'
    '.header .slideshow'      : 'slideshowHeaderEl'
    '.opt-Overview'            : 'btnOverview'
    '.opt-EditGallery'         : 'btnEditGallery'
    '.opt-Gallery .ui-icon'    : 'btnGallery'
    '.opt-QuickUpload'         : 'btnQuickUpload'
    '.opt-Previous'            : 'btnPrevious'
    '.opt-Sidebar'             : 'btnSidebar'
    '.opt-FullScreen'          : 'btnFullScreen'
    '.opt-SlideshowPlay'       : 'btnSlideshowPlay'
    '.toolbarOne'             : 'toolbarOneEl'
    '.toolbarTwo'             : 'toolbarTwoEl'
    '.props'                  : 'propsEl'
    '.content.galleries'      : 'galleriesEl'
    '.content.albums'         : 'albumsEl'
    '.content.photos'         : 'photosEl'
    '.content.photo'          : 'photoEl'
    '.content.wait'           : 'waitEl'
    '#slideshow'              : 'slideshowEl'
    '#modal-action'           : 'modalActionEl'
    '#modal-addAlbum'         : 'modalAddAlbumEl'
    '#modal-addPhoto'         : 'modalAddPhotoEl'
    '.overview'               : 'overviewEl'
    
    '.slider'                 : 'slider'
    '.opt-Album'               : 'btnAlbum'
    '.opt-Gallery'             : 'btnGallery'
    '.opt-Photo'               : 'btnPhoto'
    '.opt-Upload'              : 'btnUpload'
    
  events:
    'click .opt-QuickUpload:not(.disabled)'           : 'toggleQuickUpload'
    'click .opt-Overview:not(.disabled)'              : 'showOverview'
    'click .opt-Previous:not(.disabled)'              : 'back'
    'click .opt-ShowModal:not(.disabled)'             : 'showModal'
    'click .opt-Sidebar:not(.disabled)'               : 'toggleSidebar'
    'click .opt-FullScreen:not(.disabled)'            : 'toggleFullScreen'
    'click .opt-CreateGallery:not(.disabled)'         : 'createGallery'
    'click .opt-CreateAlbum:not(.disabled)'           : 'createAlbum'
    'click .opt-CopyPhotosToAlbum:not(.disabled)'     : 'copyPhotosToAlbum'
    'click .opt-CopyAlbums'                           : 'copyAlbums'
    'click .opt-EmptyAlbum'                           : 'emptyAlbum'
    'click .opt-CreatePhoto:not(.disabled)'           : 'createPhoto'
    'click .opt-DestroyGallery:not(.disabled)'        : 'destroyGallery'
    'click .opt-DestroyAlbum:not(.disabled)'          : 'destroyAlbum'
    'click .opt-DestroyPhoto:not(.disabled)'          : 'destroyPhoto'
    'click .opt-EditGallery:not(.disabled)'           : 'editGallery' # for the large edit view
    'click .opt-Gallery:not(.disabled)'               : 'toggleGalleryShow'
    'click .opt-Album:not(.disabled)'                 : 'toggleAlbumShow'
    'click .opt-Photo:not(.disabled)'                 : 'togglePhotoShow'
    'click .opt-Upload:not(.disabled)'                : 'toggleUploadShow'
    'click .opt-ShowAllAlbums:not(.disabled)'         : 'showAlbumMasters'
    'click .opt-AddAlbums:not(.disabled)'             : 'showAlbumMastersAdd'
    'click .opt-ShowAllPhotos:not(.disabled)'         : 'showPhotoMasters'
    'click .opt-AddPhotos:not(.disabled)'             : 'showPhotoMastersAdd'
    'click .opt-ActionCancel:not(.disabled)'          : 'cancelAdd'
    'click .opt-SlideshowAutoStart:not(.disabled)'    : 'toggleSlideshowAutoStart'
    'click .opt-SlideshowPreview:not(.disabled)'      : 'slideshowPreview'
    'click .opt-SlideshowPhoto:not(.disabled)'        : 'slideshowPhoto'
    'click .opt-SlideshowPlay:not(.disabled)'         : 'slideshowPlay'
    'click .opt-ShowPhotoSelection:not(.disabled)'    : 'showPhotoSelection'
    'click .opt-ShowAlbumSelection:not(.disabled)'    : 'showAlbumSelection'
    'click .opt-SelectAll:not(.disabled)'             : 'selectAll'
    'click .opt-SelectInv:not(.disabled)'             : 'selectInv'
    'click .opt-CloseDraghandle'                      : 'toggleDraghandle'
    'click .deselector'                               : 'deselect'
    'dblclick .draghandle'                            : 'toggleDraghandle'
    
    # you must define dragover yourself in subview !!!!!!important
    'dragstart .item'                                 : 'dragstart'
    'dragenter .view'                                 : 'dragenter'
    'dragend'                                         : 'dragend'
    'drop'                                            : 'drop'

    'keyup'                                           : 'keyup'
    
  constructor: ->
    super
    @silent = true
    @toolbarOne = new ToolbarView
      el: @toolbarOneEl
    @toolbarTwo = new ToolbarView
      el: @toolbarTwoEl
    @galleriesHeader = new GalleriesHeader
      el: @galleriesHeaderEl
    @albumsHeader = new AlbumsHeader
      el: @albumsHeaderEl
      parent: @
    @photosHeader = new PhotosHeader
      el: @photosHeaderEl
      parent: @
    @photoHeader = new PhotoHeader
      el: @photoHeaderEl
      parent: @
    @slideshowHeader = new SlideshowHeader
      header: @slideshowHeaderEl
    @galleriesView = new GalleriesView
      el: @galleriesEl
      className: 'items'
      assocControl: 'opt-Gallery'
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
      photosView: @photosView
      parent: @
      parentModel: Photo
    @slideshowView = new SlideshowView
      el: @slideshowEl
      className: 'items'
      header: @slideshowHeader
      parent: @
      parentModel: 'Photo'
      subview: true
    @albumAddView = new AlbumsAddView
      el: @modalAddAlbumEl
      parent: @albumsView
    @photoAddView = new PhotosAddView
      el: @modalAddPhotoEl
      parent: @photosView
    @waitView = new WaitView
      el: @waitEl
      parent: @
    
    @bind('canvas', @proxy @canvas)
    @bind('change:toolbarOne', @proxy @changeToolbarOne)
    @bind('change:toolbarTwo', @proxy @changeToolbarTwo)
    @bind('toggle:view', @proxy @toggleView)
    
    @bind('drag:start', @proxy @dragStart)
    @bind('drag:enter', @proxy @dragEnter)
    @bind('drag:end', @proxy @dragEnd)
    @bind('drag:drop', @proxy @dropComplete)
    
    @toolbarOne.bind('refresh', @proxy @refreshToolbar)
    
    Gallery.bind('change', @proxy @changeToolbarOne)
    Gallery.bind('change:selection', @proxy @refreshToolbars)
    Album.bind('change:selection', @proxy @refreshToolbars)
    AlbumsPhoto.bind('create destroy', @proxy @refreshToolbars)
    Album.bind('change', @proxy @changeToolbarOne)
    Photo.bind('change', @proxy @changeToolbarOne)
    Photo.bind('refresh', @proxy @refreshToolbars)
    Spine.bind('change:selectedAlbum', @proxy @refreshToolbars)
    Spine.bind('albums:copy', @proxy @copyAlbums)
    Spine.bind('photos:copy', @proxy @copyPhotos)
    
    @sOutValue = 160 # initial thumb size (slider setting)
    @sliderRatio = 50
    @thumbSize = 240 # size thumbs are created serverside (should be as large as slider max for best quality)
    @current = @galleriesView
    
    @canvasManager = new Spine.Manager(@galleriesView, @albumsView, @photosView, @photoView, @slideshowView, @waitView)
    @headerManager = new Spine.Manager(@galleriesHeader, @albumsHeader, @photosHeader, @photoHeader, @slideshowHeader)
    
    @canvasManager.bind('change', @proxy @changeCanvas)
    @headerManager.bind('change', @proxy @changeHeader)
    @trigger('change:toolbarOne')
    
  activated: ->
    @el.focus()
    
  changeCanvas: (controller) ->
    controller.activated()
    
    $('.items', @el).removeClass('in')
    t = switch controller.type
      when "Gallery"
        true
      when "Album"
        unless Gallery.record
          true
        else false
      when "Photo"
        unless Album.record
          true
        else false
      else false
        
        
    _1 = =>
      if t
        @contents.addClass('all')
      else
        @contents.removeClass('all')
      _2()
        
    _2 = =>
      viewport = controller.viewport or controller.el
      viewport.addClass('in')
      
      
    window.setTimeout( =>
      _1()
    , 200)
    
  changeHeader: (controller) ->
    controller.activated()
    
  canvas: (controller) ->
    console.log 'ShowView::canvas'
    @previous = @current unless @current.subview
    @current = @controller = controller
    @currentHeader = controller.header
    @prevLocation = location.hash
    @el.data('current',
      model: controller.el.data('current').model
      models: controller.el.data('current').models
    )
    controller.trigger 'active'
    controller.header.trigger 'active'
    controller
    
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
    Spine.trigger('create:album', gallery, photos: photos)
    
    if gallery?.id
      @navigate '/gallery', gallery.id#, Album.last().id
    else
      @showAlbumMasters()
      
  copyAlbums: (albums, gallery) ->
    hash = location.hash
    Album.trigger('create:join', albums, gallery, -> @navigate hash)
      
  copyPhotos: (photos, album) ->
    hash = location.hash
    options =
      photos: photos
      album: album
    Photo.trigger('create:join', options, -> @navigate hash)
      
  copyPhotosToAlbum: ->
    @photosToAlbum Album.selectionList()[..]
      
  movePhotosToAlbum: ->
    @photosToAlbum Album.selectionList(), Album.record
  
  photosToAlbum: (photos, album) ->
    target = Gallery.record
    Spine.trigger('create:album', target,
      photos: photos
      album:album
      deleteFromOrigin: false
      relocate: true
    )
    
  createAlbumCopy: (albums=Gallery.selectionList(), target=Gallery.record) ->
    console.log 'ShowView::createAlbumCopy'
    for id in albums
      if Album.exists(id)
        photos = Album.photos(id).toID()
        
        Spine.trigger('create:album', target
          photos: photos
        )
        
    if target
      target.updateSelection albums
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
  
  emptyAlbum: (e) ->
    albums = Gallery.selectionList()
    for aid in albums
      if album = Album.exists aid
        aps = AlbumsPhoto.filter(album.id, key: 'album_id')
        for ap in aps
          ap.destroy()
    
  editGallery: (e) ->
    Spine.trigger('edit:gallery')

  editAlbum: (e) ->
    Spine.trigger('edit:album')

  destroySelected: (e) ->
    models = @controller.el.data('current').models
    @['destroy'+models.className]()

  destroyGallery: (e) ->
    Spine.trigger('destroy:gallery')
#    @deselect()
  
  destroyAlbum: (e) ->
    Spine.trigger('destroy:album')
#    @deselect()

  destroyPhoto: (e) ->
    Spine.trigger('destroy:photo')
#    @deselect()

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
        '20px'
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
    return unless $(e.target).hasClass('deselector')
    data = @el.data('current')
    model = data.model
    models = data.models
    model.updateSelection()
    models.current()
    try
      @current.itemsEl.deselect()
    catch e
    
  selectAll: (e) ->
    try
      list = @select_()
      @current.select(list, true)
    catch e
    
  selectInv: (e)->
    try
      list = @select_()
      @current.select(list)
    catch e
    
  select_: ->
    list = []
    root = @current.itemsEl
    items = $('.item', root)
    unless root and items.length
      return list
    items.each () ->
      list.unshift @.id
    list
    
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
    
  sliderSlide: (val) =>
    newVal = @sliderOutValue val  
    Spine.trigger('slider:change', newVal)
    newVal
    
  slideshowPlay: (e) =>
    @slideshowView.trigger('play')
    
  slideshowPreview: (e) ->
    @navigate '/slideshow/'
    
  slideshowPhoto: (e) ->
    if Photo.record
      @slideshowView.trigger('play', {}, [Photo.record])
    
  showOverview: (e) ->
    @navigate '/overview/'

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
    
  showAlbumMastersAdd: (e) ->
    e.preventDefault()
    e.stopPropagation()
    Spine.trigger('albums:add')
    
  showPhotoMastersAdd: (e) ->
    e.preventDefault()
    e.stopPropagation()
    Spine.trigger('photos:add')
    
  cancelAdd: (e) ->
    @back()
    App.sidebar.filter()
    @el.removeClass('add')
    e.preventDefault()
    
  showPhotoSelection: ->
    if Gallery.record
      @navigate '/gallery', Gallery.record.id, Gallery.selectionList()[0] or ''
    else
      @navigate '/gallery','', Gallery.selectionList()[0] or ''
    
  showAlbumSelection: ->
    @navigate '/gallery', Gallery.record.id or ''

  back: ->
    if localStorage.previousHash
      location.hash = localStorage.previousHash
      delete localStorage.previousHash
    else
      @navigate '/galleries/'
      
  keyup: (e) ->
    e.preventDefault()
    code = e.charCode or e.keyCode
    
    el=$(document.activeElement)
    isFormfield = $().isFormElement(el)
    
#    console.log 'ShowView:keyupCode: ' + code
    
    switch code
      when 8 #Backspace
        unless isFormfield
          @destroySelected()
      when 32 #Space
        unless isFormfield
          @slideshowView.play()
      when 27 #Esc
        @slideshowView.onclosedGallery()
      when 65 #CTRL A
        unless isFormfield
          if e.metaKey or e.ctrlKey
            @selectAll(e)
      when 73 #CTRL I
        unless isFormfield
          if e.metaKey or e.ctrlKey
            @selectInv(e)

module?.exports = ShowView