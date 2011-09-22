
class GalleriesAlbum extends Spine.Model
  @configure "GalleriesAlbum", "gallery_id", 'album_id'

  @extend Spine.Model.Filter
  @extend Spine.Model.Local
  
  select: (query) ->
    if query
      return true if @.gallery_id is query
    else return true