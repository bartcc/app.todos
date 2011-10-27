
class AlbumsBitmap extends Spine.Model
  @configure "AlbumsBitmap", "album_id", 'image_id'

  @extend Spine.Model.Local
  @extend Spine.Model.Filter
  
  select: (query) ->
    return true if @.album_id is query

Spine.Model.AlbumsBitmap = AlbumsBitmap