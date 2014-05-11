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
Drag            = require("plugins/drag")
Extender        = require("plugins/controller_extender")

require("plugins/tmpl")

class PhotosView extends Spine.Controller
  
  @extend Drag
  @extend Extender
  
  elements:
    '.hoverinfo'      : 'infoEl'
    '.items'          : 'itemsEl'
  
  events:
    'click .item'                  : 'click'
    'sortupdate .items'            : 'sortupdate'
    
    'dragstart .item'              : 'dragstart'
    'dragstart'                    : 'stopInfo'
    'dragover .item'               : 'dragover'
    
    'mousemove .item'              : 'infoUp'
    'mouseleave  .item'            : 'infoBye'
    
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
    @bind('active', @proxy @active)
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
      parent: @
      slideshow: @slideshow
    @header.template = @headerTemplate
    @viewport = @list.el
    
    @bind('drag:help', @proxy @dragHelp)
    @bind('drag:start', @proxy @dragStart)
    @bind('drag:drop', @proxy @dragComplete)
    
    AlbumsPhoto.bind('destroy', @proxy @destroyAlbumsPhoto)
    AlbumsPhoto.bind('beforeDestroy', @proxy @beforeDestroyAlbumsPhoto)
    GalleriesAlbum.bind('destroy', @proxy @backToAlbumView)
    
    Photo.bind('refresh:one', @proxy @refreshOne)
    Photo.bind('created', @proxy @add)
    Photo.bind('destroy', @proxy @destroy)
    Photo.bind('beforeDestroy', @proxy @beforeDestroyPhoto)
    Photo.bind('create:join', @proxy @createJoin)
    Photo.bind('destroy:join', @proxy @destroyJoin)
    Photo.bind('ajaxError', Photo.errorHandler)
    Photo.bind('activate', @proxy @activateRecord)
    
    Spine.bind('destroy:photo', @proxy @destroyPhoto)
    Spine.bind('loading:done', @proxy @updateBuffer)
    
  refreshOne: ->
    Photo.one('refresh', @proxy @refresh)
    
  updateBuffer: (album=Album.record) ->
    filterOptions =
      model: 'Album'
      key: 'album_id'
      sorted: 'sortByOrder'
    
    if album
      items = Photo.filterRelated(album.id, filterOptions)
    else
      items = Photo.filter()
      
    @buffer = items
  
  refresh: ->
    @updateBuffer()
    @render @buffer, 'html'
  
  render: (items, mode='html') ->
    # render only if necessary
    return unless @isActive()
    # if view is dirty but inactive we'll use the buffer next time
    @list.render(items || @updateBuffer(), mode)
    @list.sortable('photo') if Album.record
    delete @buffer
    @el
  
  active: ->
    return unless @isActive()
    App.showView.trigger('change:toolbarOne', ['Default', 'Help', 'Slider', App.showView.initSlider])
    App.showView.trigger('change:toolbarTwo', ['Slideshow'])
    @refresh()
    @parent.scrollTo(@el.data('current').models.record)
    
  activateRecord: (records) ->
    unless records
      records = Album.selectionList()

    unless Spine.isArray(records)
      records = [records]
      
    list = []
    for id in records
      list.push photo.id if photo = Photo.find(id)
    
    id = list[0]
    
    Album.updateSelection(Album.record?.id, list)
    Photo.current(id)
      
  
  click: (e) ->
    
    @log 'click'
    App.showView.trigger('change:toolbarOne')
    
    item = $(e.currentTarget).item()
    
    @select item.id, @isCtrlClick(e) if item
    
  select: (items = [], exclusive) ->
    unless Spine.isArray items
      items = [items]
      
    Album.emptySelection() if exclusive
    
    selection = Album.selectionList()[..]
    for id in items
      selection.addRemoveSelection(id)
      
    Photo.trigger('activate', selection[0])
    Album.updateSelection(Album.record?.id, selection)
  
  clearPhotoCache: ->
    Photo.clearCache()
  
  beforeDestroyPhoto: (photo) ->
    
    # remove selection from root
    Album.removeFromSelection null, photo.id
    
    # all involved albums
    albums = AlbumsPhoto.albums(photo.id)
    
    for album in albums
      album.removeFromSelection photo.id
      photo.removeSelectionID()
      
      # remove all associated photos
      @destroyJoin
        photos: photo.id
        album: album
      
  beforeDestroyAlbumsPhoto: (ap) ->
    album = Album.find ap.album_id
    album.removeFromSelection ap.photo_id
  
  destroy: (item) ->
    el = @list.findModelElement(item)
    el.detach()
    @render() unless Photo.count()
      
  destroyAlbumsPhoto: (ap) ->
    photos = AlbumsPhoto.photos ap.album_id
    @render(null, 'html') unless photos.length
  
  destroyPhoto: (ids, callback) ->
    @log 'destroyPhoto'
    
    @stopInfo()
    
    func = (el) ->
      $(el).detach()
    
    photos = ids || Album.selectionList().slice(0)
    photos = [photos] unless Photo.isArray photos
    
    for id in photos
      if item = Photo.find(id)
        el = @list.findModelElement(item)
        el.removeClass('in')
      
#      setTimeout(func, 300, el)
      
    if album = Album.record
      @destroyJoin
        photos: photos
        album: album
    else
      for id in photos
        photo.destroy() if photo = Photo.find(id)
        
    if typeof callback is 'function'
      callback.call()
  
  save: (item) ->

  # methods after uplopad
  
  addAlbumsPhoto: (ap) ->
    el = @list.findModelElement photo if photo = Photo.find(ap.photo_id)
    return if el.length
    @add photo
  
  add: (photos) ->
    unless Photo.isArray photos
      photos = [photos]
    Album.updateSelection(Album.record?.id, photos.toID())
    @render(photos, 'append')
    @list.el.sortable('destroy').sortable('photos')
      
  createJoin: (options, cb) ->
    album = options.album
    photos = options.photos.toID()
    
    Photo.createJoin photos, album, cb
    album.updateSelection photos
  
  destroyJoin: (options, callback) ->
    @log 'destroyJoin'
    album = options.album
    photos = options.photos
    photos = [photos] unless Photo.isArray(photos)
    photos = photos.toID()
    
    selection = []
    for id in photos
      selection.addRemoveSelection id
      
    Photo.destroyJoin photos, album, callback
    
  sortupdate: ->
    @log 'sortupdate'
    
    cb = ->
    
    @list.children().each (index) ->
      item = $(@).item()
      if item and Album.record
        ap = AlbumsPhoto.filter(item.id, func: 'selectPhoto')[0]
        if ap and parseInt(ap.order) isnt index
          ap.order = index
          ap.save(ajax:false)
        # set a *invalid flag*, so when we return to albums cover view, thumbnails can get regenerated
        Album.record.invalid = true
        
    Album.record.save(done: cb)
    
  backToAlbumView: (ga) ->
    return unless @isActive()
    if gallery = Gallery.find ga.gallery_id
      @navigate '/gallery', gallery.id
      
  infoUp: (e) ->
    @info.up(e)
    el = $('.glyphicon-set' , $(e.currentTarget)).addClass('in').removeClass('out')
    
  infoBye: (e) ->
    @info.bye(e)
    el = $('.glyphicon-set' , $(e.currentTarget)).addClass('out').removeClass('in')
    
  stopInfo: (e) =>
    @info.bye(e)
      
  dragComplete: ->
    @list.exposeSelection()
    
module?.exports = PhotosView