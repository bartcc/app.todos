
class GalleriesAlbum extends Spine.Model
  @configure "GalleriesAlbum", 'id', 'gallery_id', 'album_id', 'order'

  @extend Spine.Model.Ajax
  @extend Spine.Model.AjaxRelations
  @extend Spine.Model.Filter
  
  @url: -> 'galleries_albums'
  
  @galleryHasAlbum: (gid, aid) ->
    gas = @filter gid, key: 'gallery_id'
    for ga in gas
      return true if ga.album_id == aid
    false
    
  @galleries: (id) ->
    ret = []
    @each ->
      ret.push Gallery.find(item['gallery_id']) if item['album_id'] is id
    ret
      
  @albums: (id) ->
    ret = []
    @each (item) ->
      ret.push Album.find(item['album_id']) if item['gallery_id'] is id
    ret
    
  select: (query, options) ->
    return true if @[options.key] is query and @constructor.records[@id]
    return false
    
  selectAlbum: (query) ->
    return true if @album_id is query
    
Spine.Model.GalleriesAlbum = GalleriesAlbum