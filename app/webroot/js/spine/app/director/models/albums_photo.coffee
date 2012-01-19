
class AlbumsPhoto extends Spine.Model
  @configure "AlbumsPhoto", "album_id", 'photo_id', 'order'

  @extend Spine.Model.Local
  @extend Spine.Model.Filter
  
  select: (id, options) ->
    return true if @[options.key] is id and @constructor.records[@id]
    return false
    
  selectPhoto: (query) ->
    return true if @photo_id is query

Spine.Model.AlbumsPhoto = AlbumsPhoto