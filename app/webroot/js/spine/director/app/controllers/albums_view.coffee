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
#    'drop       .items'               : 'drop'
    
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
    @filterOptions =
      key:'gallery_id'
      joinTable: 'GalleriesAlbum'
      sorted: true
#      joinTableItems: (query, options) -> Spine.Model['GalleriesAlbum'].filter(query, options)
    Spine.bind('show:albums', @proxy @show)
    Spine.bind('show:allAlbums', @proxy @render)
    Spine.bind('create:album', @proxy @create)
    Album.bind('update create', @proxy @change)
    Spine.bind('destroy:album', @proxy @destroy)
    Album.bind('ajaxError', Album.errorHandler)
#    GalleriesAlbum.bind('ajaxError', Album.errorHandler)
    Album.bind('destroy:join', @proxy @destroyJoin)
    Album.bind('create:join', @proxy @createJoin)
    GalleriesAlbum.bind('change', @proxy @renderHeader)
    Spine.bind('change:selectedGallery', @proxy @changeGallery)
    Spine.bind('change:selectedGallery', @proxy @renderHeader)
    Gallery.bind('refresh change', @proxy @renderHeader)
    Spine.bind('loading:start', @proxy @loadingStart)
    Spine.bind('loading:done', @proxy @loadingDone)
    
    Album.bind('sortupdate', @proxy @sortupdate)
    GalleriesAlbum.bind('destroy', @proxy @sortupdate)
    
    $(@views).queue('fx')
    
  # this method is triggered when changing Gallery.record
  change: (item, mode) ->
    console.log 'AlbumsView::change'
    
    return unless item
    @render(item, mode)
    
  changeGallery: (item, mode) ->
    console.log 'AlbumsView::changeGallery'
    console.log mode
    
    return unless item
    return if mode is 'update'
    @render(item, mode)
    
  render: (item, mode) ->
    console.log 'AlbumsView::render'
    @header.render()
    
    unless Gallery.record
      unless mode is ('update' or 'create')
        items = Album.filter()
    else
      items = Album.filterRelated(Gallery.record.id, @filterOptions)
      
    unless mode is ('update' or 'create')
      list = @list.render items
    list.sortable('album')
    

    # when in Photos View the Album is deleted return to this View
    if items and items.constructor.className is 'GalleriesAlbum' and item.destroyed
      @show()
      
    @el
      
  renderHeader: (item) ->
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
  
  create: (list=[], target=Gallery.record, options) ->
    console.log 'AlbumsView::create'
    console.log list
    
    cb = (result) ->
      @createJoin(target)
      # Have photos moved/copied to the new album
      Photo.trigger('create:join', list, @)
      Photo.trigger('destroy:join', list, options.origin) if options?.origin?
      Album.trigger('activate', Gallery.updateSelection Album.last().id)
      
    album = new Album @newAttributes()
    album.save(done: cb)
        
  destroy: (ids) ->
    console.log 'AlbumsView::destroy'
    list = ids || Gallery.selectionList()
    albums = []
    Album.each (record) =>
      albums.push record unless list.indexOf(record.id) is -1
      
    if Gallery.record
      Album.trigger('destroy:join', albums,  Gallery.record)
    else
      for album in albums
        gas = GalleriesAlbum.filter(album.id, key: 'album_id')
        for ga in gas
          gallery = Gallery.exists(ga.gallery_id)
          # find all photos in album
          photos = AlbumsPhoto.photos(album.id)
          Spine.Ajax.disable ->
            Photo.trigger('destroy:join', photos, album)
          Spine.Ajax.disable ->
            Album.trigger('destroy:join', album, gallery) if gallery

      for album in albums
        Gallery.removeFromSelection album.id
        album.destroy()

  createAlbum: (albums, target=Gallery.record) ->
    if target
      @createJoin(albums, target)
  
  createJoin: (albums, target=Gallery.record) ->
    console.log 'AlbumsView::createJoin'
#    return unless target and target.constructor.className is 'Gallery'

    for album in albums
      album.createJoin target if target
      
    Album.trigger('activate', [album.id])
    
  destroyJoin: (albums, target) ->
    return unless target and target.constructor.className is 'Gallery'

    for album in albums
      album.destroyJoin target
      
  loadingStart: (album) ->
    el = @items.children().forItem(album)
    el.addClass('loading')
    unless el.data()['queue']
      queue = el.data()['queue'] = []
      queue.push {}
    else
      queue = el.data()['queue']
      queue.push {}
    
  loadingDone: (album) ->
    el = @items.children().forItem(album)
    el.data().queue?.splice(0, 1)
    el.removeClass('loading') unless el.data().queue?.length
    
  sortupdate: (e, item) ->
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
        
#    @list.exposeSelection()
    
module?.exports = AlbumsView