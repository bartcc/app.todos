Spine ?= require("spine")
$      = Spine.$

class PhotosView extends Spine.Controller
  
  @extend Spine.Controller.Drag
  
  elements:
    '.items'        : 'items'
  
  events:
    'dragstart  .items .thumbnail'    : 'dragstart'
    'dragenter  .items .thumbnail'    : 'dragenter'
    'dragover   .items .thumbnail'    : 'dragover'
    'drop       .items .thumbnail'    : 'drop'
    'dragend    .items .thumbnail'    : 'dragend'
    'dragenter'                       : 'dragenter'
    'dragover'                        : 'dragover'
    'drop'                            : 'drop'
    'dragend'                         : 'dragend'
    
  template: (items) ->
    $('#photosTemplate').tmpl(items)
    
  preloaderTemplate: ->
    $('#preloaderTemplate').tmpl()
    
  headerTemplate: (items) ->
    items.gallery = Gallery.record
    $("#headerAlbumTemplate").tmpl items
    
  constructor: ->
    super
    @list = new PhotoList
      el: @items
      template: @template
    AlbumsPhoto.bind('beforeDestroy beforeCreate', @changed)
    Photo.bind('refresh', @proxy @prepareJoin)
    Spine.bind('destroy:photo', @proxy @destroy)
    Spine.bind('show:photos', @proxy @show)
    Spine.bind('change:selectedAlbum', @proxy @change)
    Photo.bind("create:join", @proxy @createJoin)
    Photo.bind("destroy:join", @proxy @destroyJoin)
    @bind("render:header", @proxy @renderHeader)
    
  change: (item) ->
    @current = item or Album.record
    # if the album has been moved outside the gallery kill current album and render all photos
    unless GalleriesAlbum.galleryHasAlbum Gallery.record.id, Album.record.id
      Album.record = false
      App.showView.trigger('render:toolbar')
      
    items = Photo.filter(item?.id)
    
    @render items
    
  render: (items) ->
    console.log 'PhotosView::render'
    album = Album.record
    if album then @el.data album else delete @el.data
    # show spinner
    @items.html @preloaderTemplate()
    
    @list.render items, album
    @refreshElements()
    @trigger('render:header', items)
  
  renderHeader: (items) ->
    console.log 'PhotosView::renderHeader'
    values = {record: Album.record, count: items.length}
    @header.html @headerTemplate values
  
  # could be in any controller that listens to AlbumsPhoto - may be move to app?
  changed: (record, mode) ->
    Album.emptyCache record.album_id
  
  destroy: (e) ->
    console.log 'PhotosView::destroy'
    list = Album.selectionList().slice(0)
    
    photos = []
    Photo.each (record) =>
      photos.push record unless list.indexOf(record.id) is -1
      
    if Album.record
      Album.emptySelection()
      Spine.trigger('destroy:photoJoin', Album.record, photos)
    else
      for photo in photos
        if Photo.exists(photo.id)
          Photo.removeFromSelection(Album, photo.id)
          photo.destroy()
    
  show: -> Spine.trigger('change:canvas', @)
  
  save: (item) ->

  prepareJoin: (photos) ->
    @createJoin Album.record, photos
  
  createJoin: (target, photos) ->
    console.log 'PhotosView::createJoin'
    return unless target and target.constructor.className is 'Album'
    
    unless Photo.isArray photos
      records = []
      records.push(photos)
    else records = photos

    for record in records
      ap = new AlbumsPhoto
        album_id: target.id
        photo_id: record.id
      ap.save()
      
    target.save()
  
  destroyJoin: (target, photos) ->
    console.log 'PhotosView::destroyJoin'
    return unless target and target.constructor.className is 'Album'

    unless Photo.isArray photos
      records = []
      records.push(photos)
    else records = photos

    photos = Photo.toID(records)

    aps = AlbumsPhoto.filter(target.id)
    for ap in aps
      unless photos.indexOf(ap.photo_id) is -1
        Photo.removeFromSelection Album, ap.photo_id
        ap.destroy()

    target.save()

module?.exports = PhotosView