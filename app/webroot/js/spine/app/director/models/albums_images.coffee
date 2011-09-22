
class AlbumsImage extends Spine.Model
  @configure "AlbumsImage", "album_id", 'image_id'

  @extend Spine.Model.Local
  
  select: (query) ->
    return true if @.album_id is query