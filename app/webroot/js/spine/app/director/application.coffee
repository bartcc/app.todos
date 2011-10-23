
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
    'body'               : 'bodyEl'

  constructor: ->
    super
    User.bind('pinger', @proxy @validationComplete)
    
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

  validationComplete: (user, json) ->
    console.log 'Pinger done'
    valid = user.sessionid is json.User.sessionid
    valid = user.id is json.User.id and valid
    unless valid
      User.logout()
      User.redirect 'users/login'
    else
      @el.removeClass 'smheight'
      @bodyEl.removeClass 'smheight'
      @appManager.change @mainView
      
$ ->
  User.ping()
  alert base_url
  window.App = new App(el: $('html'))
  
  App.loginView.render User.first()
  App.albumsManager.change(App.albumsShowView)
#  cb = ->
#    App.closePanel('gallery', App.albumsShowView.btnGallery) if Gallery.count()
  App.openPanel('gallery', App.albumsShowView.btnGallery) unless Gallery.count()
#  App.delay cb, 1000
