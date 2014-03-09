Spine                   = require("spine")
$                       = Spine.$
Drag                    = require("plugins/drag")
User                    = require('models/user')
Config                  = require('models/config')
Album                   = require('models/album')
Gallery                 = require('models/gallery')
Toolbar                 = require("models/toolbar")
SpineError              = require("models/spine_error")
MainView                = require("controllers/main_view")
LoginView               = require("controllers/login")
LoaderView              = require("controllers/loader")
Sidebar                 = require("controllers/sidebar")
ShowView                = require("controllers/show_view")
ModalSimpleView         = require("controllers/modal_simple_view")
Modal2ButtonView        = require("controllers/modal_2_button_view")
ModalActionView         = require("controllers/modal_action_view")
ToolbarView             = require("controllers/toolbar_view")
LoginView               = require("controllers/login_view")
SidebarFlickr           = require("controllers/sidebar_flickr")
AlbumEditView           = require("controllers/album_edit_view")
PhotoEditView           = require("controllers/photo_edit_view")
UploadEditView          = require("controllers/upload_edit_view")
GalleryEditView         = require("controllers/gallery_edit_view")
OverviewView            = require('controllers/overview_view')
MissingView             = require("controllers/missing_view")
FlickrView              = require("controllers/flickr_view")
Extender                = require('plugins/controller_extender')

require("plugins/manager")
require('spine/lib/route')
require('spine/lib/manager')

class Main extends Spine.Controller
  
  @extend Drag
  @extend Extender
  
  # Note:
  # this is how to change a toolbar:
  # App.showView.trigger('change:toolbar', 'Album')
  
  elements:
    '#fileupload'         : 'uploader'
    '#flickr'             : 'flickrEl'
    '#main'               : 'mainEl'
    '#sidebar'            : 'sidebarEl'
    '#show'               : 'showEl'
    '#overview'           : 'overviewEl'
    '#sidebar .flickr'    : 'sidebarFlickrEl'
    '#missing'            : 'missingEl'
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
    '#show .content'      : 'content'
    '.status-symbol img'  : 'statusIcon'
    '.status-text'        : 'statusText'
    '.status-symbol'      : 'statusSymbol'
    
  events:
    'keyup'               : 'keyup'
    'keypress'            : 'keypress'
    'dragenter'           : 'dragenter'
    'drop'                : 'drop'

  constructor: ->
    super
    
#    @ready = false
    @ALBUM_SINGLE_MOVE = @createImage('/img/dragndrop/album_single_move.png')
    @ALBUM_SINGLE_COPY = @createImage('/img/dragndrop/album_single_copy.png')
    @ALBUM_DOUBLE_MOVE = @createImage('/img/dragndrop/album_double_move.png')
    @ALBUM_DOUBLE_COPY = @createImage('/img/dragndrop/album_double_copy.png')
#
#    @PHOTO_SINGLE_MOVE = @constructor.createImage
    
    $(window).bind('hashchange', @proxy @storeHash)
    User.bind('pinger', @proxy @validate)
    $('#modal-gallery').bind('hidden', @proxy @hideSlideshow)
    
    @modalSimpleView = new ModalSimpleView
      el: @modalEl
    @modal2ButtonView = new Modal2ButtonView
      el: @modalEl
    @missingView = new MissingView
      el: @missingEl
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
      uploader: @upload
    @flickrView = new FlickrView
      el: @flickrEl
    @slideshowView = @showView.slideshowView
    @sidebar = new Sidebar
      el: @sidebarEl
      externalUI: '.optSidebar'
    @sidebarFlickr = new SidebarFlickr
      el: @sidebarFlickrEl
    @loginView = new LoginView
      el: @loginEl
    @overviewView = new OverviewView
      el: @overviewEl
    @mainView = new MainView
      el: @mainEl
    @loaderView = new LoaderView
      el: @loaderEl

    @vmanager = new Spine.Manager(@sidebar)
    @vmanager.external = @showView.toolbarOne
    @vmanager.initDrag @vDrag,
      initSize: => @el.width()/4
      sleep: true
      disabled: false
      axis: 'x'
      min: -> 8
      tol: -> 50
      max: => @el.width()/2
      goSleep: => @sidebar.inner.hide()
      awake: => @sidebar.inner.show()

    @hmanager = new Spine.Manager(@gallery, @album, @photo, @upload)
    @hmanager.external = @showView.toolbarOne
    @hmanager.initDrag @hDrag,
      initSize: => @el.height()/4
      disabled: false
      axis: 'y'
      min: -> 30
      sleep: true
      max: => @el.height()/2
      goSleep: ->
        @manager.active().el.hide()
