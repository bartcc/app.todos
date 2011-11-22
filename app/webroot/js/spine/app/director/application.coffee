
class App extends Spine.Controller
  
  # Note:
  # change toolbar like so
  # Spine.trigger('change:toolbar', 'Album')
  
  elements:
    '#main'               : 'mainEl'
    '#sidebar'            : 'sidebarEl'
    '#content .show'      : 'showEl'
    '#content .edit'      : 'galleryEditEl'
    '#gallery'            : 'galleryEl'
    '#album'              : 'albumEl'
    '#fileupload'         : 'uploadEl'
    '#photo'              : 'photoEl'
    '#slideshow'          : 'slideshowEl'
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
    @ready = false
    @ALBUM_SINGLE_MOVE = @constructor.createImage('/img/dragndrop/album_single_move.png')
    @ALBUM_SINGLE_COPY = @constructor.createImage('/img/dragndrop/album_single_copy.png')
    @ALBUM_DOUBLE_MOVE = @constructor.createImage('/img/dragndrop/album_double_move.png')
    @ALBUM_DOUBLE_COPY = @constructor.createImage('/img/dragndrop/album_double_copy.png')

    User.bind('pinger', @proxy @validate)
    Spine.bind('uri:alldone', @proxy @setupView)
    
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
    @slideshow = new SlideshowView
      el: @slideshowEl
    @showView = new ShowView
      el: @showEl
      activeControl: 'btnGallery'
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

    @hmanager = new Spine.Manager(@gallery, @album, @photo, @upload, @slideshow)
    @hmanager.initDrag @hDrag,
      initSize: => @el.height()/3
      disabled: false
      axis: 'y'
      min: -> 20
      max: => @el.height()/3
      goSleep: => @showView.activeControl?.click()

    @contentManager = new Spine.Manager(@showView, @galleryEditView)
    @contentManager.change @showView
    
    @appManager = new Spine.Manager(@mainView, @loaderView)
    @appManager.change @loaderView

  validate: (user, json) ->
    console.log 'Pinger done'
    valid = user.sessionid is json.User.sessionid
    valid = user.id is json.User.id and valid
    unless valid
      User.logout()
    else
      @old_icon = @icon[0].src
      @icon[0].src = '/img/validated.png'
      @statusText.text 'Account verified'
      cb = ->
        @setupView()
      @delay cb, 1000
      
  # not used
  thumbs: ->
    @icon[0].src = @old_icon
    @statusText.hide()
    @statusText.text('Creating Album Previews').fadeIn('slow')
    albums = Album.filter()
    for album in albums
      album.uri
        width: 50
        height: 50
        , =>
          return
        , 3
      
  setupView: ->
    Spine.unbind('uri:alldone')
    @icon[0].src = '/img/validated.png'
    @statusText.hide()
    cb = ->
      @appManager.change @mainView
      @openPanel('gallery', @showView.btnGallery) unless Gallery.count()
      @loginView.render User.first()
      
    @statusText.text('Thanks for Patience').fadeIn('slow', => @delay cb, 1000)
    

$ ->
  
  User.ping()
  window.App = new App(el: $('body'))
