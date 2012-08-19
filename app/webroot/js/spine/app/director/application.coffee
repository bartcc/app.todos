
class App extends Spine.Controller
  
  @extend Spine.Controller.Drag
  
  # Note:
  # this is how to change a toolbar:
  # App.showView.trigger('change:toolbar', 'Album')
  
  elements:
    '#twitter'            : 'twitterEl'
    '#main'               : 'mainEl'
    '#sidebar'            : 'sidebarEl'
    '.show'               : 'showEl'
    '.overview'           : 'overviewEl'
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
    @showView = new ShowView
      el: @showEl
      activeControl: 'btnGallery'
      modalView: @modalView
      uploader: @upload
    @overviewView = new OverviewView
      el: @overviewEl
    @sidebar = new Sidebar
      el: @sidebarEl
    @sidebarTwitter = new SidebarTwitter
      el: @twitterEl
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
    
    @contentManager = new Spine.Manager(@showView, @galleryEditView, @overviewView)
    @contentManager.change @showView
    
    @slideshowOptions =
      canvas: false
      backdrop: true
      slideshow: 1000

    @initializeFileupload()
    
    @routes
      '/gallery/:gid/:aid/:pid': (params) ->
        @contentManager.change(@showView)
        photo = Photo.find(params.pid) if Photo.exists(params.pid)
        Spine.trigger 'show:photo', photo
        Gallery.current(params.gid)
        Album.current(params.aid)
      '/gallery/:gid/:aid': (params) ->
        @contentManager.change(@showView)
        Spine.trigger 'show:photos'
        Gallery.current(params.gid)
        Album.current(params.aid)
      '/gallery/:id': (params) ->
        @contentManager.change(@showView)
        Spine.trigger('change:toolbar', ['Gallery'])
        Spine.trigger 'show:albums'
        gallery = Gallery.find(params.id) if Gallery.exists(params.id)
        Gallery.current(gallery)
      '/galleries/': ->
        Spine.trigger('gallery:activate', false)
        Spine.trigger 'show:galleries'
      '/photos/': ->
        Spine.trigger('show:photos')
        Album.current()
      '/overview/': ->
        Spine.trigger('show:overview', true)
      '/slideshow/': ->
        Spine.trigger('album:activate')
        Spine.trigger('show:slideshow')
    
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
      @delay @setupView, 400
      
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
    @statusText.text('Thanks for joining in').fadeIn('slow', => @delay @finalizeView, 300)
      
  finalizeView: ->
    @appManager.change @mainView
    @loginView.render User.first()
      
    
  initializeSlideshow: ->
    $('#modal-gallery').on('load', () ->
      modalData = $(@).data('modal')
      console.log modalData.$links
#        modalData.$links is the list of (filtered) element nodes as jQuery object
#        modalData.img is the img (or canvas) element for the loaded image
#        modalData.options.index is the index of the current link
    )

  initializeFileupload: ->
    @uploader.fileupload
      autoUpload        : true
      singleFileUploads : true
    
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
      when 27
        console.log @showView.btnPrevious
        @showView.btnPrevious.click()
        e.preventDefault()
      else
        console.log keyCode
        e.preventDefault()
$ ->
  
  User.ping()
  window.App = new App(el: $('body'))
  Spine.Route.setup()
  App.navigate '/overview/'
