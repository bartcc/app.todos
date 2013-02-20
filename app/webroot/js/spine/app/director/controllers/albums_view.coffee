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
    Spine.bind('show:allAlbums', @proxy @renderAll)
    Spine.bind('create:album', @proxy @create)
    Album.bind('create', @proxy @createJoin)
    Spine.bind('destroy:album', @proxy @destroy)
    Album.bind('ajaxError', Album.errorHandler)
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
    return if (item.constructor.className is 'GalleriesAlbum') and (changed is 'update')
#    return unless changed
#    return unless @isActive()
    # !important
#    return unless @isActive()

    items = Album.filterRelated(Gallery.record.id, @filterOptions)
      
    unless Gallery.record
      @renderAll()
    else
      @render items
    
  renderAll: ->
    App.showView.canvasManager.change @
    @render Album.filter()
    @el
    
  render: (items, mode) ->
    console.log 'AlbumsView::render'

    
    list = @list.render items, mode
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
    @list.exposeSelection()
    albums = GalleriesAlbum.albums(Gallery.record.id)
    for alb in albums
      if alb.invalid
#        @list.refreshBackgrounds alb
        alb.invalid = false
        alb.save(ajax:false)
    
  newAttributes: ->
    if User.first()
      title   : 'new'
      invalid : false
      user_id : User.first().id
      order   : Album.count()
    else
      User.ping()
  
  create: (list=[], options) ->
    console.log 'AlbumsView::create'
    
    # creates an new album with photos
    # argument can be an array of photos
    cb = ->
      @createJoin(Gallery.record) if Gallery.record
      Photo.trigger('create:join', list, @)
      Photo.trigger('destroy:join', list, options['origin']) if options?.origin?
        
    album = new Album @newAttributes()
    album.save(success: cb) #
      
    if Gallery.record
      App.navigate '/gallery', Gallery.record.id
      
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

  createJoin: (albums, target=Gallery.record) ->
    return unless target and target.constructor.className is 'Gallery'

    for album in albums
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
        
    @list.exposeSelection()
    
module?.exports = AlbumsView