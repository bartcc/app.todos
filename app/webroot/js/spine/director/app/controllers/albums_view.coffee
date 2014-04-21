Spine           = require("spine")
$               = Spine.$
Controller      = Spine.Controller
Drag            = require("plugins/drag")
User            = require("models/user")
Album           = require('models/album')
Gallery         = require('models/gallery')
GalleriesAlbum  = require('models/galleries_album')
AlbumsPhoto     = require('models/albums_photo')
Info            = require('controllers/info')
AlbumsList      = require('controllers/albums_list')
Extender        = require("plugins/controller_extender")
User            = require('models/user')

require("plugins/tmpl")

class AlbumsView extends Spine.Controller
  
  @extend Drag
  @extend Extender
  
  elements:
    '.hoverinfo'                      : 'infoEl'
    '.header .hoverinfo'              : 'headerEl'
    '.items'                          : 'itemsEl'
    
  events:
    'click      .item'                : 'click'
    
    'dragstart .item'                 : 'dragstart'
    'drop .item'                      : 'drop'
    'dragover   .items'               : 'dragover'
    
    'sortupdate .items'               : 'sortupdate'
    'mousemove .item'                 : 'infoUp'
    'mouseleave .item'                : 'infoBye'
    
  albumsTemplate: (items, options) ->
    $("#albumsTemplate").tmpl items, options

#  toolsTemplate: (items) ->
#    $("#toolsTemplate").tmpl items
#
  headerTemplate: (items) ->
    $("#headerAlbumTemplate").tmpl items
 
  infoTemplate: (item) ->
    $('#albumInfoTemplate').tmpl item
 
  constructor: ->
    super
    @el.data('current',
      model: Gallery
      models: Album
    )
    @type = 'Album'
    @info = new Info
      el: @infoEl
      template: @infoTemplate
    @list = new AlbumsList
      el: @itemsEl
      template: @albumsTemplate
      info: @info
      parent: @
    @header.template = @headerTemplate
    @viewport = @list.el
#      joinTableItems: (query, options) -> Spine.Model['GalleriesAlbum'].filter(query, options)

    Gallery.bind('current', @proxy @render)
    
    GalleriesAlbum.bind('beforeDestroy', @proxy @beforeDestroyGalleriesAlbum)
    Album.bind('refresh', @proxy @refresh)
    Album.bind('ajaxError', Album.errorHandler)
    Album.bind('create', @proxy @create)
    Album.bind('beforeDestroy', @proxy @beforeDestroyAlbum)
    Album.bind('destroy', @proxy @destroy)
    Album.bind('create:join', @proxy @createJoin)
    Album.bind('destroy:join', @proxy @destroyJoin)
    Album.bind('activate', @proxy @activateRecord)
    
    Photo.bind('refresh', @proxy @refreshBackgrounds)
    
    AlbumsPhoto.bind('destroy create', @proxy @updateBackgrounds)
    
#    GalleriesAlbum.bind('ajaxError', Album.errorHandler)
    
    Spine.bind('reorder', @proxy @reorder)
    Spine.bind('show:albums', @proxy @show)
    Spine.bind('create:album', @proxy @createAlbum)
    Spine.bind('changed:albums', @proxy @render)
    Spine.bind('loading:start', @proxy @loadingStart)
    Spine.bind('loading:done', @proxy @loadingDone)
    Spine.bind('loading:fail', @proxy @loadingFail)
    Spine.bind('destroy:album', @proxy @destroyAlbum)
    
    @bind('drag:help', @proxy @dragHelp)
    @bind('drag:start', @proxy @dragStart)
    @bind('drag:drop', @proxy @dragDrop)
    
    $(@views).queue('fx')
    
  refresh: (records) ->
    console.log 'AlbumsView::refresh'
    @render()
    
  updateBuffer: (gallery=Gallery.record) ->
    filterOptions =
      key: 'gallery_id'
      joinTable: 'GalleriesAlbum'
      sorted: true
    
    if gallery
      items = Album.filterRelated(gallery.id, filterOptions)
    else
      items = Album.filter()
    
    @buffer = items
    
  render: ->
    console.log 'AlbumsView::render'
    return unless @isActive()
    @list.render @updateBuffer()
