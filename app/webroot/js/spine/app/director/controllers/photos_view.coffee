Spine ?= require("spine")
$      = Spine.$

class PhotosView extends Spine.Controller
  
  @extend Spine.Controller.Drag
  
  elements:
    '.preview'      : 'previewEl'
    '.items'        : 'items'
  
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
    
  template: (items) ->
    $('#photosTemplate').tmpl(items)
    
  preloaderTemplate: ->
    $('#preloaderTemplate').tmpl()
    
  headerTemplate: (items) ->
    items.gallery = Gallery.record
    $("#headerAlbumTemplate").tmpl items
    
  previewTemplate: (item) ->
    $('#photoPreviewTemplate').tmpl item
    
  constructor: ->
    super
    @preview = new Preview
      el: @previewEl
      template: @previewTemplate
    @list = new PhotoList
      el: @items
      template: @template
      preview: @preview
      slider: @parent
    AlbumsPhoto.bind('beforeDestroy beforeCreate', @proxy @emptyCache)
    Photo.bind('beforeDestroy beforeCreate', @proxy @emptyCache)
    AlbumsPhoto.bind('beforeDestroy beforeCreate', @proxy @emptyCache)
    AlbumsPhoto.bind('change', @proxy @renderHeader)
    AlbumsPhoto.bind('destroy', @proxy @remove)
    AlbumsPhoto.bind('create', @proxy @add)
    Album.bind('change', @proxy @renderHeader)
    Spine.bind('change:selectedAlbum', @proxy @renderHeader)
    Spine.bind('destroy:photo', @proxy @destroy)
    Spine.bind('show:photos', @proxy @show)
    Spine.bind('change:selectedAlbum', @proxy @change)
    Photo.bind('refresh', @proxy @prepareJoin)
    Photo.bind('destroy', @proxy @remove)
    Photo.bind("create:join", @proxy @createJoin)
    Photo.bind("destroy:join", @proxy @destroyJoin)
    Gallery.bind('change', @proxy @renderHeader)
#    @initSelectable()
      
  change: (item) ->
    filterOptions =
      key: 'album_id'
      joinTable: 'AlbumsPhoto'
      
    items = Photo.filter(item?.id, filterOptions)
    
    @current = item
    @render items
    
  render: (items, mode) ->
    console.log 'PhotosView::render'
    
    if Album.record
      @el.data Album.record
    else
      @el.removeData()
    
    @items.empty() unless @list.children('li').length
    # show spinner
#      @items.html @preloaderTemplate()
    
    @list.render items, mode or 'html'
    @refreshElements()
  
  renderHeader: ->
    console.log 'PhotosView::renderHeader'
    values =
      record: Album.record
      count: AlbumsPhoto.filter(Album.record?.id, key: 'album_id').length
    @header.html @headerTemplate values
  
  # after albumsphoto jointable has been changed by delete or create trash the cache and rebuild it the next time
  # could be in any controller that listens to AlbumsPhoto - may be move to app?
  emptyCache: (record, mode) ->
    switch record.constructor.className
      when 'Photo'
        # get related albums
        aps = AlbumsPhoto.filter(record.id, 'photo_id')
        for ap in aps
          Album.emptyCache ap.album_id
      when 'AlbumsPhoto'
        Album.emptyCache record.album_id
      
  # for AlbumsPhoto & Photo
  remove: (record) ->
    console.log 'PhotosView::remove'
    return unless record.destroyed
    photo = (Photo.find(record.photo_id) if Photo.exists(record.photo_id)) or record
    
    if photo
      photoEl = @items.children().forItem(photo, true)
      photoEl.remove()
      
#      start the 'real' rendering
    @render [] unless @items.children().length
    
  add: (ap) ->
    console.log 'PhotosView::add'
    photo = Photo.find(ap.photo_id)
    @render [photo], 'append'

  
  destroy: (e) ->
    console.log 'PhotosView::destroy'
    list = Album.selectionList().slice(0)
    
    photos = []
    Photo.each (record) =>
      photos.push record unless list.indexOf(record.id) is -1
      
    if Album.record
      Album.emptySelection()
      Photo.trigger('destroy:join', Album.record, photos)
    else
      # clean up joins first
      for photo in photos
        # 
        # we can destroy the join without telling the server
        # as long as cakephp handles photo HABTM as unique (default)
        # 
        # so the server-side join is automatically
        # removed upon photo deletion in the next step
        #
        aps = AlbumsPhoto.filter(photo.id, key: 'photo_id')
        for ap in aps
          album = Album.find(ap.album_id)
          Spine.Ajax.disable ->
            Photo.trigger('destroy:join', album, photo)
            
      # now remove photo originals
      for photo in photos
        Photo.removeFromSelection(Album, photo.id)
        photo.destroy()
    
  show: ->
    return if @isActive()
    @renderHeader()
    Spine.trigger('change:canvas', @)
  
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

    aps = AlbumsPhoto.filter(target.id, key: 'album_id')
    for ap in aps
      unless photos.indexOf(ap.photo_id) is -1
        Photo.removeFromSelection Album, ap.photo_id
        ap.destroy()

    target.save()
    
module?.exports = PhotosView