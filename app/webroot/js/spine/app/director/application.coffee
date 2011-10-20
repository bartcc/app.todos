
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

  constructor: ->
    super
    
    @sidebar = new SidebarView
      el: @sidebarEl
    @gallery = new GalleryView
      el: @galleryEl
    @album = new AlbumView
      el: @albumEl
    @upload = new UploadView
      el: @uploadEl
    @grid = new GridView
      el: @gridEl
    @albumsShowView = new AlbumsShowView
      el: @albumsShowEl
      name: 'AlbumsShowView'
    @albumsEditView = new AlbumsEditView
      el: @albumsEditEl
      name: 'AlbumsEditView'
    @loginView = new LoginView
      el: @loginEl

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
      
$ ->
  window.App = new App(el: $('body'))
  
  User.fetch()
  App.loginView.render User.first()
  App.albumsManager.change(App.albumsShowView)
  App.albumsShowView.btnGallery.click()
  callback = ->
    App.closePanel('gallery', App.albumsShowView.btnGallery)
  App.openPanel('gallery', App.albumsShowView.btnGallery)
  App.delay callback, 1000
