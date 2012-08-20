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
      parent: @
    @header.template = @headerTemplate
    @filterOptions =
      key:'gallery_id'
      joinTable: 'GalleriesAlbum'
      sorted: true
#      joinTableItems: (query, options) -> Spine.Model['GalleriesAlbum'].filter(query, options)
    Spine.bind('show:albums', @proxy @show)
    Spine.bind('create:album', @proxy @create)
#    Album.bind('create', @proxy @createJoin)
    Spine.bind('destroy:album', @proxy @destroy)
    Album.bind('ajaxError', Album.errorHandler)
    Album.bind('destroy:join', @proxy @destroyJoin)
    Album.bind('create:join', @proxy @createJoin)
    Album.bind('update destroy', @proxy @change)
    GalleriesAlbum.bind('change', @proxy @renderHeader)
    Spine.bind('change:selectedGallery', @proxy @change)
    Spine.bind('change:selectedGallery', @proxy @renderHeader)
    Gallery.bind('refresh change', @proxy @renderHeader)
    $(@views).queue('fx')
    
  # this method is triggered when changing Gallery.record
  change: (item, changed) ->
  
#    alert mode if mode
    console.log 'AlbumsView::change'
    # !important
    return if @isActive() and !changed
  
#    return unless Album.contains()
    
    # item can be gallery         from Spine.bind 'change:selectedGallery'
    # item can be album           from Album.bind 'change'
    # item can be GalleriesAlbum  from GalleriesAlbum.bind 'change'
    gallery = Gallery.record
    
    
    if item.constructor.className is 'GalleriesAlbum' and item.destroyed
      @navigate '/gallery', gallery?.id
        
    if (!gallery) or (gallery.destroyed)
      items = Album.filter()
    else
      items = Album.filterRelated(gallery.id, @filterOptions)
      
    @render items
    
  render: (items, mode) ->
    console.log 'AlbumsView::render'

    
    list = @list.render items, mode
    list.sortable 'album' #if Gallery.record
    @header.render()

    # when Album is deleted in Photos View return to this View
    if items and items.constructor.className is 'GalleriesAlbum' and item.destroyed
      @show()
      
  renderHeader: ->
    console.log 'AlbumsView::renderHeader'
    @header.change Gallery.record
  
  show: (force) ->
    Spine.trigger('album:activate')
    App.showView.trigger('change:toolbarOne', ['Default'])
    App.showView.trigger('change:toolbarTwo', ['Slideshow'])
    App.showView.trigger('canvas', @)
    albums = GalleriesAlbum.albums(Gallery.record.id)
    for alb in albums
      if alb.invalid
#        @list.refreshBackgrounds alb
        alb.invalid = false
        alb.save(ajax:false)
    
  newAttributes: ->
    if User.first()
      title   : 'New Album'
      invalid : false
      user_id : User.first().id
      order   : Album.count()
    else
      User.ping()
  
  create: (e) ->
    console.log 'AlbumsView::create'
    album = new Album @newAttributes()
    album.save success: @createCallback

  createCallback: ->
    # in album context!
    console.log 'AlbumsView::createCallback'
    return unless Gallery.record
    @createJoin(Gallery.record)
#    alert 'Plese check createCallback' unless Album.record.id
#    Gallery.updateSelection [Album.record.id]
#    
#    Album.trigger('create:join', Gallery.record, @) if Gallery.record
#    Gallery.updateSelection [@id]
#    Spine.trigger('album:activate')

  destroy: ->
    console.log 'AlbumsView::destroy'
    list = Gallery.selectionList().slice(0)
    console.log list
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
          gallery = Gallery.find(ga.gallery_id) if Gallery.exists(ga.gallery_id)
          # find all photos in album
          photos = AlbumsPhoto.photos(album.id)
          Spine.Ajax.disable ->
            Photo.trigger('destroy:join', photos, album)
          Spine.Ajax.disable ->
            Album.trigger('destroy:join', album, gallery) if gallery
            
      for album in albums
        Gallery.removeFromSelection album.id
        album.destroy()

  createJoin: (albums=[], target=Gallery.record) ->
    
    console.log 'create join'
    return unless target

    for album in albums
      console.log album
      console.log target
      album.createJoin target
    
    return
    
    unless Album.isArray albums
      albums = [].push(albums)

    console.log albums
    
    return unless albums.length
    
    for album in albums
      console.log album
      ga = new GalleriesAlbum
        gallery_id  : target.id
        album_id    : album.id
        order       : GalleriesAlbum.next()
      ga.save()
  
  destroyJoin: (albums, target) ->
    console.log albums
    console.log target
    return unless target and target.constructor.className is 'Gallery'

    return unless target

    for album in albums
      alert 'destroy join'
      album.destroyJoin target
    
    return
    

    unless Album.isArray albums
      records = []
      records.push(albums)
    else records = albums

    albums = Album.toID(records)

    gas = GalleriesAlbum.filter(target.id, @filterOptions)
    for ga in gas
      unless albums.indexOf(ga.album_id) is -1
        Gallery.removeFromSelection ga.album_id
        ga.destroy success: @proxy @cb
    
  cb: ->
#    target.save()

module?.exports = AlbumsView