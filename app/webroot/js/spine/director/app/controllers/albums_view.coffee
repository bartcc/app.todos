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
    'dragstart  .items .thumbnail'    : 'dragstart'
    'dragover   .items'               : 'dragover'
    'sortupdate .items'               : 'sortupdate'
    
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
    @el.data current: Gallery
    @info = new Info
      el: @infoEl
      template: @infoTemplate
    @list = new AlbumsList
      el: @items
      template: @albumsTemplate
      info: @info
      parent: @
    @header.template = @headerTemplate
#      joinTableItems: (query, options) -> Spine.Model['GalleriesAlbum'].filter(query, options)
    Spine.bind('show:albums', @proxy @show)
    Spine.bind('create:album', @proxy @createAlbum)
    Spine.bind('destroy:album', @proxy @destroyAlbum)
    Album.bind('ajaxError', Album.errorHandler)
    Album.bind('create', @proxy @create)
    Album.bind('beforeDestroy', @proxy @beforeDestroy)
    Album.bind('destroy', @proxy @destroy)
#    GalleriesAlbum.bind('ajaxError', Album.errorHandler)
    GalleriesAlbum.bind('destroy:join', @proxy @destroyJoin)
    Album.bind('create:join', @proxy @createJoin)
    GalleriesAlbum.bind('change', @proxy @renderHeader)
    Spine.bind('change:selectedGallery', @proxy @change)
#    Spine.bind('change:selectedGallery', @proxy @renderHeader)
    Gallery.bind('refresh change', @proxy @renderHeader)
    Spine.bind('loading:start', @proxy @loadingStart)
    Spine.bind('loading:done', @proxy @loadingDone)
    
    Album.bind('sortupdate', @proxy @sortupdate)
    GalleriesAlbum.bind('destroy', @proxy @sortupdate)
    
    $(@views).queue('fx')
    
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
    
  change: (item, mode) ->
    console.log 'AlbumsView::change'
    
    @updateBuffer item
    @render()
    
  render: ->
    return unless @isActive()
    console.log 'AlbumsView::render'
    @header.render()
    list = @list.render @buffer
    list.sortable('album')
    delete @buffer
    @el
      
  renderHeader: (item) ->
#    return unless @isActive()
#    return unless Gallery.record
    console.log 'AlbumsView::renderHeader'
    @header.render item
  
  show: (idOrRecord) ->
    App.showView.trigger('change:toolbarOne', ['Default'])
    App.showView.trigger('change:toolbarTwo', ['Slideshow'])
    App.showView.trigger('canvas', @)
    
    albums = GalleriesAlbum.albums(Gallery.record.id)
    for alb in albums
      if alb.invalid
        alb.invalid = false
        alb.save(ajax:false)
        
    @change()
    
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
    console.log 'AlbumsView::create'
    cb = ->
      @createJoin(target) if target
      @updateSelectionID()
      console.log @id
      if options.photos
        # copy photos to this album if a list argument is available
        Photo.trigger('create:join', options.photos, @)
        # optionally remove photos from original album
        Photo.trigger('destroy:join', options.photos, options.from) if options.from
      Album.trigger('activate', Gallery.updateSelection @id)
      
    album = new Album @newAttributes()
    album.save(done: cb)
        
  destroyAlbum: (ids) ->
    console.log 'AlbumsView::destroyAlbum'
    albums = ids || Gallery.selectionList()
    albums = [albums] unless Album.isArray albums
    if Gallery.record
      @destroyJoin albums, Gallery.record
    else
      albums = Album.toRecords(albums)
      for album in albums
        album.destroy()
  
  create: ->
    @change()
   
  beforeDestroy: (album) ->
    photos = AlbumsPhoto.photos(album.id).toID()
    Photo.trigger('destroy:join', photos, album)
    
    Gallery.removeFromSelection album.id
    album.removeSelectionID()
    
    @list.findModelElement(album).remove()
    
    gas = GalleriesAlbum.filter(album.id, key: 'album_id')
    for ga in gas
      @destroyJoin [album.id], Gallery.exists gas.gallery_id
   
  destroy: (album) ->
    if Album.count()
      @renderHeader()
    else
      @render()
      
  createJoin: (albums, target) ->
    for aid in albums
      album.createJoin target if album = Album.exists aid
      
  destroyJoin: (albums, gallery) ->
    return unless gallery and gallery.constructor.className is 'Gallery'
    for aid in albums
      ga = GalleriesAlbum.galleryAlbumExists(aid, gallery.id)
      @list.findModelElement(album).remove() if album = Album.exists(aid)
      ga.destroy()
      
  loadingStart: (album) ->
    return unless @isActive()
    el = @items.children().forItem(album)
    $('.glyphicon-set', el).addClass('in')
    $('.downloading', el).addClass('in')
    unless el.data()['queue']
      queue = el.data()['queue'] = []
      queue.push {}
    else
      queue = el.data()['queue']
      queue.push {}
    
  loadingDone: (album) ->
    return unless @isActive()
    el = @items.children().forItem(album)
    $('.glyphicon-set', el).removeClass('in')
    el.data().queue?.splice(0, 1)
    $('.downloading', el).removeClass('in')
#    el.removeClass('loading') unless el.data().queue?.length
    
  sortupdate: ->
    @list.children().each (index) ->
      item = $(@).item()
      if item and Gallery.record
        ga = GalleriesAlbum.filter(item.id, func: 'selectAlbum')[0]
        if ga and ga.order isnt index
          ga.order = index
          ga.save()
      else if item
        album = (Album.filter(item.id, func: 'selectAlbum'))[0]
        album.order = index
        album.save()
        
#    Gallery.updateSelection Gallery.sortSelectionListByOrder()
        
module?.exports = AlbumsView