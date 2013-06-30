Spine             = require("spine")
$                 = Spine.$
Drag              = require("plugins/drag")
User              = require('models/user')
Config            = require('models/config')
Album             = require('models/album')
Gallery           = require('models/gallery')
Toolbar           = require("models/toolbar")
SpineError        = require("models/spine_error")
MainView          = require("controllers/main_view")
LoginView         = require("controllers/login")
LoaderView        = require("controllers/loader")
Sidebar           = require("controllers/sidebar")
ShowView          = require("controllers/show_view")
ModalSimpleView   = require("controllers/modal_simple_view")
Modal2ButtonView  = require("controllers/modal_2_button_view")
ToolbarView       = require("controllers/toolbar_view")
LoginView         = require("controllers/login_view")
OverviewView      = require("controllers/overview_view")
SidebarFlickr     = require("controllers/sidebar_flickr")
AlbumEditView     = require("controllers/album_edit_view")
PhotoEditView     = require("controllers/photo_edit_view")
UploadEditView    = require("controllers/upload_edit_view")
GalleryEditView   = require("controllers/gallery_edit_view")
GalleryEditorView = require("controllers/gallery_editor_view")

require('spine/lib/route')
require('plugins/manager')

class Main extends Spine.Controller
  
  @extend Drag
  
  # Note:
  # this is how to change a toolbar:
  # App.showView.trigger('change:toolbar', 'Album')
  
  elements:
    '#fileupload'         : 'uploader'
    '#flickr'             : 'flickrEl'
    '#main'               : 'mainEl'
    '#sidebar'            : 'sidebarEl'
    '.show'               : 'showEl'
    '.overview'           : 'overviewEl'
    '#content .edit'      : 'galleryEditEl'
    '#ga'                 : 'galleryEl'
    '#al'                 : 'albumEl'
    '#ph'                 : 'photoEl'
    '#fu'                 : 'uploadEl'
    '#loader'             : 'loaderEl'
    '#login'              : 'loginEl'
    '#modal-gallery'      : 'slideshowEl'
    '#modal-view'         : 'modalEl'
    '.vdraggable'         : 'vDrag'
    '.hdraggable'         : 'hDrag'
    '.show .content'      : 'content'
    '.status-symbol img'  : 'statusIcon'
    '.status-text'        : 'statusText'
    '.status-symbol'      : 'statusSymbol'
    
  events:
    'keypress'            : 'keys'
    'dragenter'           : 'dragenter'
    'drop'                : 'drop'

  constructor: ->
    super
    
