Spine ?= require("spine")
$      = Spine.$

class AlbumsView extends Spine.Controller
  
  @extend Spine.Controller.Drag
  
  elements:
    '.hoverinfo'                      : 'infoEl'
    '.items'                          : 'items'
    
  events:
    'dragstart  .items .thumbnail'    : 'dragstart'
    'dragover   .items'               : 'dragover'
    'drop       .items'               : 'drop'
    
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
    @header.template = @headerTemplate
    @filterOptions =
      key:'gallery_id'
      joinTable: 'GalleriesAlbum'
      sorted: true
#      joinTableItems: (query, options) -> Spine.Model['GalleriesAlbum'].filter(query, options)
    Spine.bind('show:albums', @proxy @show)
    Spine.bind('create:album', @proxy @create)
    Spine.bind('destroy:album', @proxy @destroy)
    Spine.bind('change:selectedGallery', @proxy @changeSelection)
    Album.bind('ajaxError', Album.errorHandler)
    Album.bind('destroy:join', @proxy @destroyJoin)
    Album.bind('create:join', @proxy @createJoin)
    Album.bind('update destroy', @proxy @change)
    Album.bind('destroy', @proxy @clearCache)
    GalleriesAlbum.bind("change", @proxy @change)
    GalleriesAlbum.bind('change', @proxy @renderHeader)
    Spine.bind('change:selectedGallery', @proxy @renderHeader)
    Gallery.bind('refresh change', @proxy @renderHeader)
    $(@views).queue('fx')
    
  change: (item, mode) ->
    console.log 'AlbumsView::change'
    return if mode is 'update'
    # item can be gallery         from Spine.bind 'change:selectedGallery'
    # item can be album           from Album.bind 'change'
    # item can be GalleriesAlbum  from GalleriesAlbum.bind 'change'
    @gallery = gallery = Gallery.record
    
    
    if item.constructor.className is 'GalleriesAlbum' and item.destroyed
      Spine.trigger('show:albums')
        
    if (!gallery) or (gallery.destroyed)
      @current = Album.filter()
    else
      @current = Album.filterRelated(gallery.id, @filterOptions)
      
    @render @current
    
  changeSelection: (item, changed) ->
    @change item if changed# or !!@pending
     
  render: (items) ->
    console.log 'AlbumsView::render'
#    return unless @isActive()
    itm = []
    for it in items
      itm.push it.title
      
    list = @list.render items
    list.Html5Sortable 'album'# if Gallery.record
    @header.render()

    # when Album is deleted in Photos View return to this View
    if items and items.constructor.className is 'GalleriesAlbum' and item.destroyed
      @show()
      
    Spine.trigger('render:galleryAllSublist')
    Spine.trigger('album:activate')
    
  renderHeader: ->
    console.log 'AlbumsView::renderHeader'
    @header.change Gallery.record
    
  clearCache: (album) ->
    album.clearCache()
  
  show: ->
    Spine.trigger('change:canvas', @)
    Spine.trigger('change:toolbarOne', ['Views', 'Default'])
    Spine.trigger('album:activate')
    
  newAttributes: ->
    if User.first()
      title   : 'New Title'
      user_id : User.first().id
      order: Album.all().length
    else
      User.ping()
  
  create: (e) ->
    console.log 'AlbumsView::create'
    @show()
    album = new Album @newAttributes()
    album.save success: @createCallback
    Gallery.updateSelection [album.id]
    Album.current(album)
    @change album
    @openPanel('album', App.showView.btnAlbum)

  createCallback: ->
    Album.trigger('create:join', Gallery.record, @) if Gallery.record

  destroy: (e) ->
    console.log 'AlbumsView::destroy'
    list = Gallery.selectionList().slice(0)
    albums = []
    Album.each (record) =>
      albums.push record unless list.indexOf(record.id) is -1
      
    if Gallery.record
      Gallery.emptySelection()
      Album.trigger('destroy:join', Gallery.record, albums)
    else
      for album in albums
        gas = GalleriesAlbum.filter(album.id, key: 'album_id')
        for ga in gas
          gallery = Gallery.find(ga.gallery_id) if Gallery.exists(ga.gallery_id)
          # find all photos in album
          photos = AlbumsPhoto.photos(album.id)
          Spine.Ajax.disable ->
            Photo.trigger('destroy:join', album, photos)
          Spine.Ajax.disable ->
            Album.trigger('destroy:join', gallery, album) if gallery
            
      for album in albums
        Gallery.removeFromSelection album.id
        album.destroy()

  createJoin: (target, albums) ->
    console.log 'AlbumsView::createJoin'
    
    return unless target and target.constructor.className is 'Gallery'

    unless Album.isArray albums
      records = []
      records.push(albums)
    else records = albums

    for record in records
      ga = new GalleriesAlbum
        gallery_id  : target.id
        album_id    : record.id
        order       : GalleriesAlbum.next()
      ga.save()
  
  destroyJoin: (target, albums) ->
    return unless target and target.constructor.className is 'Gallery'

    unless Album.isArray albums
      records = []
      records.push(albums)
    else records = albums

    albums = Album.toID(records)

    gas = GalleriesAlbum.filter(target.id, @filterOptions)
    for ga in gas
      unless albums.indexOf(ga.album_id) is -1
        Gallery.removeFromSelection ga.album_id
        ga.destroy()
    
#    target.save()

module?.exports = AlbumsView