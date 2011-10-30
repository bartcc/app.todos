
class GalleriesAlbum extends Spine.Model
  @configure "GalleriesAlbum", 'gallery_id', 'album_id', 'name'

  @extend Spine.Model.Local
  @extend Spine.Model.Filter
  
  select: (query) ->
    return true if @gallery_id is query and @constructor.records[@id]
    return false

  selectAlbum: (query) ->
    return true if @album_id is query

Spine.Model.GalleriesAlbum = GalleriesAlbum