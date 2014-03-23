Spine         = require("spine")
$             = Spine.$
Model         = Spine.Model
Filter        = require("plugins/filter")
AjaxRelations = require("plugins/ajax_relations")
Gallery         = require('models/gallery')
Model.Album           = require('models/album')
Model.Photo           = require('models/photo')
GalleriesAlbum  = require('models/galleries_album')
require("spine/lib/ajax")

class AlbumsPhoto extends Spine.Model

  @configure "AlbumsPhoto", 'album_id', 'photo_id', 'order'

  @extend Model.Ajax
  @extend AjaxRelations
  @extend Filter
  
  @url: 'albums_photos'
  
  @albumPhotoExists: (pid, aid) ->
    aps = @filter aid, key: 'album_id'
    for ap in aps
      return ap if ap.photo_id == pid
    false
    
  @albumsPhotos: (aid) ->
    aps = @filter aid, key: 'album_id'
    
  @albumPhotos: (aid) ->
    ret = []
    @each (item) ->
      ret.push photo if item['album_id'] is aid and photo = Photo.exists(item['photo_id'])
    ret
    
  @photos: (aid, max) ->
    Photo.filterRelated(aid,
      joinTable: 'AlbumsPhoto'
      key: 'album_id'
      sorted: true
    ).slice(0, max)
    
  @albums: (pid, max) ->
    Album.filterRelated(pid,
      joinTable: 'AlbumsPhoto'
      key: 'photo_id'
      sorted: true
    ).slice(0, max)

  @c: 0

  albums: ->
    Album.filterRelated(@album_id,
      joinTable: 'AlbumsPhoto'
      key: 'album_id'
    )

  select: (id, options) ->
    return true if @[options.key] is id and @constructor.irecords[@id]
    return false
    
  selectPhoto: (id) ->
    return true if @photo_id is id and @album_id is Album.record.id

module.exports = Model.AlbumsPhoto = AlbumsPhoto