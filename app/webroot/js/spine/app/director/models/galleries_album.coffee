
class GalleriesAlbum extends Spine.Model
  @configure "GalleriesAlbum", 'gallery_id', 'album_id', 'order'

  @extend Spine.Model.Ajax
  @extend Spine.Model.AjaxRelations
  @extend Spine.Model.Filter

  @url: -> 'galleries_albums'
  
  @galleryHasAlbum: (gid, aid) ->
    gas = @filter gid, key: 'gallery_id'
    for ga in gas
      return true if ga.album_id == aid
    false
    
  @galleries: (aid) ->
    ret = []
    @each ->
      ret.push Gallery.find(item['gallery_id']) if item['album_id'] is aid
    ret
      
  @albums: (gid) ->
    ret = []
    @each (item) ->
      ret.push Album.find(item['album_id']) if item['gallery_id'] is gid
    ret
    
  @next: ->
    @uid()
    
  select: (id, options) ->
    return true if @[options.key] is id and @constructor.records[@id]
    return false
    
  selectAlbum: (id) ->
    return true if @album_id is id and @gallery_id is Gallery.record.id
    
Spine.Model.GalleriesAlbum = GalleriesAlbum