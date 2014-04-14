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
    '.items'                          : 'items'
    
  events:
    'click      .item'                : 'click'
    
    'dragstart .item'                 : 'stopInfo'
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
      el: @items
      template: @albumsTemplate
      info: @info
      parent: @
    @header.template = @headerTemplate
    @viewport = @list.el
#      joinTableItems: (query, options) -> Spine.Model['GalleriesAlbum'].filter(query, options)
    Album.bind('refresh', @proxy @refresh)
    Album.bind('ajaxError', Album.errorHandler)
    Album.bind('create', @proxy @create)
    Album.bind('beforeDestroy', @proxy @beforeDestroy)
    Album.bind('destroy', @proxy @destroy)
    Album.bind('create:join', @proxy @createJoin)
    Album.bind('destroy:join', @proxy @destroyJoin)
    Photo.bind('refresh', @proxy @refreshBackgrounds)
    AlbumsPhoto.bind('destroy create', @proxy @updateBackgrounds)
#    GalleriesAlbum.bind('ajaxError', Album.errorHandler)
#    GalleriesAlbum.bind('destroy:join', @proxy @destroyJoin)
    Spine.bind('reorder', @proxy @reorder)
    Spine.bind('show:albums', @proxy @show)
    Spine.bind('create:album', @proxy @createAlbum)
    Spine.bind('loading:start', @proxy @loadingStart)
    Spine.bind('loading:done', @proxy @loadingDone)
    Spine.bind('loading:fail', @proxy @loadingFail)
    Spine.bind('destroy:album', @proxy @destroyAlbum)
#    Gallery.bind('current', @proxy @render)
    Album.bind('activate', @proxy @activateRecord)
    
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
      
    
  activateRecord: (arr=[]) ->
    console.log 'AlbumsView::activateRecord'
    unless Spine.isArray(arr)
      arr = [arr]
      
    list = []
    for id in arr
      list.push album.id if album = Album.exists(id)
        
    id = list[0]
    if id
      App.sidebar.list.expand(Gallery.record, true)
      
    Gallery.updateSelection(list)
    Album.current(id)
    
    
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
      album.updateSelection()
      album.updateSelectionID()
      if options.photos
        Photo.trigger('create:join', options.photos, album)
        Photo.trigger('destroy:join', options.photos, options.from) if options.from
      Gallery.trigger('changed:albums', target)
      
    album = new Album @newAttributes()
    album.one('ajaxSuccess', cb)
    album.save()
    @navigate '/gallery', Gallery.record?.id or '', album.id
        
  destroyAlbum: (ids) ->
    console.log 'AlbumsView::destroyAlbum'
    albums = ids || Gallery.selectionList().slice(0)
    albums = [albums] unless Album.isArray albums
    if Gallery.record
      @destroyJoin albums, Gallery.record
      
    else
      for id in albums
        galleries = GalleriesAlbum.galleries(id)
        for gallery in galleries
          @destroyJoin id, gallery
        if album = Album.exists(id)
          list = Gallery.removeFromSelection album.id
#          Album.trigger('activate', list)
          album.destroy()
  
  create: (album) ->
    @render()
   
  beforeDestroy: (album) ->
    photos = AlbumsPhoto.photos(album.id).toID()
    Photo.trigger('destroy:join', photos, album)
    
    album.removeSelectionID()
    
    @list.findModelElement(album).remove()
    
    gas = GalleriesAlbum.filter(album.id, key: 'album_id')
    for ga in gas
      @destroyJoin [album.id], Gallery.exists gas.gallery_id
   
  destroy: (album) ->
    @render() unless Album.count()
      
  createJoin: (albums, gallery) ->
    for aid in albums
      album = Album.exists aid
      album.createJoin gallery if album
    Gallery.trigger('changed:albums', gallery)
      
  destroyJoin: (albums, gallery) ->
    console.log 'AlbumsView::destroyJoin'
    return unless gallery and gallery.constructor.className is 'Gallery'
    albums = [albums] unless Album.isArray(albums)
    for aid in albums
      if ga = GalleriesAlbum.galleryAlbumExists(aid, gallery.id)
        list = Gallery.removeFromSelection ga.album_id
#        Album.trigger('activate', list)
        ga.destroy()
    Gallery.trigger('changed:albums', gallery)
    @sortupdate()
      
  loadingStart: (album) ->
    return unless @isActive()
    return unless album
    el = @items.children().forItem(album)
    $('.glyphicon-set', el).addClass('in')
    $('.downloading', el).removeClass('hide').addClass('in')
#    queue = el.data('queue').queue = []
#    queue.push {}
    
  loadingDone: (album) ->
    return unless @isActive()
    return unless album
    el = @items.children().forItem(album)
    $('.glyphicon-set', el).removeClass('in')
    $('.downloading', el).removeClass('in').addClass('hide')
#    el.data('queue').queue.splice(0, 1)
  
  loadingFail: (album, error) ->
    return unless @isActive()
    err = error.errorThrown
    el = @items.children().forItem(album)
    $('.glyphicon-set', el).removeClass('in')
    $('.downloading', el).addClass('error').tooltip('destroy').tooltip(title:err).tooltip('show')
    
  updateBackgrounds: (ap, mode) ->
    return unless @isActive()
    console.log 'AlbumsView::updateBackgrounds'
    albums = ap.albums()
    console.log albums.length
    @list.renderBackgrounds albums
    
  refreshBackgrounds: (photos) ->
    return unless @parent.isActive()
    console.log 'AlbumsView::refreshBackgrounds'
    album = App.upload.album
    @list.renderBackgrounds [album] if album
    
  sortupdate: (e, o) ->
    @list.children().each (index) ->
      item = $(@).item()
      if item and Gallery.record
        ga = GalleriesAlbum.filter(item.id, func: 'selectAlbum')[0]
        if ga and parseInt(ga.order) isnt index
          ga.order = index
          ga.save()
        
  reorder: (gallery) ->
    if gallery.id is Gallery.record.id
      @render()
      
  click: (e) ->
    item = $(e.currentTarget).item()
    @select(item, @isCtrlClick(e))
    
    e.stopPropagation()
    e.preventDefault()
    
  select: (items = [], exclusive) ->
    console.log 'AlbumsView::select'
    unless Spine.isArray items
      items = [items]
      
    items = items.toID()
    
    Album.emptySelection() if exclusive
      
    list = Gallery.selectionList().slice(0)
    for id in items
      list.addRemoveSelection(id)
    
    Gallery.updateSelection(list)
#    Album.trigger('activate', list)
    
  infoUp: (e) =>
    @info.up(e)
    el = $('.glyphicon-set' , $(e.currentTarget)).addClass('in').removeClass('out')
    
  infoBye: (e) =>
    @info.bye(e)
    el = $('.glyphicon-set' , $(e.currentTarget)).addClass('out').removeClass('in')
    
  stopInfo: (e) =>
    @info.bye(e)
        
module?.exports = AlbumsView