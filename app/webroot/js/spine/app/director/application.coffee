
class App extends Spine.Controller
  
  elements:
    '#sidebar-wrapper'    : 'sidebarEl'
    '#albums'             : 'albumsEl'
    '#albums .show'       : 'albumsShowEl'
    '#albums .edit'       : 'albumsEditEl'
    '#gallery'            : 'galleryEl'
    '#album'              : 'albumEl'
    '#upload'             : 'uploadEl'
    '#grid'               : 'gridEl'
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
    @albumsEditView = new AlbumsEditView
      el: @albumsEditEl

    @vmanager = new Spine.Manager(@sidebar)
    @vmanager.initDrag @vDrag,
      initSize: @proxy ->
        $(@sidebar.el).width()/2
      disabled: false
      axis: 'x'
      min: 250
      max: @proxy ->
        $(@el).width()/2

    @hmanager = new Spine.Manager(@gallery, @album, @upload, @grid)
    @hmanager.initDrag @hDrag,
      initSize: @proxy ->
        $(@.el).height()/2
      disabled: false
      axis: 'y'
      min: 30
      max: @proxy ->
        @.el.height()*2/3
      goSleep: @proxy ->
        @albumsShowView.activeControl?.click()

    @albumsManager = new Spine.Manager(@albumsShowView, @albumsEditView)
      
$ ->
  window.App = new App(el: $('body'))
  
  App.albumsManager.change(App.albumsShowView)
  #App.albumsShowView.btnGallery.click()
