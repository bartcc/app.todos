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
    console.log 'AlbumsView::change'
    # !important
    return if @isActive() and !changed
  
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
      
    Spine.trigger('album:activate')
      
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
  
  # creates new album
  # argument can be an array of photos
  create: (list) ->
    console.log 'AlbumsView::create'
    album = new Album @newAttributes()
    
    if list
      cb = =>
        album = Album.last()
        
        gallery = Gallery.record
        album.createJoin(gallery) if gallery
        Photo.trigger('create:join', list, album)
#        Album.trigger('create:join', album, Gallery.record) if Gallery.record
        
        if Gallery.record
          @navigate '/gallery', Gallery.record.id
        else
          @navigate '/gallery', null + '/' + album.id
          
        # make the new album active
        album.updateSelection [album.id]
        Spine.trigger('album:activate')
        
    else
      cb = ->
        @createJoin(Gallery.record) if Gallery.record
        # select first album
        album.updateSelection [@id]
        Spine.trigger('album:activate')
        App.navigate '/gallery', Gallery.record?.id + '/' + @id
        
    album.save success: cb

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
    return unless target and target.constructor.className is 'Gallery'

    for album in albums
      album.createJoin target
      
    Spine.trigger('album:activate')
    
  destroyJoin: (albums, target) ->
    return unless target and target.constructor.className is 'Gallery'

    for album in albums
      album.destroyJoin target
    
module?.exports = AlbumsView