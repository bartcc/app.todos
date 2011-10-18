
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
      initSize: @proxy -> $(@sidebar.el).width()
      disabled: false
      axis: 'x'
      min: -> 8
      tol: -> 20
      max: @proxy -> $(@el).width()/2
      goSleep: @proxy -> @sidebar.inner.hide()
      awake: @proxy -> @sidebar.inner.show()

    @hmanager = new Spine.Manager(@gallery, @album, @upload, @grid)
    @hmanager.initDrag @hDrag,
      initSize: @proxy -> $(@el).height()/2
      disabled: false
      axis: 'y'
      min: -> 30
      max: @proxy -> @el.height()*2/3
      goSleep: @proxy -> @albumsShowView.activeControl?.click()

    @albumsManager = new Spine.Manager(@albumsShowView, @albumsEditView)
      
$ ->
  window.App = new App(el: $('body'))
  
  User.fetch()
  App.loginView.render User.first()
  App.albumsManager.change(App.albumsShowView)
  #App.albumsShowView.btnGallery.click()
