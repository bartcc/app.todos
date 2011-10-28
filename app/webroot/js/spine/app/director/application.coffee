
class App extends Spine.Controller
  
  elements:
    '#sidebar'            : 'sidebarEl'
    '#albums'             : 'albumsEl'
    '#albums .show'       : 'albumsShowEl'
    '#albums .edit'       : 'albumsEditEl'
    '#gallery'            : 'galleryEl'
    '#album'              : 'albumEl'
    '#upload'             : 'uploadEl'
    '#grid'               : 'gridEl'
    '#login'              : 'loginEl'
    '.vdraggable'         : 'vDrag'
    '.hdraggable'         : 'hDrag'
    '.show .content'      : 'content'
    '#loader'             : 'loaderEl'
    '#main'               : 'mainEl'
    'body'                : 'bodyEl'
    '.status-symbol img'  : 'icon'
    '.status-text'        : 'statusText'
    '.status-symbol'      : 'statusSymbol'

  constructor: ->
    super
    @ALBUM_SINGLE_MOVE = @constructor.createImage('/img/dragndrop/album_single_move.png')
    @ALBUM_SINGLE_COPY = @constructor.createImage('/img/dragndrop/album_single_copy.png')
    @ALBUM_DOUBLE_MOVE = @constructor.createImage('/img/dragndrop/album_double_move.png')
    @ALBUM_DOUBLE_COPY = @constructor.createImage('/img/dragndrop/album_double_copy.png')

    User.bind('pinger', @proxy @validate)
    Gallery.bind('refresh', @proxy @setupView)
    
    @gallery = new GalleryView
      el: @galleryEl
    @album = new AlbumView
      el: @albumEl
    @sidebar = new SidebarView
      el: @sidebarEl
    @upload = new UploadView
      el: @uploadEl
    @grid = new GridView
      el: @gridEl
    @albumsShowView = new AlbumsShowView
      el: @albumsShowEl
      toolbar: 'Gallery'
    @albumsEditView = new AlbumsEditView
      el: @albumsEditEl
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

    @hmanager = new Spine.Manager(@gallery, @album, @upload, @grid)
    @hmanager.initDrag @hDrag,
      initSize: => @el.height()/3
      disabled: false
      axis: 'y'
      min: -> 20
      max: => @el.height()/3
      goSleep: => @albumsShowView.activeControl?.click()

    @albumsManager = new Spine.Manager(@albumsShowView, @albumsEditView)
    
    @appManager = new Spine.Manager(@mainView, @loaderView)
    @appManager.change @loaderView

  validate: (user, json) ->
    console.log 'Pinger done'
    valid = user.sessionid is json.User.sessionid
    valid = user.id is json.User.id and valid
    unless valid
      User.logout()
    else
      @icon[0].src = '/img/validated.png'
      @statusText.text 'Account verified'
      @statusSymbol.toggleClass('verified')
      cb = ->
        @appManager.change @mainView
        @el.removeClass 'smheight'
        @bodyEl.removeClass 'smheight'
      @delay cb, 1000
      
  setupView: ->
    @albumsManager.change(@albumsShowView)
    @openPanel('gallery', @albumsShowView.btnGallery) unless Gallery.count()
    @loginView.render User.first()

$ ->
  User.ping()
  window.App = new App(el: $('html'))
