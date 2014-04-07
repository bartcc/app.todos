Spine           = require("spine")
$               = Spine.$
Controller      = Spine.Controller
Album           = require('models/album')
Photo           = require('models/photo')
AlbumsPhoto     = require('models/albums_photo')
Gallery         = require('models/gallery')
GalleriesAlbum  = require('models/galleries_album')
Info            = require('controllers/info')
PhotosList      = require('controllers/photos_list')
Extender        = require("plugins/controller_extender")
Drag            = require("plugins/drag")

require("plugins/tmpl")

class PhotosView extends Spine.Controller
  
  @extend Extender
  
  elements:
    '.hoverinfo'      : 'infoEl'
    '.items'          : 'items'
  
  events:
    'click .item'                  : 'click'
    'sortupdate .items'            : 'sortupdate'
    
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
    @el.data('current',
      model: Album
      models: Photo
    )
    @type = 'Photo'
    @info = new Info
      el: @infoEl
      template: @infoTemplate
    @list = new PhotosList
      el: @items
      template: @template
      info: @info
      parent: @
    @header.template = @headerTemplate
    @viewport = @list.el
#    AlbumsPhoto.bind('destroy', @proxy @remove)
    GalleriesAlbum.bind('destroy', @proxy @backToAlbumView)
    Gallery.bind('create update destroy', @proxy @renderHeader)
    Album.bind('change', @proxy @renderHeader)
    Photo.bind('refresh', @proxy @change)
    Photo.bind('created', @proxy @add)
    Photo.bind('destroy', @proxy @destroy)
    Photo.bind('beforeDestroy', @proxy @beforeDestroy)
    Photo.bind('create:join', @proxy @createJoin)
    Photo.bind('destroy:join', @proxy @destroyJoin)
    Photo.bind('ajaxError', Photo.errorHandler)
    Photo.bind('activate', @proxy @activateRecord)
    AlbumsPhoto.bind('create update destroy', @proxy @renderHeader)
    Spine.bind('destroy:photo', @proxy @destroyPhoto)
    Spine.bind('show:photos', @proxy @show)
    Album.bind('current', @proxy @change)
    Spine.bind('loading:done', @proxy @updateBuffer)
    
  updateBuffer: (album=Album.record) ->
    filterOptions =
      key: 'album_id'
      joinTable: 'AlbumsPhoto'
      sorted: true
    
    if album
      items = Photo.filterRelated(album.id, filterOptions)
    else
      items = Photo.filter()
      
    @buffer = items
  
  change: (item) ->
    @updateBuffer()
    @render @buffer
  
  render: (items, mode) ->
    # render only if necessary
    return unless @isActive()
    console.log 'PhotosView::render'
    # if view is dirty but inactive we'll use the buffer next time
    list = @list.render(items || @updateBuffer(), mode)
    list.sortable('photo') if Album.record
    delete @buffer
  
  renderHeader: ->
    console.log 'PhotosView::renderHeader'
    @header.change()
  
  click: (e) ->
    console.log 'PhotosList::click'
    item = $(e.currentTarget).item()
    
    @select item, @isCtrlClick(e)
    App.showView.trigger('change:toolbarOne')
    
    e.stopPropagation()
    e.preventDefault()
  
  select: (items = [], exclusive) ->
    unless Spine.isArray items
      items = [items]
      
    items = items.toID()
    
    Album.emptySelection() if exclusive
    
    list = Album.selectionList()
    for id in items
      list.addRemoveSelection(id)
      
    Photo.trigger('activate', list)
  
    
  activateRecord: (list) ->
    unless Spine.isArray(list)
      list = [list]
        
    Album.updateSelection(list)
    Photo.current(list[0])
  
  clearPhotoCache: ->
    Photo.clearCache()
  
  beforeDestroy: (photo) ->
    Album.removeFromSelection photo.id
    photo.removeSelectionID()
    @list.findModelElement(photo).remove()
    
    aps = AlbumsPhoto.filter(photo.id, key: 'photo_id')
    for ap in aps
      @destroyJoin [photo.id], Album.exists aps.album_id
      
  destroyPhoto: (ids) ->
    console.log 'PhotosView::destroyPhoto'
    photos = ids || Album.selectionList().slice(0)
    photos = [photos] unless Photo.isArray photos
    if Album.record
      @destroyJoin photos, Album.record
    else
      for id in photos
        albums = AlbumsPhoto.albums(id)
        for album in albums
          @destroyJoin id, album
        photo.destroy() if photo = Photo.exists(id)
  
  destroy: ->
    @render() unless Photo.count()
      
  show: ->
    App.showView.trigger('change:toolbarOne', ['Default', 'Slider', App.showView.initSlider])
    App.showView.trigger('change:toolbarTwo', ['Slideshow'])
    App.showView.trigger('canvas', @)
  
  activated: ->
    @change()
    
  save: (item) ->

  # methods after uplopad
  
  addAlbumsPhoto: (ap) ->
    el = @list.findModelElement photo if photo = Photo.exists(ap.photo_id)
    return if el.length
    @add photo
  
  add: (photos) ->
    unless Photo.isArray photos
      photos = [photos]
    @render(photos, 'append')
    @list.el.sortable('destroy').sortable('photos')
      
  destroyAlbumsPhoto: (ap) ->
    photos = AlbumsPhoto.photos  ap.album_id
    @render() unless photos.length
      
  createJoin: (photos, album, options={}) ->
    # photos must be an array of photos
    console.log 'PhotosView::createJoin'
    return unless album and album.constructor.className is 'Album'
    photos = [photos] unless Photo.isArray(photos)
    for pid in photos
      unless AlbumsPhoto.albumPhotoExists(pid, album.id)
        ap = new AlbumsPhoto
          album_id: album.id
          photo_id: pid
          order: AlbumsPhoto.photos(album.id).length
        ap.save()
      
    if options.from
      @destroyJoin photos, options.from
  
  destroyJoin: (photos, album) ->
    console.log 'PhotosView::destroyJoin'
    return unless album and album.constructor.className is 'Album'
    photos = [photos] unless Photo.isArray(photos)
    for pid in photos
      if ap = AlbumsPhoto.albumPhotoExists(pid, album.id)
        ap.destroy()

  sortupdate: ->
    @list.children().each (index) ->
      item = $(@).item()
#      console.og AlbumsPhoto.filter(item.id, func: 'selectPhoto').length
      if item #and Album.record
        ap = AlbumsPhoto.filter(item.id, func: 'selectPhoto')[0]
        if ap and ap.order isnt index
          ap.order = index
          ap.save()
        # set a *invalid flag*, so when we return to albums cover view, thumbnails can get regenerated
        Album.record.invalid = true
        
    @list.exposeSelection()
    
  backToAlbumView: (ga) ->
    return unless @isActive()
    if gallery = Gallery.exists ga.gallery_id
      @navigate '/gallery', gallery.id
    
module?.exports = PhotosView