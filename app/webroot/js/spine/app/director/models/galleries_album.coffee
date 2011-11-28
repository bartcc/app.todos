
class GalleriesAlbum extends Spine.Model
  @configure "GalleriesAlbum", 'gallery_id', 'album_id', 'name'

  @extend Spine.Model.Local
  @extend Spine.Model.Filter
  
  @galleryHasAlbum: (gid, aid) ->
    gas = @filter gid, key: 'gallery_id'
    for ga in gas
      return true if ga.album_id == aid
    false
    
  select: (query, options) ->
    return true if @[options.key] is query and @constructor.records[@id]
    return false
    
Spine.Model.GalleriesAlbum = GalleriesAlbum