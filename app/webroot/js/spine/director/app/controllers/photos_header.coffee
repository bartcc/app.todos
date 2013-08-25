Spine       = require("spine")
$           = Spine.$
Gallery     = require('models/gallery')
AlbumsPhoto = require('models/albums_photo')

Gallery         = require('models/gallery')
Album           = require('models/album')
Photo           = require('models/photo')

class PhotosHeader extends Spine.Controller
  
  events:
    'click .gal'                      : 'backToGalleries'
    'click .alb'                      : 'backToAlbums'
    'click .optPhotoActionCopy'       : 'startPhotoActionCopy' 
    'click .optPhotoActionMove'       : 'startPhotoActionMove' 
    
  elements:
    '.move'          : 'actionMenu'

  template: (item) ->
    $("#headerPhotosTemplate").tmpl item

  constructor: ->
    super
    Album.bind('change:selection', @proxy @moveMenu)
    
  backToGalleries: (e) ->
    console.log 'PhotosHeader::backToGalleries'
#    Spine.trigger('show:galleries')
    @navigate '/galleries/'
    e.stopPropagation()
    e.preventDefault()
    
  backToAlbums: (e) ->
    console.log 'PhotosHeader::backToAlbums'
    @navigate '/gallery', Gallery.record?.id or ''
    e.stopPropagation()
    e.preventDefault()
    
  change:  ->
    @render()
    
  render: ->
    @html @template
      gallery: Gallery.record
      album: Album.record
      photo: Photo.record
      count:  @count()
    @delay(@moveMenu, 500)
    
  count: ->
    if Album.record
      AlbumsPhoto.filter(Album.record.id, key: 'album_id').length
    else
      Photo.all().length
      
  hideMenu: ->
    @actionMenu.removeClass('down')
    
  moveMenu: (list = Album.selectionList()) ->
    @actionMenu.toggleClass('down', !!list.length)
    
  startPhotoActionCopy: (e) ->
    e.stopPropagation()
    e.preventDefault()
    
    Spine.photoCopyList = Album.selectionList().slice(0)
    Photo.one('action:copy', @proxy App.showView.createPhotoCopy)
#    Gallery.updateSelection [Album.record.id] if Album.record
    @navigate '/gallery', Gallery.record?.id
    
  startPhotoActionMove: (e) ->
    e.stopPropagation()
    e.preventDefault()
    
    Spine.photoCopyList = Album.selectionList().slice(0)
    Photo.one('action:move', @proxy App.showView.createPhotoMove)
#    Album.updateSelection [Album.record.id] if Album.record
    @navigate '/gallery', Gallery.record?.id
    
    

module?.exports = PhotosHeader