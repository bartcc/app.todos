
class Album extends Spine.Model
  @configure "Album", 'title', 'description', 'count', 'user_id', 'order', 'invalid'

  @extend Spine.Model.Cache
  @extend Spine.Model.Filter
  @extend Spine.Model.Ajax
  @extend Spine.Model.AjaxRelations
  @extend Spine.Model.Uri
  @extend Spine.Model.Extender

  @selectAttributes: ['title']
  
  @parentSelector: 'Gallery'
  
  @previousID: false

  @url: ->
    '' + base_url + @className.toLowerCase() + 's'

  @nameSort: (a, b) ->
    aa = (a or '').title?.toLowerCase()
    bb = (b or '').title?.toLowerCase()
    return if aa == bb then 0 else if aa < bb then -1 else 1

  @foreignModels: ->
    'Gallery':
      className             : 'Gallery'
      joinTable             : 'GalleriesAlbum'
      foreignKey            : 'album_id'
      associationForeignKey : 'gallery_id'
    'Photo':
      className             : 'Photo'
      joinTable             : 'AlbumsPhoto'
      foreignKey            : 'album_id'
      associationForeignKey : 'photo_id'
    
  @contains: (id) ->
    AlbumsPhoto.filter(id, key: 'album_id').length
    
  init: (instance) ->
    return unless instance.id
    s = new Object()
    s[instance.id] = []
    @constructor.selection.push s
    
    o = new Object()
    o[instance.id] = []
    @constructor.caches.push o
    
  selChange: (list) ->
  
  contains: -> @constructor.contains @id
  
  details: =>
    iCount : @constructor.contains @id
    album  : Album.record
    gallery: Gallery.record
    
  selectAttributes: ->
    result = {}
    result[attr] = @[attr] for attr in @constructor.selectAttributes
    result
  
  # loops over each record and make sure to set the copy property
  select: (joinTableItems) ->
    for record in joinTableItems
      return true if record.album_id is @id and (@['order'] = record.order)?
      
  selectAlbum: (id) ->
    return true if @id is id
    false
      
Spine.Model.Album = Album

