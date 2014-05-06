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

require('spine/lib/route')
require('spine/lib/manager')
require("plugins/manager")

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
    '#show .content'      : 'content'
    '.vdraggable'         : 'vDrag'
    '.hdraggable'         : 'hDrag'
    '.status-symbol img'  : 'statusIcon'
    '.status-text'        : 'statusText'
    '.status-symbol'      : 'statusSymbol'
    
  events:
    'click [class*="-trigger-edit"]' : 'activateEditor'
    'drop'                : 'drop'
    
    'focus'               : 'focus'
    
    'keyup'               : 'key'
    'keydown'             : 'key'

  constructor: ->
    super
    
    @ALBUM_SINGLE_MOVE = @createImage('/img/cursor_folder_1.png')
    @ALBUM_DOUBLE_MOVE = @createImage('/img/cursor_folder_3.png')
    @IMAGE_SINGLE_MOVE = @createImage('/img/cursor_images_1.png')
    @IMAGE_DOUBLE_MOVE = @createImage('/img/cursor_images_3.png')
    
    $(window).bind('hashchange', @proxy @storeHash)
    $(window).bind('focus', @proxy @focus)
    
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
      externalClass: '.optGallery'
    @album = new AlbumEditView
      el: @albumEl
      externalClass: '.optAlbum'
    @photo = new PhotoEditView
      el: @photoEl
      externalClass: '.optPhoto'
    @upload = new UploadEditView
      el: @uploadEl
      externalClass: '.optUpload'
    @sidebar = new Sidebar
      el: @sidebarEl
      externalClass: '.optSidebar'
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
    @flickrView = new FlickrView
      el: @flickrEl
    @showView = new ShowView
      el: @showEl
      activeControl: 'btnGallery'
      uploader: @upload
      sidebar: @sidebar
      parent: @
    @slideshowView = @showView.slideshowView

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
      min: -> 50
      sleep: true
      max: => @el.height()/1.5
      goSleep: ->
#        controller.el.hide() if controller = @manager.active()
      awake: ->
#        controller.el.show() if controller = @manager.active()
    
    @appManager = new Spine.Manager(@mainView, @loaderView)
    @contentManager = new Spine.Manager(@overviewView, @missingView, @showView, @flickrView)
    
    @hmanager.bind('awake', => @showView.trigger('awake'))
    @hmanager.bind('sleep', => @showView.trigger('sleep'))
    @hmanager.bind('change', @proxy @changeEditCanvas)
    @appManager.bind('change', @proxy @changeMainCanvas)
    @contentManager.bind('change', @proxy @changeCanvas)
    
    @bind('canvas', @proxy @canvas)

    @upload.trigger('active')
    @loaderView.trigger('active')
    
    @initializeFileupload()
    
    $(window).trigger('focus')
    
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
      '/slideshow/:index': (params) ->
        Spine.trigger('show:slideshow', params.index)
        @showView.trigger('active')
      '/slideshow/*glob': (params) ->
        @showView.trigger('active')
        Spine.trigger('show:slideshow', params.glob)
      '/wait/*glob': (params) ->
        @showView.trigger('active')
        Spine.trigger('show:wait')
      '/flickr/:type/:page': (params) ->
        @flickrView.trigger('active')
        Spine.trigger('show:flickrView', params.type, params.page)
      '/flickr/': (params) ->
        @flickrView.trigger('active')
        Spine.trigger('show:flickrView')
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
    @log 'Pinger done'
    valid = user.sessionid is json.sessionid
    valid = user.id is json.id and valid
    unless valid
      User.logout()
    else
      @delay @setupView, 1000
      
  drop: (e) ->
    @log 'drop'
    
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
    @loginView.render()
    @mainView.el.fadeIn(1500)
      
  canvas: (controller) ->
    controller.trigger 'active'
    
  changeMainCanvas: (controller) ->
    controller.activated()
    
  changeCanvas: (controller) ->
    try
      controller.el.addClass('in')
      controller.activated()
    catch e
      
  changeEditCanvas: (controller) ->
    controller.activated() if controller
  
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

  refreshAll: -> @sidebar.refreshAll()

  fetchAll: ->
    Photo.fetch(null, clear:true)
    Album.fetch(null, clear:true)
    Gallery.fetch(null, clear:true)
    
  activateEditor: (e) ->
    el = $(e.currentTarget)
    test = el.prop('class')
    if /\bgal-*/.test(test)
      @gallery.trigger('active')
    else if /\balb-*/.test(test)
      @album.trigger('active')
    else if /\bpho-*/.test(test)
      @photo.trigger('active')
      
    e.preventDefault()
    e.stopPropagation()
    
  key: (e) ->
    code = e.charCode or e.keyCode
    type = e.type
    
#    @log 'Main:code: ' + code
    
    el=$(document.activeElement)
    isFormfield = $().isFormElement(el)
      
    #use this keydown for tabindices to gain focus
    #tabindex elements will then be able to listen for keyup events subscribed in the controller 
    return unless type is 'keydown'
    
    switch code
      when 8 #Backspace
        unless isFormfield
          e.preventDefault()
      when 9 #Tab
        unless isFormfield
          @sidebar.toggleDraghandle()
          e.preventDefault()
      when 13 #Return
        unless isFormfield
          e.preventDefault()
      when 27 #Esc
        unless isFormfield
          e.preventDefault()
      when 32 #Space
        unless isFormfield
          if @overviewView.isActive()
            @overviewView.focus(e)
          e.preventDefault()
      when 37 #Left
        unless isFormfield
          e.preventDefault()
      when 38 #Up
        unless isFormfield
          e.preventDefault()
      when 39 #Right
        unless isFormfield
          e.preventDefault()
      when 40 #Down
        unless isFormfield
          e.preventDefault()
      when 65 #ctrl A
        unless isFormfield
          e.preventDefault()
        
  focus: (e) ->
    el=$(document.activeElement)
    isFormfield = $().isFormElement(el)
    
    unless isFormfield
      @showView.controller.focus()

module?.exports = Main
