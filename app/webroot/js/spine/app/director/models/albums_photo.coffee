
class AlbumsPhoto extends Spine.Model
  @configure "AlbumsPhoto", "album_id", 'photo_id'

  @extend Spine.Model.Local
  @extend Spine.Model.Filter
  
  select: (query) ->
    return true if @album_id is query and @constructor.records[@id]
    return false
    
  selectPhoto: (query) ->
    return true if @photo_id is query

Spine.Model.AlbumsPhoto = AlbumsPhoto