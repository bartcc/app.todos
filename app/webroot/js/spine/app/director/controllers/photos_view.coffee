Spine ?= require("spine")
$      = Spine.$

class PhotosView extends Spine.Controller
  
  @extend Spine.Controller.Drag
  
  elements:
    '.hoverinfo'      : 'infoEl'
    '.items'          : 'items'
  
  events:
    'dragstart  .items .thumbnail'    : 'dragstart'
    
  template: (items) ->
    $('#photosTemplate').tmpl(items)
    
  preloaderTemplate: ->
    $('#preloaderTemplate').tmpl()
    
  headerTemplate: (items) ->
    $("#headerPhotosTemplate").tmpl items
    
  infoTemplate: (item) ->
    $('#photoInfoTemplate').tmpl item
    
  constructor: ->
    super
    @el.data current: Album
    @info = new Info
      el: @infoEl
      template: @infoTemplate
    @list = new PhotosList
      el: @items
      template: @template
      info: @info
      parent: @parent
    @header.template = @headerTemplate
    Photo.bind('refresh', @proxy @refresh)
    Photo.bind('destroy', @proxy @remove)
    Photo.bind("create:join", @proxy @createJoin)
    Photo.bind("destroy:join", @proxy @destroyJoin)
    Photo.bind("ajaxError", Photo.errorHandler)
    AlbumsPhoto.bind('beforeDestroy beforeCreate', @proxy @clearAlbumCache)
    AlbumsPhoto.bind('change', @proxy @renderHeader)
    AlbumsPhoto.bind('destroy', @proxy @remove)
    AlbumsPhoto.bind('create', @proxy @add)
    Album.bind('change', @proxy @renderHeader)
    Spine.bind('change:selectedGallery', @proxy @renderHeader)
    Spine.bind('change:selectedAlbum', @proxy @renderHeader)
    Spine.bind('destroy:photo', @proxy @destroy)
    Spine.bind('show:photos', @proxy @show)
    Spine.bind('change:selectedAlbum', @proxy @change)
    Gallery.bind('change', @proxy @renderHeader)
      
  change: (item, changed) ->
    filterOptions =
      key: 'album_id'
      joinTable: 'AlbumsPhoto'
      
    items = Photo.filter(item?.id, filterOptions)
    
    @current = item
    @render items
    
  render: (items, mode) ->
    console.log 'PhotosView::render'
    
    @items.empty() unless @list.children('li').length
    # show spinner
#      @items.html @preloaderTemplate()
    
    list = @list.render items, mode or 'html'
    list.sortable 'photo' if Album.record
    @refreshElements()
  
  renderHeader: ->
    console.log 'PhotosView::renderHeader'
    @header.change Album.record
  
  clearPhotoCache: ->
    Photo.clearCache()
  
  # after albumsphoto jointable has been changed by delete or create trash the cache and rebuild it the next time
  # could be in any controller that listens to AlbumsPhoto - may be move to app?
  clearAlbumCache: (record) ->
    Album.clearCache record.album_id

  # for AlbumsPhoto & Photo
  remove: (record) ->
    console.log 'PhotosView::remove'
    return unless record.destroyed
    photo = (Photo.find(record.photo_id) if Photo.exists(record.photo_id)) or record
    
    if photo
      photoEl = @items.children().forItem(photo, true)
      photoEl.remove()
#      photo.removeFromCache()
      
#      start the 'real' rendering
    @render [] unless @items.children().length
    
  add: (ap) ->
    console.log 'PhotosView::add'
    # only add when photo is for it's album
    if ap.album_id is Album.record?.id
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
        Album.removeFromSelection photo.id
        photo.destroy()
    
  show: ->
    return if @isActive()
    Album.activeRecord = Album.record
#    Spine.trigger('change:selectedAlbum', Album.record, true)
    Spine.trigger('gallery:activate', Gallery.record)
    Spine.trigger('change:toolbarOne', ['Photos'], App.showView.initSlider)
    Spine.trigger('change:canvas', @)
    @renderHeader()
  
  save: (item) ->

  refresh: (photos) ->
    @clearPhotoCache()
    if Album.record
      @createJoin Album.record, photos
    else
      @render photos
  
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
        Album.removeFromSelection ap.photo_id
        ap.destroy()

    target.save()
    
module?.exports = PhotosView