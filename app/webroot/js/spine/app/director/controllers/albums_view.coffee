Spine ?= require("spine")
$      = Spine.$

class AlbumsView extends Spine.Controller
  
  @extend Spine.Controller.Drag
#  @extend Spine.Controller.Toolbars
  
  elements:
    '.items'                  : 'items'
    '.content .sortable'      : 'sortable'
    '.header'                 : 'header'
    
  events:
    'sortupdate .items'               : 'sortupdate'
    'dragstart  .items .thumbnail'    : 'dragstart'
    'dragenter  .items .thumbnail'    : 'dragenter'
    'dragover   .items .thumbnail'    : 'dragover'
    'drop       .items .thumbnail'    : 'drop'
    'dragend    .items .thumbnail'    : 'dragend'
    'dragenter'                       : 'dragenter'
    'dragover'                        : 'dragover'
    'drop'                            : 'drop'
    'dragend'                         : 'dragend'

  albumsTemplate: (items, options) ->
    $("#albumsTemplate").tmpl items, options

#  toolsTemplate: (items) ->
#    $("#toolsTemplate").tmpl items
#
  headerTemplate: (items) ->
    $("#headerGalleryTemplate").tmpl items
 
  constructor: ->
    super
    @list = new AlbumList
      el: @items
      template: @albumsTemplate
      
    Album.bind("ajaxError", Album.errorHandler)
    Spine.bind('create:album', @proxy @create)
    Spine.bind('destroy:album', @proxy @destroy)
    Album.bind("destroy:join", @proxy @destroyJoin)
    Album.bind("create:join", @proxy @createJoin)
    Album.bind("update", @proxy @render)
    Album.bind("destroy", @proxy @render)
    Spine.bind('change:selectedGallery', @proxy @change)
    Spine.bind('show:albums', @proxy @show)
    GalleriesAlbum.bind("change", @proxy @render)
    @bind("render:header", @proxy @renderHeader)
    
    @show = @showGallery

    $(@views).queue("fx")

  children: (sel) ->
    @el.children(sel)

  change: (item, mode) ->
    console.log 'AlbumsView::change'
    @current = item
    @render()
    
  render: (items, mode) ->
    console.log 'AlbumsView::render'
    
    if (!@current) or (@current.destroyed)
      items = Album.filter()
    else
      items = Album.filter(@current.id)
    
    @el.data Gallery.record or {}
    @list.render items
    Spine.trigger('render:galleryItem')
    Spine.trigger('album:exposeSelection')
    @trigger('render:header', items)
    
    #@initSortables() #interferes with html5 dnd!
   
  renderHeader: (items) ->
    console.log 'AlbumsView::renderHeader'
    values = {record: Gallery.record, count: items.length}
    @header.html @headerTemplate values
  
  show: ->
    Spine.trigger('change:canvas', @)
    
  initSortables: ->
    sortOptions = {}
    @items.sortable sortOptions

  newAttributes: ->
    if User.first()
      title   : 'New Title'
      user_id : User.first().id
    else
      User.ping()
  
  create: (e) ->
    console.log 'AlbumsView::create'
    Gallery.emptySelection()
    album = new Album @newAttributes()
    album.save()
    Gallery.updateSelection [album.id]
    @render album
    Album.trigger('create:join', Gallery.record, album) if Gallery.record
    @openPanel('album', App.showView.btnAlbum)

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
        if Album.exists(album.id)
          Album.removeFromSelection(Gallery, album.id)
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
        gallery_id: target.id
        album_id: record.id
      ga.save()

    target.save()
  
  destroyJoin: (target, albums) ->
    return unless target and target.constructor.className is 'Gallery'

    unless Album.isArray albums
      records = []
      records.push(albums)
    else records = albums

    albums = Album.toID(records)

    gas = GalleriesAlbum.filter(target.id)
    for ga in gas
      unless albums.indexOf(ga.album_id) is -1
        Album.removeFromSelection Gallery, ga.album_id
        ga.destroy()

    target.save()

  email: ->
    return if ( !@current.email ) 
    window.location = "mailto:" + @current.email

    
module?.exports = AlbumsView