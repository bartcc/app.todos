
class App extends Spine.Controller
  
  @extend Spine.Controller.Drag
  
  # Note:
  # this is how to change a toolbar:
  # App.showView.trigger('change:toolbar', 'Album')
  
  elements:
    '#main'               : 'mainEl'
    '#sidebar'            : 'sidebarEl'
    '#content .overview'  : 'overviewEl'
    '#content .show'      : 'showEl'
    '#content .edit'      : 'galleryEditEl'
    '#ga'                 : 'galleryEl'
    '#al'                 : 'albumEl'
    '#ph'                 : 'photoEl'
    '#fu'                 : 'uploadEl'
    '#fileupload'         : 'uploader'
    '#loader'             : 'loaderEl'
    '#login'              : 'loginEl'
    '#modal-gallery'      : 'slideshow'
    '#modal-view'         : 'modalEl'
    '.vdraggable'         : 'vDrag'
    '.hdraggable'         : 'hDrag'
    '.show .content'      : 'content'
    '.status-symbol img'  : 'statusIcon'
    '.status-text'        : 'statusText'
    '.status-symbol'      : 'statusSymbol'
    
  events:
    'keypress'            : 'keys'
    'drop'                : 'drop'
    'dragenter'           : 'dragenter'

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
    
    @modalView = new ModalView
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
    @overviewView = new OverviewView
      el: @overviewEl
    @showView = new ShowView
      el: @showEl
      activeControl: 'btnGallery'
      modalView: @modalView
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
    @hmanager.external = @showView.toolbarOne
    @hmanager.initDrag @hDrag,
      initSize: => @el.height()/2
      disabled: false
      axis: 'y'
      min: -> 90
      max: => @el.height()/2
      goSleep: => #@showView.toggleDraghandle()
      awake: => #@showView.activeControl?.click()

    @contentManager = new Spine.Manager(@overviewView, @showView, @galleryEditView)
    @contentManager.change @showView
    
    @appManager = new Spine.Manager(@mainView, @loaderView)
    @appManager.change @loaderView
    
    @slideshowOptions =
      canvas: false
      backdrop: true
      slideshow: 0
      
    @initializeFileupload()
    
    @routes
      '/photos/': ->
        Spine.trigger('show:allPhotos', true)
      '/overview/': ->
        Spine.trigger('show:overview')
        console.log('/overview/')
      '/slideshow/': ->
        Spine.trigger('show:slideshow')
      '/galleries/': ->
        Spine.trigger('gallery:activate', false)
        Spine.trigger 'show:galleries'
      '/gallery/:id': (params) ->
        @contentManager.change(@showView)
        gallery = Gallery.find(params.id) if Gallery.exists(params.id)
        Gallery.current(gallery)
        Spine.trigger('change:toolbar', ['Gallery'])
        Spine.trigger 'show:albums'
      '/gallery/:gid/:aid': (params) ->
        @contentManager.change(@showView)
        Spine.trigger 'show:photos'
        Gallery.current(params.gid)
        Album.current(params.aid)
      '/gallery/:gid/:aid/:pid': (params) ->
        @contentManager.change(@showView)
        gallery = Gallery.find(params.gid) if Gallery.exists(params.gid)
        album = Album.find(params.aid) if Album.exists(params.aid)
        photo = Photo.find(params.pid) if Photo.exists(params.pid)
        Gallery.current(gallery)
        Album.current(album)
        Spine.trigger 'show:photo', photo
    
  validate: (user, json) ->
    console.log 'Pinger done'
    valid = user.sessionid is json.sessionid
    valid = user.id is json.id and valid
    unless valid
      User.logout()
    else
      @old_statusIcon = @statusIcon[0].src
      @statusIcon[0].src = '/img/validated.png'
      @statusText.text 'Account verified'
      cb = ->
        @setupView()
      @delay cb, 500
      
  drop: (e) ->
    console.log 'App::drop'
    event = e.originalEvent
    Spine.dragItem?.closest?.removeClass('over nodrop')
    Spine.sortItem?.splitter.remove()
    e.stopPropagation() unless event.dataTransfer.files.length
    e.preventDefault()
      
  setupView: ->
    Spine.unbind('uri:alldone')
    @statusIcon[0].src = '/img/validated.png'
    @statusText.hide()
    cb = ->
      @appManager.change @mainView
      @showView.openPanel('gallery') unless Gallery.count()
      @loginView.render User.first()
      
    @statusText.text('Thanks for joining in').fadeIn('slow', => @delay cb, 500)
    
  initializeFileupload: ->
    @uploader.fileupload
      autoUpload        : false
      singleFileUploads : false
    
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
        @showView.pause(e)
        e.preventDefault()
        
        
    # KEYS
    switch keyCode
      when 9
        #tabKey -> toggle sidebar
        @sidebar.toggleDraghandle()
        e.preventDefault()
$ ->
  
  User.ping()
  window.App = new App(el: $('body'))
  Spine.Route.setup()
