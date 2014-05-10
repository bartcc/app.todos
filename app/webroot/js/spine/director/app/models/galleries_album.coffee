Spine         = require("spine")
$             = Spine.$
Model         = Spine.Model
Filter        = require("plugins/filter")
Model.Gallery = require('models/gallery')
Model.Album   = require('models/album')
Photo         = require('models/photo')
AlbumsPhoto   = require('models/albums_photo')
Extender      = require("plugins/model_extender")

require("spine/lib/ajax")


class GalleriesAlbum extends Spine.Model

  @configure "GalleriesAlbum", 'id', 'cid', 'gallery_id', 'album_id', 'order'

  @extend Model.Ajax
  @extend Filter
  @extend Extender

  @url: 'galleries_albums'
  
  @galleryAlbumExists: (aid, gid) ->
    gas = @filter 'placeholder',
      album_id: aid
      gallery_id: gid
      func: 'selectUnique'
    gas[0] or false
    
  @galleries: (aid) ->
    Gallery.filterRelated(aid,
      model: 'Album'
      key: 'album_id'
      sorted: 'sortByOrder'
    )
    
  @albums: (gid) ->
    Album.filterRelated(gid,
      model: 'Gallery'
      key: 'gallery_id'
      sorted: 'sortByOrder'
    )
      
  @c: 0
  
  validate: ->
    valid_1 = (Album.find @album_id) and (Gallery.find @gallery_id)
    valid_2 = !(ga = @constructor.galleryAlbumExists(@album_id, @gallery_id) and @isNew())
    return 'No valid action!' unless valid_1
    return 'Album already exists in Gallery' unless valid_2
    false
    
  galleries: ->
    @constructor.galleries @album_id
      
  albums: ->
    @constructor.albums @gallery_id
      
  select: (id, options) ->
    return true if @[options.key] is id
    
  selectAlbum: (id, gid) ->
    return true if @album_id is id and @gallery_id is Gallery.record.id
    
  selectUnique: (empty, options) ->
    return true if @album_id is options.album_id and @gallery_id is options.gallery_id
    
module.exports = Model.GalleriesAlbum = GalleriesAlbum