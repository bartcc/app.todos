
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
    User.bind('pinger', @proxy @validate)
    Gallery.bind('refresh', @proxy @setupView)
    
    @sidebar = new SidebarView
      el: @sidebarEl
      className: 'SidebarView'
    @gallery = new GalleryView
      el: @galleryEl
      className: 'GalleryView'
    @album = new AlbumView
      el: @albumEl
      className: 'AlbumView'
    @upload = new UploadView
      el: @uploadEl
      className: 'UploadView'
    @grid = new GridView
      el: @gridEl
      className: 'GridView'
    @albumsShowView = new AlbumsShowView
      el: @albumsShowEl
      toolbar: 'Gallery'
      className: 'AlbumsShowView'
    @albumsEditView = new AlbumsEditView
      el: @albumsEditEl
      className: 'AlbumsEditView'
    @loginView = new LoginView
      el: @loginEl
      className: 'LoginView'
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
      #@delay cb, 1000
      
  setupView: ->
    @albumsManager.change(@albumsShowView)
    @openPanel('gallery', @albumsShowView.btnGallery) unless Gallery.count()
    @loginView.render User.first()

$ ->
  User.ping()
  window.App = new App(el: $('html'))
  
