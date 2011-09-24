class App extends Spine.Controller
  
  elements:
    '#sidebar-wrapper'    : 'sidebarEl'
    '#albums'             : 'albumsEl'
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
    @albums = new AlbumsView
      el: @albumsEl

    @vmanager = new Spine.Manager(@sidebar)
    @vmanager.initDrag @vDrag,
      initSize: @proxy ->
        $(@sidebar.el).width()/2
      disabled: false
      axis: 'x'
      min: 250
      max: @proxy ->
        $(@el).width()/2

    @hmanager = new Spine.Manager(@gallery, @upload, @album, @grid)
    @hmanager.initDrag @hDrag,
      initSize: @proxy ->
        $(@albums.el).height()/2
      disabled: false
      axis: 'y'
      min: 30
      max: @proxy ->
        (@albums.el).height()*2/3
      goSleep: @proxy ->
        @albums.activeControl?.click()
      
$ ->
  window.App = new App(el: $('body'))
  App.albums.galleryBtn.click()
  #Gallery.fetch()