#    @ready = false
#    @ALBUM_SINGLE_MOVE = @constructor.createImage('/img/dragndrop/album_single_move.png')
#    @ALBUM_SINGLE_COPY = @constructor.createImage('/img/dragndrop/album_single_copy.png')
#    @ALBUM_DOUBLE_MOVE = @constructor.createImage('/img/dragndrop/album_double_move.png')
#    @ALBUM_DOUBLE_COPY = @constructor.createImage('/img/dragndrop/album_double_copy.png')
#
#    @PHOTO_SINGLE_MOVE = @constructor.createImage
    
    $(window).bind('hashchange', @proxy @storeHash)
    User.bind('pinger', @proxy @validate)
    $('#modal-gallery').bind('hidden', @proxy @hideSlideshow)
    
    @modalSimpleView = new ModalSimpleView
      el: @modalSimpleEl
      className: 'modal'
    @modal2ButtonView = new Modal2ButtonView
      el: @modalEl
      className: 'modal'
    @galleryEditView = new GalleryEditorView
      el: @galleryEditEl
    @gallery = new GalleryEditView
      el: @galleryEl
      externalUI: '.optGallery'
    @album = new AlbumEditView
      el: @albumEl
      externalUI: '.optAlbum'
    @photo = new PhotoEditView
      el: @photoEl
      externalUI: '.optPhoto'
    @upload = new UploadEditView
      el: @uploadEl
      externalUI: '.optUpload'
    @showView = new ShowView
      el: @showEl
      activeControl: 'btnGallery'
      modalView: @modalSimpleView
      uploader: @upload
    @overviewView = new OverviewView
      el: @overviewEl
    @sidebar = new Sidebar
      el: @sidebarEl
    @flickr = new SidebarFlickr
      el: @flickrEl
    @loginView = new LoginView
      el: @loginEl
    @mainView = new MainView
      el: @mainEl
    @loaderView = new LoaderView
      el: @loaderEl

    @vmanager = new Spine.Manager(@sidebar)
    @vmanager.initDrag @vDrag,
      initSize: => @sidebar.el.width()
      disabled: false
      axis: 'x'
      min: -> 8
      tol: -> 20
      max: => @el.width()/2
      goSleep: => @sidebar.inner.hide()
      awake: => @sidebar.inner.show()

    @hmanager = new Spine.Manager(@gallery, @album, @photo, @upload)
    @hmanager.external = @showView.toolbarOne
    @hmanager.initDrag @hDrag,
      initSize: => @el.height()/2
      disabled: false
      axis: 'y'
      min: -> 90
      max: => @el.height()/2
      goSleep: => #@showView.toggleDraghandle()
      awake: => #@showView.activeControl?.click()

    
    @appManager = new Spine.Manager(@mainView, @loaderView)
    @appManager.change @loaderView
    
    @contentManager = new Spine.Manager(@galleryEditView, @overviewView, @showView)
    @contentManager.change @showView

    @initializeFileupload()
    @slideshow = @initializeSlideshow()
    
    @routes
      '/gallery/:gid/:aid/:pid': (params) ->
        @contentManager.change(@showView)
        gallery = Gallery.exists(params.gid)
        album = Album.exists(params.aid)
        photo = Photo.exists(params.pid)
        Spine.trigger('gallery:activate', params.gid)
        Spine.trigger('show:photo', photo)
        Spine.trigger('album:activate', params.aid)
        Spine.trigger('chromeless', true) if params.fs is 'yes'
      '/gallery/:gid/:aid': (params) ->
        @contentManager.change(@showView)
        Spine.trigger('gallery:activate', params.gid)
        Spine.trigger('show:photos')
        Spine.trigger('album:activate', params.aid)
      '/gallery/:gid': (params) ->
        Album.current()
        @contentManager.change(@showView)
        Spine.trigger('gallery:activate', params.gid)
        Spine.trigger('show:albums')
        unless params.gid
          Spine.trigger('show:allAlbums')
      '/galleries/': ->
        Album.current()
        @contentManager.change(@showView)
        Spine.trigger('show:galleries')
      '/overview/': ->
        Spine.trigger('show:overview', true)
      '/slideshow/:id/:autostart': (params) ->
        @contentManager.change(@showView)
        Spine.trigger('show:slideshow', params.autostart)
        Spine.trigger('chromeless', true) if params.fs is 'yes'
      '/slideshow/': ->
        @contentManager.change(@showView)
        Spine.trigger('show:slideshow')
    
    @defaultSettings =
      welcomeScreen: false,
      test: true
    
    @loadToolbars()
  
  storeHash: ->
    localStorage.hash = location.hash
    
  fullscreen: ->
    Spine.trigger('chromeless', true)
    
  validate: (user, json) ->
    console.log 'Pinger done'
    valid = user.sessionid is json.sessionid
    valid = user.id is json.id and valid
    unless valid
      User.logout()
    else
      @delay @setupView, 1000
      
  drop: (e) ->
    console.log 'App::drop'
    
    # prevent ui drops
    unless e.originalEvent.dataTransfer.files.length
      e.stopPropagation()
      e.preventDefault()
      
    # clean up placeholders, jquery-sortable-plugin sometimes leaves alone
    $('.sortable-placeholder').detach()
      
  setupView: ->
    Spine.unbind('uri:alldone')
    @appManager.change @mainView
    @mainView.el.hide()
    @statusSymbol.fadeOut('slow', @proxy @finalizeView)
      
  finalizeView: ->
    @loginView.render User.first()
    @mainView.el.fadeIn(1500)
      
  initializeSlideshow: ->
    options =
      show: false
      canvas: true
      backdrop: true
      slideshow: 2000
      autostart: false
      toggleAutostart: ->
      
    $('#modal-gallery').modal(options).data('modal')
    
  hideSlideshow: ->
    @showView.showPrevious() if @showView.slideshowView.autoplay

  initializeFileupload: ->
    @uploader.fileupload
      autoUpload        : true
      singleFileUploads : true
      maxFileSize: 4000000 #5MB
      maxNumberOfFiles: 20
    
  loadToolbars: ->
    Toolbar.load()
    
  keys: (e) ->
    charCode = e.charCode
    keyCode = e.keyCode
    
    # CHARS
    switch charCode
      when 97
        #ctrl A -> select all / invert selection
        if e.metaKey or e.ctrlKey
          @showView.selectAll()
          e.preventDefault()
      when 32
        #spacebar -> play/stop slideshow
        @showView.slideshowView.toggle()
        e.preventDefault()
        
        
    # KEYS
    switch keyCode
      #tabKey toggles sidebar
      when 9
        @sidebar.toggleDraghandle()
        e.preventDefault()
      when 27
        @showView.btnPrevious.click()
        e.preventDefault()
      when 13
        e.preventDefault()
      else
        console.log keyCode
        
module?.exports = Main
