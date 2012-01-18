
class Album extends Spine.Model
  @configure "Album", 'title', 'description', 'count', 'user_id'

  @extend Spine.Model.Filter
  @extend Spine.Model.Ajax
  @extend Spine.Model.AjaxRelations
  @extend Spine.Model.Cache
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
    
  init: (instance) ->
    return unless instance
    newSelection = {}
    newSelection[instance.id] = []
    @constructor.selection.push(newSelection)
    
    cache = {}
    cache[instance.id] = []
    @constructor.caches.push(cache)
    
    
  selChange: (list) ->
    console.log list
  
  details: =>
    filterOptions =
      key:'album_id'
      joinTable: 'AlbumsPhoto'
    photos = AlbumsPhoto.filter(@id, filterOptions)
    details =
      iCount : photos.length
      album  : Album.record
      gallery: Gallery.record
    
  selectAttributes: ->
    result = {}
    result[attr] = @[attr] for attr in @constructor.selectAttributes
    result

  select: (joinTableItems) ->
    #id should be gallery.id
#    ga = Spine.Model[options.joinTable].filter(id, options)
    for record in joinTableItems
      return true if record.album_id is @id
    
Spine.Model.Album = Album

