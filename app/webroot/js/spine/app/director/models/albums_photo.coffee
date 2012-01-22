
class AlbumsPhoto extends Spine.Model
  @configure "AlbumsPhoto", "album_id", 'photo_id', 'order'

  @extend Spine.Model.Ajax
  @extend Spine.Model.AjaxRelations
  @extend Spine.Model.Filter
  
  @url: -> 'albums_photos'
  
  @albumHasPhoto: (aid, pid) ->
    aps = @filter aid, key: 'album_id'
    for ap in aps
      return true if ap.photo_id == pid
    false
    
  @albums: (id) ->
    ret = []
    @each ->
      ret.push Album.find(item['album_id']) if item['photo_id'] is id
    ret
      
  @photos: (id) ->
    ret = []
    @each (item) ->
      ret.push Photo.find(item['photo_id']) if item['album_id'] is id
    ret
    
  @photos_: (id) ->
    aps = AlbumsPhoto.filter(id, key: 'album_id')
    ret = []
    for ap in aps
      ret.push Photo.find(ap.photo_id)
    ret

  select: (id, options) ->
    return true if @[options.key] is id and @constructor.records[@id]
    return false
    
  selectPhoto: (query) ->
    return true if @photo_id is query

Spine.Model.AlbumsPhoto = AlbumsPhoto