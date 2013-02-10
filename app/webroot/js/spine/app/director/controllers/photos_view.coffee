Spine ?= require("spine")
$      = Spine.$

class PhotosView extends Spine.Controller
  
  @extend Spine.Controller.Drag
  
  elements:
    '.hoverinfo'      : 'infoEl'
    '.items'          : 'items'
  
  events:
    'dragstart  .items .thumbnail'    : 'dragstart'
    'dragover   .items .thumbnail'    : 'dragover'
    
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
    AlbumsPhoto.bind('change', @proxy @renderHeader)
    AlbumsPhoto.bind('destroy', @proxy @remove)
    AlbumsPhoto.bind('create', @proxy @add)
    
    GalleriesAlbum.bind('destroy', @proxy @redirect)
    Gallery.bind('change', @proxy @renderHeader)
    Album.bind('change', @proxy @renderHeader)
    Photo.bind('refresh destroy', @proxy @renderHeader)
    Photo.bind('refresh', @proxy @refresh)
    Photo.bind('beforeDestroy', @proxy @remove)
    Photo.bind('create:join', @proxy @createJoin)
    Photo.bind('destroy:join', @proxy @destroyJoin)
    Photo.bind('ajaxError', Photo.errorHandler)
    Spine.bind('destroy:photo', @proxy @destroy)
    Spine.bind('show:photos', @proxy @show)
    Spine.bind('change:selectedAlbum', @proxy @renderHeader)
    Spine.bind('change:selectedAlbum', @proxy @change)
    Spine.bind('start:slideshow', @proxy @slideshow)
    Spine.bind('album:updateBuffer', @proxy @updateBuffer)
    Spine.bind('slideshow:ready', @proxy @play)
    
  change: (item, changed) ->
    @updateBuffer item if changed
    @render @buffer if @buffer
  
  updateBuffer: (album) ->
    filterOptions =
      key: 'album_id'
      joinTable: 'AlbumsPhoto'
      sorted: true
    
    @buffer = Photo.filterRelated(album?.id, filterOptions)
  
  render: (items, mode) ->
    console.log 'PhotosView::render'
    # render only if necessary
#    return unless @isActive()
      
    @items.empty() unless @list.children('li').length
    
#    items = if @parent.allAlbums
#      Album.filter()
#    else
#      Album.filterRelated(gallery.id, @filterOptions)
      
    list = @list.render items, mode
    list.sortable 'photo' #if Album.record
    delete @buffer
    
  
  renderHeader: ->
    console.log 'PhotosView::renderHeader'
    @header.change()
  
  clearPhotoCache: ->
    Photo.clearCache()
  
  # for AlbumsPhoto & Photo
  remove: (record) ->
    console.log 'PhotosView::remove'
    unless record.constructor.className is 'Photo'
      record = Photo.exists(record.photo_id)

    photoEl = @items.children().forItem(record, true)
    photoEl.remove()
#    @render [] unless @items.children().length

  redirect: (ga) ->
    @navigate '/gallery', Gallery.record.id if ga.destroyed
  
  next: (album) ->
    album.last()
  
  destroy: (e) ->
    console.log 'PhotosView::destroy'
    list = Album.selectionList().slice(0)
    
    photos = []
    Photo.each (record) =>
      photos.push record unless list.indexOf(record.id) is -1
      
    if Album.record
      Album.emptySelection()
      Photo.trigger('destroy:join', photos, Album.record)
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
          album = Album.exists(ap.album_id) 
          Spine.Ajax.disable ->
            Photo.trigger('destroy:join', photo, album) if album
            
      # now remove photo originals
      for photo in photos
        Album.removeFromSelection photo.id
        photo.destroyCache()
        photo.destroy()
    
  show: ->
#    Album.current(idOrRecord)
    App.showView.trigger('change:toolbarOne', ['Default', 'Slider', App.showView.initSlider])
    App.showView.trigger('change:toolbarTwo', ['Slideshow'])
    App.showView.trigger('canvas', @)
  
  save: (item) ->

  # methods after uplopad
  
  refresh: (photos) ->
    # do not use this to create album-photo joins anymore
    # use the real jointable callback instead
    return
    if Album.record
      # this will trigger the add method for handeling uploaded files
      @createJoin photos, Album.record
    else
      @render photos
    @renderHeader()
    
  refresh: (photos) ->
#    if Album.record
#      # this will trigger the add method for handeling uploaded files
#      @createJoin photos, Album.record
#    else
#      @render photos
    @renderHeader()
      
  add: (ap) ->
    console.log 'PhotosView::add'
    # only add when photo is for it's album
    if ap.album_id is Album.record?.id
      photo = Photo.exists(ap.photo_id)
      @render([photo], 'append') if photo
      
  createJoin: (photos, target) ->
    console.log 'PhotosView::createJoin'
    return unless target and target.constructor.className is 'Album'
    console.log target.id
    unless Photo.isArray photos
      records = []
      records.push(photos)
    else records = photos

    for record in records
      ap = new AlbumsPhoto
        album_id: target.id
        photo_id: record.id
        order: AlbumsPhoto.photos(target.id).length
      ap.save()
  
  destroyJoin: (photos, target) ->
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

#    target.save()
    
module?.exports = PhotosView