#        @showView.closeView()
      awake: -> 
        @manager.active().el.show()
#        @showView.openView()
        
    @hmanager.change @upload
    
    @appManager = new Spine.Manager(@mainView, @loaderView)
#    @appManager.change @loaderView
    @loaderView.trigger('active')
    
    @contentManager = new Spine.Manager(@overviewView, @missingView, @showView, @flickrView)
    @contentManager.bind('change', @proxy @changeCanvas)
    @bind('canvas', @proxy @canvas)
#    @contentManager.change @missingView

    @initializeFileupload()
    
    @routes
      '/gallery/:gid/:aid/:pid': (params) ->
        @showView.trigger('active')
        Gallery.trigger('activate', params.gid)
        Album.trigger('activate', params.aid)
        Photo.trigger('activate', params.pid)
        Spine.trigger('show:photo')
      '/gallery/:gid/:aid': (params) ->
        @showView.trigger('active')
        Gallery.trigger('activate', params.gid)
        Album.trigger('activate', params.aid)
        Spine.trigger('show:photos')
      '/gallery/:gid': (params) ->
        @showView.trigger('active')
        Gallery.trigger('activate', params.gid)
        Spine.trigger('show:albums')
      '/galleries/*': ->
        @showView.trigger('active')
        Spine.trigger('show:galleries')
      '/overview/*': ->
        @overviewView.trigger('active')
        Spine.trigger('show:overview')
      '/slideshow/:id/:autostart': (params) ->
        @showView.trigger('active')
        Spine.trigger('show:slideshow', params.autostart)
      '/slideshow/*': ->
        @showView.trigger('active')
        Spine.trigger('show:slideshow')
      '/flickr/:type/:page': (params) ->
        Spine.trigger('show:flickrView', params.type, params.page)
#        location.href = location.href + '1' unless params.page
#        @flickrView.trigger('flickr:'+params.type, params.page)
      '/flickr/': (params) ->
        Spine.trigger('show:flickrView')
#        @contentManager.change(@flickrView)
#        location.href = location.href + '1' unless params.page
#        @flickrView.trigger('flickr:'+params.type, params.page)
      '/*glob': (params) ->
        @missingView.trigger('active')
        Spine.trigger('show:missingView')

    @defaultSettings =
      welcomeScreen: false,
      test: true
    
    @loadToolbars()
  
  storeHash: ->
    if localStorage.hash
      localStorage.previousHash = localStorage.hash
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
      
  canvas: (controller) ->
    controller.trigger 'active'
    
  changeCanvas: (controller) ->
    try
      controller.el.addClass('in')
      controller.activated()
    catch e
      console.log e
      
  initializeFileupload: ->
    @uploader.fileupload
      autoUpload        : true
      singleFileUploads : false
      sequentialUploads : true
      maxFileSize       : 10000000 #5MB
      maxNumberOfFiles  : 20
      acceptFileTypes   : /(\.|\/)(gif|jpe?g|png)$/i
      getFilesFromResponse: (data) ->
        res = []
        for file in data.files
          res.push file
        res
    
  loadToolbars: ->
    Toolbar.load()
    
  keypress: (e) ->
    code = e.charCode or e.keyCode
    
#    console.log 'Main:keypressCode: ' + code
    
    switch code
      when 97 #CTRL A
        if e.metaKey or e.ctrlKey
          @showView.selectAll()
          e.preventDefault()
      when 13 #RETURN
        e.preventDefault()
    
  keyup: (e) ->
    code = e.charCode or e.keyCode
    
#    console.log 'Main:keyupCode: ' + code
    
    switch code
      when 32 #Space
        @slideshowView.toggle()
        e.preventDefault()
      when 9 #Tab
        @sidebar.toggleDraghandle()
        e.preventDefault()
      when 13 #Return
        e.preventDefault()
      when 27 #Esc
        @slideshowView.close()
        e.preventDefault()
        
module?.exports = Main
