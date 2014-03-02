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
#Drag            = require("plugins/drag")

require("plugins/tmpl")

class PhotosView extends Spine.Controller
  
#  @extend Drag
  @extend Extender
  
  elements:
    '.hoverinfo'      : 'infoEl'
    '.items'          : 'items'
  
  events:
#    'dragstart  .items .thumbnail'    : 'dragstart'
#    'dragover   .items .thumbnail'    : 'dragover'
    'sortupdate .items'               : 'sortupdate'
    
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
#    AlbumsPhoto.bind('destroy', @proxy @remove)
    AlbumsPhoto.bind('create update destroy', @proxy @renderHeader)
    AlbumsPhoto.bind('destroy', @proxy @destroyAlbumsPhoto)
    GalleriesAlbum.bind('destroy', @proxy @destroyGalleriesAlbum)
    AlbumsPhoto.bind('create', @proxy @addAlbumsPhoto)
    Gallery.bind('create update destroy', @proxy @renderHeader)
    Album.bind('change', @proxy @renderHeader)
    Photo.bind('created', @proxy @add)
    Photo.bind('destroy', @proxy @destroy)
    Photo.bind('beforeDestroy', @proxy @beforeDestroy)
    Photo.bind('create:join', @proxy @createJoin)
    Photo.bind('destroy:join', @proxy @destroyJoin)
    Photo.bind('ajaxError', Photo.errorHandler)
    Spine.bind('destroy:photo', @proxy @destroyPhoto)
    Spine.bind('show:photos', @proxy @show)
    Spine.bind('change:selectedAlbum', @proxy @change)
    Spine.bind('done:upload', @proxy @updateBuffer)
    
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
  
  change: ->
    @updateBuffer()
    @render @buffer
  
  render: (items, mode) ->
    # render only if necessary
    return unless @isActive()
    console.log 'PhotosView::render'
    # if view is dirty but inactive we'll use the buffer next time
    list = @list.render(items || @updateBuffer(), mode)
    list.sortable('photo')
    delete @buffer
  
  renderHeader: ->
    console.log 'PhotosView::renderHeader'
    @header.change()
  
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
  
  destroy: (album) ->
    @render() unless Photo.count()
      
  destroyGalleriesAlbum: (ga) ->
    @navigate '/gallery', ga.gallery_id
#    photos = AlbumsPhoto.photos  ap.album_id
#    @render() unless photos.length
      
  destroyAlbumsPhoto: (ap) ->
    photos = AlbumsPhoto.photos  ap.album_id
    @render() unless photos.length
      
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
    for photo in photos
      if Photo.exists(photo.id)
        @render([photo], 'append')
        @list.el.sortable('destroy').sortable('photos')
      
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
      ap = AlbumsPhoto.albumPhotoExists(pid, album.id)
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
    
module?.exports = PhotosView