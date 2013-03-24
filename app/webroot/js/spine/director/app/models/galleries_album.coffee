Spine         = require("spine")
$             = Spine.$
Model         = Spine.Model
Filter        = require("plugins/filter")
AjaxRelations = require("plugins/ajax_relations")
Model.Gallery = require('models/gallery')
Model.Album   = require('models/album')
Photo         = require('models/photo')
AlbumsPhoto   = require('models/albums_photo')
require("spine/lib/ajax")


class GalleriesAlbum extends Spine.Model

  @configure "GalleriesAlbum", 'gallery_id', 'album_id', 'order'

  @extend Model.Ajax
  @extend AjaxRelations
  @extend Filter

  @url: -> 'galleries_albums'
  
  @galleryHasAlbum: (gid, aid) ->
    gas = @filter gid, key: 'gallery_id'
    for ga in gas
      return true if ga.album_id == aid
    false
    
  @galleries: (aid) ->
    Gallery.filterRelated(aid,
      joinTable: 'GalleriesAlbum'
      key: 'album_id'
      sorted: true
    )
    
  @albums_too_slow_do_not_use: (gid) ->
    ret = []
    @each (item) ->
      ret.push Album.find(item['album_id']) if item['gallery_id'] is gid
    ret
    
  @albums: (gid) ->
    Album.filterRelated(gid,
      joinTable: 'GalleriesAlbum'
      key: 'gallery_id'
      sorted: true
    )
      
  @c: 0
      
  select: (id, options) ->
    return true if @[options.key] is id and @constructor.records[@id]
    return false
    
  selectAlbum: (id) ->
    return true if @album_id is id and @gallery_id is Gallery.record.id
    
module.exports = Model.GalleriesAlbum = GalleriesAlbum