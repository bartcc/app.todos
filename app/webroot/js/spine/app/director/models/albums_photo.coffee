
class AlbumsPhoto extends Spine.Model
  @configure "AlbumsPhoto", "album_id", 'photo_id', 'uris'

  @extend Spine.Model.Local
  @extend Spine.Model.Filter
  
  @change: (callbackOrParams) ->
    console.log 'my AlbumsPhoto change'
    @__super__.constructor.change.call @, callbackOrParams
  
  select: (query) ->
    return true if @album_id is query and @constructor.records[@id]
    return false
    
  selectPhoto: (query) ->
    return true if @photo_id is query

Spine.Model.AlbumsPhoto = AlbumsPhoto