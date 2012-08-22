
class AlbumsPhoto extends Spine.Model
  @configure "AlbumsPhoto", 'album_id', 'photo_id', 'order'

  @extend Spine.Model.Ajax
  @extend Spine.Model.AjaxRelations
  @extend Spine.Model.Filter
  
  @url: -> 'albums_photos'
  
  @albumHasPhoto: (aid, pid) ->
    aps = @filter aid, key: 'album_id'
    for ap in aps
      return true if ap.photo_id == pid
    false
    
  @albumPhotos: (aid) ->
    ret = []
    @each (item) ->
      ret.push Photo.exists(item['photo_id']) if item['album_id'] is aid
    ret
    
  @photos: (aid, max) ->
    Photo.filterRelated(aid,
      joinTable: 'AlbumsPhoto'
      key: 'album_id'
      sorted: true
    ).slice(0, max)
    
  @albums: (pid, max) ->
    Album.filterRelated(pid,
      joinTable: 'AlbumsPhoto'
      key: 'photo_id'
      sorted: true
    ).slice(0, max)

  @c: 0

  @next: ->
    -1

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