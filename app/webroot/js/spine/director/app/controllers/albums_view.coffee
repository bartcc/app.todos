Spine           = require("spine")
$               = Spine.$
Controller      = Spine.Controller
Drag            = require("plugins/drag")
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
    Album.bind('create destroy', @proxy @change)
    Spine.bind('destroy:album', @proxy @destroy)
    Album.bind('ajaxError', Album.errorHandler)
#    GalleriesAlbum.bind('ajaxError', Album.errorHandler)
    Album.bind('destroy:join', @proxy @destroyJoin)
    Album.bind('create:join', @proxy @createJoin)
    GalleriesAlbum.bind('change', @proxy @renderHeader)
    Spine.bind('change:selectedGallery', @proxy @change)
    Spine.bind('change:selectedGallery', @proxy @renderHeader)
    Gallery.bind('refresh change', @proxy @renderHeader)
    Spine.bind('loading:start', @proxy @loadingStart)
    Spine.bind('loading:done', @proxy @loadingDone)
    
    Album.bind('sortupdate', @proxy @sortupdate)
    GalleriesAlbum.bind('destroy', @proxy @sortupdate)
    
    $(@views).queue('fx')
    
  # this method is triggered when changing Gallery.record
  change: (item, changed) ->
    console.log 'AlbumsView::change'
    
    # ommit a complete rendering on resorting
    # on anything else it's ok
    return if (item.constructor.className is 'GalleriesAlbum') and (changed is 'update') or !item
#    return unless changed
#    return unless @isActive()
    # !important
#    return unless @isActive()

    @render()
    
  render: ->
    console.log 'AlbumsView::render'
    
    unless Gallery.record
      items = Album.filter()
    else
      items = Album.filterRelated(Gallery.record.id, @filterOptions)
    
    list = @list.render items
    list.sortable('album')
    
    @header.render()

    # when in Photos View the Album is deleted return to this View
    if items and items.constructor.className is 'GalleriesAlbum' and item.destroyed
      @show()
      
    @el
      
  renderHeader: ->
    console.log 'AlbumsView::renderHeader'
    @header.change Gallery.record
  
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
      title   : 'empty'
      invalid : false
      user_id : User.first().id
      order   : Album.count()
    else
      User.ping()
  
  create: (list=[], options) ->
    console.log 'AlbumsView::create'
    
    cb = ->
      @createJoin(Gallery.record) if Gallery.record
      
      # Have photos moved/copied to the new album
      Photo.trigger('create:join', list, @)
      Photo.trigger('destroy:join', list, options['origin']) if options?.origin?
        
    album = new Album @newAttributes()
    album.save(done: cb)
      
#    if Gallery.record
#      App.navigate '/gallery', Gallery.record.id
      
    Gallery.updateSelection [album.id]
    Spine.trigger('album:activate')
        
  destroy: ->
    console.log 'AlbumsView::destroy'
    list = Gallery.selectionList().slice(0)
    albums = []
    Album.each (record) =>
      albums.push record unless list.indexOf(record.id) is -1
      
    if Gallery.record
      Gallery.emptySelection()
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
      @createJoin(albums, target=Gallery.record)
    else
      @render Album.filter()
  
  createJoin: (albums, target=Gallery.record) ->
    return unless target and target.constructor.className is 'Gallery'

    for album in albums
      console.log 'joining ' + album.title + ' to ' + target.name
      album.createJoin target
      
    Spine.trigger('album:activate')
    
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