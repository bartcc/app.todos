Spine ?= require("spine")
$      = Spine.$

class PhotosView extends Spine.Controller
  
  @extend Spine.Controller.Drag
  
  elements:
    '.header'       : 'header'
    '.items'        : 'items'
  
  events:
    'dragstart  .items .thumbnail'    : 'dragstart'
    'dragenter  .items .thumbnail'    : 'dragenter'
    'dragover   .items .thumbnail'    : 'dragover'
    'drop       .items .thumbnail'    : 'drop'
    'dragend    .items .thumbnail'    : 'dragend'
    'dragenter'                       : 'dragenter'
    'dragover'                        : 'dragover'
#    'dragleave  #contents'              : 'dragleave'
    'drop'                            : 'drop'
    'dragend'                         : 'dragend'
    
  template: (items) ->
    $('#photosTemplate').tmpl(items)
    
  headerTemplate: (items) ->
    items.gallery = Gallery.record
    $("#headerAlbumTemplate").tmpl items
    
  constructor: ->
    super
    @list = new PhotoList
      el: @items
      template: @template
    Photo.bind('refresh', @proxy @createJoin)
    Spine.bind('destroy:photo', @proxy @destroy)
    Spine.bind('show:photos', @proxy @show)
    Spine.bind('change:selectedAlbum', @proxy @change)
    Spine.bind("create:photoJoin", @proxy @createJoin)
    Spine.bind("destroy:photoJoin", @proxy @destroyJoin)
    @bind("render:header", @proxy @renderHeader)
    
  change: (item) ->
    @current = item or Album.record
    items = Photo.filter(item?.id)
    
    @render items
    
  render: (items) ->
    console.log 'PhotosView::render'
    @el.data Album.record or {}
    
    @list.render items
    @refreshElements()
    @trigger('render:header', items)
  
  renderHeader: (items) ->
    console.log 'PhotosView::renderHeader'
    values = {record: Album.record, count: items.length}
    @header.html @headerTemplate values
  
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
    
  show: (album) ->
    #@change album
    Spine.trigger('change:canvas', @)
  
  save: (item) ->

  createJoin: (photos) ->
    console.log 'PhotosView::createJoin'
    return unless Album.record
    target = Album.record
    
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
  
  destroyJoin: (photos) ->
    console.log 'PhotosView::destroyJoin'
    return unless Album.record
    target = Album.record

    unless Photo.isArray photos
      records = []
      records.push(photos)
    else records = photos

    photos = Photo.toID(records)

    aps = AlbumsPhoto.filter(target.id)
    for ap in aps
      unless albums.indexOf(ap.album_id) is -1
        Photo.removeFromSelection Album, ap.photo_id
        ap.destroy()

    target.save()

  test: (e) =>
    console.log 'PhotosView::test'
    el = $(e.target)
    console.log el
    console.log el.item()
    console.log @el
    console.log @el.item()

module?.exports = PhotosView