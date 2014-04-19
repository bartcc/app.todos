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
    '.items'          : 'itemsEl'
  
  events:
    'click .item'                  : 'click'
    'sortupdate .item'             : 'sortupdate'
#    'dragstart .item'              : 'dragStart'
    
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
      el: @itemsEl
      template: @template
      info: @info
      parent: @
    @header.template = @headerTemplate
    @viewport = @list.el
    
    @bind('drag:start', @proxy @dragStart)
    @bind('drag:drop', @proxy @dragDrop)
    
#    AlbumsPhoto.bind('destroy', @proxy @remove)
    GalleriesAlbum.bind('destroy', @proxy @backToAlbumView)
    Photo.bind('refresh', @proxy @change)
    Photo.bind('created', @proxy @add)
    Photo.bind('destroy', @proxy @destroy)
    Photo.bind('beforeDestroy', @proxy @beforeDestroy)
    Photo.bind('create:join', @proxy @createJoin)
    Photo.bind('destroy:join', @proxy @destroyJoin)
    Photo.bind('ajaxError', Photo.errorHandler)
    Photo.bind('activate', @proxy @activateRecord)
    
    Spine.bind('destroy:photo', @proxy @destroyPhoto)
    Spine.bind('show:photos', @proxy @show)
    Spine.bind('loading:done', @proxy @updateBuffer)
    Spine.bind('changed:photos', @proxy @changedPhotos)
    
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
  
  changedPhotos: ->
    @render()
  
  render: (items, mode) ->
    # render only if necessary
    return unless @isActive()
    console.log 'PhotosView::render'
    # if view is dirty but inactive we'll use the buffer next time
    list = @list.render(items || @updateBuffer(), mode)
    list.sortable('photo') if Album.record
    delete @buffer
  
  click: (e) ->
    console.log 'PhotosList::click'
    App.showView.trigger('change:toolbarOne')
    
    item = $(e.currentTarget).item()
#    Photo.trigger('activate', item.id)
    @select item.id, @isCtrlClick(e)
    
    e.stopPropagation()
    e.preventDefault()
  
  select: (items = [], exclusive) ->
    unless Spine.isArray items
      items = [items]
      
    Album.emptySelection() if exclusive
    
    selection = Album.selectionList().slice(0)
    for id in items
      selection.addRemoveSelection(id)
      
    Photo.trigger('activate', selection[0])
    Album.updateSelection(selection)
  
    
  activateRecord: (arr=[]) ->
    unless Spine.isArray(arr)
      arr = [arr]
      
    list = []
    for id in arr
      list.push photo.id if photo = Photo.exists(id)
    
    id = list[0]
#    Album.updateSelection(list)
    Photo.current(id)
  
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
    photos = ids || Album.selectionList().slice(0)
    photos = [photos] unless Photo.isArray photos
    if Album.record
      @destroyJoin options =
        photos: photos
        album: Album.record
    else
      for id in photos
        albums = AlbumsPhoto.albums(id)
        for album in albums
          @destroyJoin options =
            photos: id
            album: album
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
      
  createJoin: (options, relocate) ->
    console.log options
    album = options.album
    Photo.createJoin options.photos, options.album
    Album.updateSelection(options.photos)
    Spine.trigger('changed:photos', album.id)
  
  destroyJoin: (options) ->
    console.log 'PhotosView::destroyJoin'
    album = options.album
    return unless album and album.constructor.className is 'Album'
    photos = options.photos
    selection = []
    aps = []
    photos = [photos] unless Photo.isArray(photos)
    for id in photos
      if ap = AlbumsPhoto.albumPhotoExists(id, album.id)
        selection.addRemoveSelection id
        aps.push ap.id
        ap.destroy()
    Album.removeFromSelection selection
    Spine.trigger('changed:photos', album.id)
    @sortupdate()

  sortupdate: ->
    console.log 'PhotosView::sortupdate'
    @list.children().each (index) ->
      item = $(@).item()
      if item and Album.record
        ap = AlbumsPhoto.filter(item.id, func: 'selectPhoto')[0]
        if ap and parseInt(ap.order) isnt index
          ap.order = index
          ap.save()
        # set a *invalid flag*, so when we return to albums cover view, thumbnails can get regenerated
        Album.record.invalid = true
        
    @list.exposeSelection()
    
  backToAlbumView: (ga) ->
    return unless @isActive()
    if gallery = Gallery.exists ga.gallery_id
      @navigate '/gallery', gallery.id
      
  dragStart: (e, o) ->
    if Album.selectionList().indexOf(Spine.dragItem.source.id) is -1
      Photo.trigger('activate', Spine.dragItem.source.id)
      
  dragDrop: ->
    @list.exposeSelection()
    
module?.exports = PhotosView