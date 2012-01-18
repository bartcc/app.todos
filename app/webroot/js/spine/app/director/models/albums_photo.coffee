
class AlbumsPhoto extends Spine.Model
  @configure "AlbumsPhoto", "album_id", 'photo_id', 'order'

  @extend Spine.Model.Local
  @extend Spine.Model.Filter
  
  sort: (aid = Album.record) ->
    aps = AlbumsPhoto.filter(aid, key: 'album_id')
    arr = []
    arr.push ap for ap in aps
    arr.sort (a, b) ->
      if a < b then -1 else if a > b then 1 else 0
    
  select: (id, options) ->
    return true if @[options.key] is id and @constructor.records[@id]
    return false
    
  selectPhoto: (query) ->
    return true if @photo_id is query

Spine.Model.AlbumsPhoto = AlbumsPhoto