#    $('.tooltips', @el).tooltip(title:'default title')
    @el
      
  show: ->
    App.showView.trigger('change:toolbarOne', ['Default'])
    App.showView.trigger('change:toolbarTwo', ['Slideshow'])
    App.showView.trigger('canvas', @)
    
  activated: ->
    albums = GalleriesAlbum.albums(Gallery.record.id)
    for alb in albums
      if alb.invalid
        alb.invalid = false
        alb.save(ajax:false)
        
    @render()
    
  activateRecord: (arr=[], ModelOrRecord) ->
    console.log 'AlbumsView::activateRecord'
    unless Spine.isArray(arr)
      arr = [arr]
      
    list = []
    for id in arr
      list.push album.id if album = Album.exists(id)
        
    id = list[0]
      
    if ModelOrRecord and ModelOrRecord.constructor.className
      ModelOrRecord.updateSelection(list)
    else
      App.sidebar.list.expand(Gallery.record, true) if id
      Gallery.updateSelection(null, list)
      Album.current(id)
      if Album.record
        Photo.trigger('activate', Album.selectionList())
      else
        Photo.trigger('activate')
      
  newAttributes: ->
    if User.first()
      title   : @albumName()
      author  : User.first().name
      invalid : false
      user_id : User.first().id
      order   : Album.count()
    else
      User.ping()
  
  albumName: (proposal = 'Album ' + (Number)(Gallery.record.count?(1) or Album.count()+1)) ->
    Album.each (record) =>
      if record.title is proposal
        return proposal = @albumName(proposal + '_1')
    return proposal
  
  createAlbum: (target=Gallery.record, options={}) ->
    cb = (album, ido) ->
      album.createJoin(target)
      if Gallery.record then target.updateSelection() else Gallery.updateSelection()
      album.updateSelectionID()
      options.album = album
      if options.photos
        Photo.trigger('create:join', options, false)
        Photo.trigger('destroy:join', options.photos, options.deleteFromOrigin) if options.deleteFromOrigin
      Spine.trigger('changed:albums', target)
      Album.trigger('activate', album.id)
      @navigate '/gallery', Gallery.record?.id or ''
    
    album = new Album @newAttributes()
    album.one('ajaxSuccess', @proxy cb)
    album.save()
       
  beforeDestroyGalleriesAlbum: (ga) ->
    gallery = Gallery.exists ga.gallery_id
    gallery.removeFromSelection ga.album_id if gallery
       
  destroyAlbum: (ids) ->
    console.log 'AlbumsView::destroyAlbum'
  
    func = (el) =>
      $(el).detach()
  
    albums = ids || Gallery.selectionList().slice(0)
    albums = [albums] unless Album.isArray albums
    
    for id in albums
      if item = Album.exists(id)
        el = @list.findModelElement(item)
        el.removeClass('in')
      
      setTimeout(func, 300, el)
    
    if gallery = Gallery.record
      @destroyJoin albums, gallery
    else
      for id in albums
        album.destroy() if album = Album.exists(id)
  
  create: (album) ->
    @render()
   
  beforeDestroyAlbum: (album) ->
  
    @stopInfo()
    
    # remove selection from root
    Gallery.removeFromSelection null, album.id
    
    # all involved galleries
    galleries = GalleriesAlbum.galleries(album.id)
    
    for gallery in galleries
      gallery.removeFromSelection album.id
      album.removeSelectionID()
      
      @list.findModelElement(album).detach()
      
      # remove all associated albums
      @destroyJoin album.id, gallery
   
  destroy: (album) ->
    photos = AlbumsPhoto.photos(album.id).toID()
    Photo.trigger('destroy:join', photos, album)
    album.removeSelectionID()
    @render() unless Album.count()
      
  createJoin: (albums, gallery, relocate) ->
    callback = ->
      gallery.updateSelection(albums)
      Spine.trigger('changed:albums', gallery)
  
    deferred = $.Deferred()
    Album.createJoin albums, gallery, callback
      
  destroyJoin: (albums, gallery) ->
    console.log 'AlbumsView::destroyJoin'
    return unless gallery and gallery.constructor.className is 'Gallery'
    albums = [albums] unless Album.isArray(albums)
    
    selection = []
    for id in albums
      selection.addRemoveSelection id

    Album.destroyJoin albums, gallery
    
    Spine.trigger('changed:albums', gallery)
    @sortupdate()
      
  loadingStart: (album) ->
    return unless @isActive()
    return unless album
    el = @itemsEl.children().forItem(album)
    $('.glyphicon-set', el).addClass('in')
    $('.downloading', el).removeClass('hide').addClass('in')
#    queue = el.data('queue').queue = []
#    queue.push {}
    
  loadingDone: (album) ->
    return unless @isActive()
    return unless album
    el = @itemsEl.children().forItem(album)
    $('.glyphicon-set', el).removeClass('in')
    $('.downloading', el).removeClass('in').addClass('hide')
#    el.data('queue').queue.splice(0, 1)
  
  loadingFail: (album, error) ->
    return unless @isActive()
    err = error.errorThrown
    el = @itemsEl.children().forItem(album)
    $('.glyphicon-set', el).removeClass('in')
    $('.downloading', el).addClass('error').tooltip('destroy').tooltip(title:err).tooltip('show')
    
  updateBackgrounds: (ap, mode) ->
    return unless @isActive()
    console.log 'AlbumsView::updateBackgrounds'
    albums = ap.albums()
    @list.renderBackgrounds albums
    
  refreshBackgrounds: (photos) ->
    return unless @parent.isActive()
    console.log 'AlbumsView::refreshBackgrounds'
    album = App.upload.album
    @list.renderBackgrounds [album] if album
    
  sortupdate: (e, o) ->
    return unless Gallery.record
    
    cb = ->
      Spine.trigger('changed:albums', Gallery.record)
      
    @list.children().each (index) ->
      item = $(@).item()
      if item
        ga = GalleriesAlbum.filter(item.id, func: 'selectAlbum')[0]
        if ga and parseInt(ga.order) isnt index
          ga.order = index
          ga.save(ajax:false)
    Gallery.record.save(done: cb)
    
  reorder: (gallery) ->
    if gallery.id is Gallery.record.id
      @render()
      
  click: (e) ->
    item = $(e.currentTarget).item()
    @select(item.id, @isCtrlClick(e))
    
  select: (items = [], exclusive) ->
    unless Spine.isArray items
      items = [items]
    Gallery.emptySelection() if exclusive
      
    selection = Gallery.selectionList().slice(0)
    for id in items
      selection.addRemoveSelection(id)
    
    Album.trigger('activate', selection[0])
    Gallery.updateSelection(null, selection)
    
  infoUp: (e) =>
    @info.up(e)
    el = $('.glyphicon-set' , $(e.currentTarget)).addClass('in').removeClass('out')
    
  infoBye: (e) =>
    @info.bye(e)
    el = $('.glyphicon-set' , $(e.currentTarget)).addClass('out').removeClass('in')
    
  stopInfo: (e) =>
    @info.bye(e)
      
  dropComplete: (e) ->
    console.log 'AlbumsView::dropComplete'
        
module?.exports = AlbumsView