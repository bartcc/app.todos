
class AlbumsPhoto extends Spine.Model
  @configure "AlbumsPhoto", "album_id", 'photo_id', 'uris'

  @extend Spine.Model.Local
  @extend Spine.Model.Filter
  
#  select: (query) ->
#    return true if @album_id is query and @constructor.records[@id]
#    return false
    
  select: (query, options) ->
    return true if @[options.key] is query and @constructor.records[@id]
    return false
    
  selectPhoto: (query) ->
    return true if @photo_id is query

Spine.Model.AlbumsPhoto = AlbumsPhoto