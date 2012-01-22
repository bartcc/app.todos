
class App extends Spine.Controller
  
  @extend Spine.Controller.Drag
  
  # Note:
  # change toolbar like so
  # Spine.trigger('change:toolbar', 'Album')
  
  elements:
    '#main'               : 'mainEl'
    '#sidebar'            : 'sidebarEl'
    '#content .overview'  : 'overviewEl'
    '#content .show'      : 'showEl'
    '#content .edit'      : 'galleryEditEl'
    '#ga'                 : 'galleryEl'
    '#al'                 : 'albumEl'
    '#ph'                 : 'photoEl'
    '#sl'                 : 'slideshowEl'
    '#fu'                 : 'uploadEl'
    '#fileupload'         : 'uploader'
    '#loader'             : 'loaderEl'
    '#login'              : 'loginEl'
    '#gallery'            : 'slideshow'
    '.vdraggable'         : 'vDrag'
    '.hdraggable'         : 'hDrag'
    '.show .content'      : 'content'
    '.status-symbol img'  : 'icon'
    '.status-text'        : 'statusText'
    '.status-symbol'      : 'statusSymbol'
    
  events:
    'keypress'            : 'keys'
    'drop'                : 'drop'
    'dragenter'           : 'dragenter'
#    'dragend'             : 'dragend'
#    'dragover'            : 'dragover'
#    'dragstart'           : 'dragstart'

  constructor: ->
    super
#    @ready = false
#    @ALBUM_SINGLE_MOVE = @constructor.createImage('/img/dragndrop/album_single_move.png')
#    @ALBUM_SINGLE_COPY = @constructor.createImage('/img/dragndrop/album_single_copy.png')
#    @ALBUM_DOUBLE_MOVE = @constructor.createImage('/img/dragndrop/album_double_move.png')
#    @ALBUM_DOUBLE_COPY = @constructor.createImage('/img/dragndrop/album_double_copy.png')
#
#    @PHOTO_SINGLE_MOVE = @constructor.createImage
    
    User.bind('pinger', @proxy @validate)
    
    @loadToolbars()
    
    @galleryEditView = new GalleryEditorView
      el: @galleryEditEl
    @gallery = new GalleryEditView
      el: @galleryEl
    @album = new AlbumEditView
      el: @albumEl
    @photo = new PhotoEditView
      el: @photoEl
    @upload = new UploadEditView
      el: @uploadEl
    @overviewView = new OverviewView
      el: @overviewEl
    @showView = new ShowView
      el: @showEl
      activeControl: 'btnGallery'
    @sidebar = new Sidebar
      el: @sidebarEl
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
    @hmanager.initDrag @hDrag,
      initSize: => @el.height()/2
      disabled: false
      axis: 'y'
      min: -> 20
      max: => @el.height()/2
      goSleep: => @showView.activeControl?.click()

    @contentManager = new Spine.Manager(@overviewView, @showView, @galleryEditView)
    @contentManager.change @showView
    
    @appManager = new Spine.Manager(@mainView, @loaderView)
    @appManager.change @loaderView
    
    @slideshowOptions =
      canvas: false
      backdrop: true
      slideshow: 0
      
    @initializeSlideshow()
    @initializeFileupload()

  validate: (user, json) ->
    console.log 'Pinger done'
    valid = user.sessionid is json.User.sessionid
    valid = user.id is json.User.id and valid
    unless valid
      User.logout()
    else
      @old_icon = @icon[0].src
      @icon[0].src = '/img/validated.png'
      @statusText.text 'Account verified'
      cb = ->
        @setupView()
      @delay cb, 1000
      
  drop: (e) ->
    console.log 'App::drop'
    event = e.originalEvent
    Spine.dragItem.closest?.removeClass('over nodrop')
    Spine.sortItem?.splitter.remove()
    e.stopPropagation() unless event.dataTransfer.files.length
    e.preventDefault()
      
  setupView: ->
    Spine.unbind('uri:alldone')
    @icon[0].src = '/img/validated.png'
    @statusText.hide()
    cb = ->
      @appManager.change @mainView
      @openPanel('gallery', @showView.btnGallery) unless Gallery.count()
      @loginView.render User.first()
      
    @statusText.text('Thanks for joining in').fadeIn('slow', => @delay cb, 1000)
    
  initializeSlideshow: (opts) ->
    options = $.extend(@slideshowOptions, opts)
    @slideshow.imagegallery options
    
  initializeFileupload: ->
    @uploader.fileupload()
    
  loadToolbars: ->
    Toolbar.load()
    
  keys: (e) =>
    key = e.keyCode
    switch key
      when 9
        @sidebar.toggleDraghandle()
        e.preventDefault()
        
$ ->
  
  User.ping()
  window.App = new App(el: $('body'))