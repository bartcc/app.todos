
class App extends Spine.Controller
  
  # Note:
  # you can change tollbar like so
  # Spine.trigger('change:toolbar', 'Album')
  
  elements:
    '#main'               : 'mainEl'
    '#sidebar'            : 'sidebarEl'
    '#content .show'      : 'showEl'
#    '#content .content.images'       : 'imagesContentEl'
    '#content .edit'      : 'galleryEditEl'
    '.contents .albums'   : 'albumsEl'
    '.contents .images'   : 'imagesEl'
    '#gallery'            : 'galleryEl'
    '#album'              : 'albumEl'
    '#upload'             : 'uploadEl'
    '#photo'              : 'photoEl'
    '#grid'               : 'gridEl'
    '#loader'             : 'loaderEl'
    '#login'              : 'loginEl'
    '.vdraggable'         : 'vDrag'
    '.hdraggable'         : 'hDrag'
    '.show .content'      : 'content'
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
    
    @sidebar = new SidebarView
      el: @sidebarEl
    @gallery = new GalleryView
      el: @galleryEl
    @album = new AlbumView
      el: @albumEl
    @photo = new PhotoView
      el: @photoEl
    @upload = new UploadView
      el: @uploadEl
    @grid = new GridView
      el: @gridEl
#    @gallery = new GalleryView
#      el: @galleryEl
#    @album = new AlbumView
#      el: @albumEl
#    @upload = new UploadView
#      el: @uploadEl
#    @grid = new GridView
#      el: @gridEl
#    @albumsView = new AlbumsView
#      el: @albumsContentEl
#      toolbar: 'Gallery'
#    @imagesView = new ImagesView
#      el: @imagesContentEl
    @showView = new ShowView
      el: @showEl
      activeControl: 'btnGallery'
    @albumsView = new AlbumsView
      el: @albumsEl
      parent: @showView
    @photosView = new PhotosView
      el: @imagesEl
      parent: @showView
    @galleryEditView = new GalleryEditView
      el: @galleryEditEl
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

    @hmanager = new Spine.Manager(@gallery, @album, @photo, @upload, @grid)
    @hmanager.initDrag @hDrag,
      initSize: => @el.height()/3
      disabled: false
      axis: 'y'
      min: -> 20
      max: => @el.height()/3
      goSleep: => @showView.activeControl?.click()

    @contentManager = new Spine.Manager(@showView, @galleryEditView)
    @contentManager.change @albumsView
    
    @canvasManager = new Spine.Manager(@albumsView, @photosView)
#    @contentManager = new Spine.Manager(@contentView, @galleryEditView)
#    @contentManager.change @albumsView
    
    
#    @contentManager = new Spine.Manager(@albumsView, @imagesView)
#    @contentManager.change @albumsView
    
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
      cb = ->
        @appManager.change @mainView
        @canvasManager.change @albumsView
      @delay cb, 2000
      
  setupView: ->
    @contentManager.change(@showView)
    @openPanel('gallery', @showView.btnGallery) unless Gallery.count()
    @loginView.render User.first()

$ ->
  User.ping()
  window.App = new App(el: $('body'))
