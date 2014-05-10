Spine           = require("spine")
$               = Spine.$
Model           = Spine.Model
Filter          = require("plugins/filter")
Gallery         = require('models/gallery')
Model.Album     = require('models/album')
Model.Photo     = require('models/photo')
GalleriesAlbum  = require('models/galleries_album')
Extender        = require("plugins/model_extender")

require("spine/lib/ajax")

class AlbumsPhoto extends Spine.Model

  @configure "AlbumsPhoto", 'album_id', 'photo_id', 'order'

  @extend Model.Ajax
  @extend Filter
  @extend Extender
  
  @url: 'albums_photos'
  
  @albumPhotoExists: (pid, aid) ->
    aps = @filter 'placeholder',
      photo_id: pid
      album_id: aid
      func: 'selectUnique'
    aps[0] or false
    
  @albumsPhotos: (aid) ->
    aps = @filter aid, key: 'album_id'
    
  @albumPhotos: (aid) ->
    ret = []
    @each (item) ->
      ret.push photo if item['album_id'] is aid and photo = Photo.find(item['photo_id'])
    ret
    
  @photos: (aid, max) ->
    Photo.filterRelated(aid,
      model: 'Album'
      key: 'album_id'
      sorted: 'sortByOrder'
    ).slice(0, max)
    
  @albums: (pid, max) ->
    Album.filterRelated(pid,
      model: 'Photo'
      key: 'photo_id'
      sorted: 'sortByOrder'
    ).slice(0, max)

  @c: 0

  validate: ->
    valid_1 = (Album.find @album_id) and (Photo.find @photo_id)
    valid_2 = !(ap = @constructor.albumPhotoExists(@photo_id, @album_id) and @isNew())
    return 'No valid action!' unless valid_1
    return 'Photo already exists in Album' unless valid_2

  albums: ->
    @constructor.albums @photo_id
    
  photos: ->
    @constructor.photos @album_id

  select: (id, options) ->
    return true if @[options.key] is id
    
  selectPhoto: (id) ->
    return true if @photo_id is id and @album_id is Album.record.id
    
  selectUnique: (empty, options) ->
    return true if @album_id is options.album_id and @photo_id is options.photo_id

module.exports = Model.AlbumsPhoto = AlbumsPhoto