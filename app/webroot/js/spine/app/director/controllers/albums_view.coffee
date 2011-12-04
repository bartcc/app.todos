Spine ?= require("spine")
$      = Spine.$

class AlbumsView extends Spine.Controller
  
  @extend Spine.Controller.Drag
  
  elements:
    '.preview'                : 'previewEl'
    '.items'                  : 'items'
    '.content .sortable'      : 'sortable'
    
  events:
    'sortupdate .items .item'         : 'sortupdate'
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
 
  previewTemplate: (item) ->
    $('#albumPreviewTemplate').tmpl item
 
  constructor: ->
    super
    @preview = new Preview
      el: @previewEl
      template: @previewTemplate
    @list = new AlbumList
      el: @items
      template: @albumsTemplate
      preview: @preview
    Album.bind("ajaxError", Album.errorHandler)
    Spine.bind('create:album', @proxy @create)
    Spine.bind('destroy:album', @proxy @destroy)
    Album.bind("destroy:join", @proxy @destroyJoin)
    Album.bind("create:join", @proxy @createJoin)
    Album.bind("update destroy", @proxy @change)
    Spine.bind('change:selectedGallery', @proxy @change)
    Spine.bind('show:albums', @proxy @show)
    GalleriesAlbum.bind("change", @proxy @change)
    GalleriesAlbum.bind('change', @proxy @renderHeader)
    Spine.bind('change:selectedGallery', @proxy @renderHeader)
    #interferes with html5 dnd!
#    @initSortables
#      helper: 'clone'
    @filterOptions =
      key:'gallery_id'
      joinTable: 'GalleriesAlbum'
    $(@views).queue("fx")

  children: (sel) ->
    @el.children(sel)

  change: (item) ->
    console.log 'AlbumsView::change'
    # item can be gallery         from Spine.bind 'change:selectedGallery'
    # item can be album           from Album.bind 'change'
    # item can be GalleriesAlbum  from GalleriesAlbum.bind 'change'
    gallery = Gallery.record 
    
    if (!gallery) or (gallery.destroyed)
      @current = Album.filter()
    else
      @current = Album.filter(gallery.id, @filterOptions)
      
    @render(item)
    
  render: (item) ->
    console.log 'AlbumsView::render'
      
    if Gallery.record
      @el.data Gallery.record
    else
      @el.removeData()
      
    @list.render @current
    # when Album is deleted in Photos View return to this View
    if item and item.constructor.className is 'GalleriesAlbum' and item.destroyed
      @show()
      
    Spine.trigger('render:galleryItem')
    Spine.trigger('album:exposeSelection')
    
   
  renderHeader: ->
    console.log 'AlbumsView::renderHeader'
    values =
      record: Gallery.record
      count: GalleriesAlbum.filter(Gallery.record?.id, @filterOptions).length
    @header.html @headerTemplate values
  
  show: ->
    @parent.trigger('change:toolbar', Album)
    Spine.trigger('change:canvas', @)
    
  initSortables: ->
    dragOptions =
      helper: 'clone'
    @items.draggable dragOptions

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
    Spine.trigger('change:selectedAlbum', album)
    Spine.trigger('show:albums')
    @openPanel('album', App.showView.btnAlbum)

  destroy: (e) ->
    console.log 'AlbumsView::destroy'
    list = Gallery.selectionList().slice(0)
    albums = []
    Album.each (record) =>
      albums.push record unless list.indexOf(record.id) is -1
      
    if Gallery.record
      console.log Gallery.record
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

    gas = GalleriesAlbum.filter(target.id, @filterOptions)
    for ga in gas
      unless albums.indexOf(ga.album_id) is -1
        Album.removeFromSelection Gallery, ga.album_id
        ga.destroy()

    target.save()

  email: ->
    return if ( !@current.email ) 
    window.location = "mailto:" + @current.email

    
module?.exports = AlbumsView