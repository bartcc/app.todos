
class AlbumsPhoto extends Spine.Model
  @configure "AlbumsPhoto", 'album_id', 'photo_id', 'order'

  @extend Spine.Model.Ajax
  @extend Spine.Model.AjaxRelations
  @extend Spine.Model.Filter
  
  @url: -> 'albums_photos'
  
  @albumHasPhoto_: (aid, pid) ->
    aps = @filter aid, key: 'album_id'
    for ap in aps
      return true if ap.photo_id == pid
    false
    
  @albums_: (id) ->
    ret = []
#    ap = @find(id) if @exists(id)
    @each (item) ->
      ret.push Album.find(item['album_id']) if item['photo_id'] is id
    ret
      
  @albumPhotos: (aid) ->
    ret = []
    @each (item) ->
      ret.push Photo.find(item['photo_id']) if item['album_id'] is aid
    ret
    
  @photos: (aid) ->
    Photo.filterRelated(aid,
      joinTable: 'AlbumsPhoto'
      key: 'album_id'
    )
    
  @albums: (pid) ->
    Album.filterRelated(pid,
      joinTable: 'AlbumsPhoto'
      key: 'photo_id'
    )

  @c: 0

  @next: ->
    @uid()

  albums: ->
    Album.filterRelated(@album_id,
      joinTable: 'AlbumsPhoto'
      key: 'album_id'
    )

  select: (id, options) ->
    return true if @[options.key] is id and @constructor.records[@id]
    return false
    
  selectPhoto: (id) ->
    return true if @photo_id is id and @album_id is Album.record.id

Spine.Model.AlbumsPhoto = AlbumsPhoto