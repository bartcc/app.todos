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

  @url: 'galleries_albums'
  
  @galleryAlbumExists: (aid, gid) ->
    gas = @filter gid, key: 'gallery_id'
    for ga in gas
      return ga if ga.album_id == aid
    false
    
  @galleries: (aid) ->
    Gallery.filterRelated(aid,
      joinTable: 'GalleriesAlbum'
      key: 'album_id'
      sorted: true
    )
    
  @albums: (gid) ->
    Album.filterRelated(gid,
      joinTable: 'GalleriesAlbum'
      key: 'gallery_id'
      sorted: true
    )
      
  @c: 0
      
  select: (id, options) ->
    return true if @[options.key] is id and @constructor.irecords[@id]
    return false
    
  selectAlbum: (id, gid) ->
    return true if @album_id is id and @gallery_id is Gallery.record.id
    
module.exports = Model.GalleriesAlbum = GalleriesAlbum