
class Album extends Spine.Model
  @configure "Album", 'title', 'description', 'count', 'user_id', 'order', 'invalid'

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
    
  @photos: (id, max = Album.count()) ->
    filterOptions =
      key:'album_id'
      joinTable: 'AlbumsPhoto'
    Photo.filterRelated(id, filterOptions)[0...max]
    
  @createJoin: (items=[], target) ->
    unless @isArray items
      items = [].push(items)

    return unless items.length
#    
    for item in items
      ga = new GalleriesAlbum
        gallery_id  : target.id
        album_id    : item.id
        order       : GalleriesAlbum.next()
      ga.save()
#    
#  @destroyJoin: (albums, target) ->
#    return unless target
#
#    filterOptions =
#      key:'gallery_id'
#      joinTable: 'GalleriesAlbum'
#      sorted: true
#
#    unless @isArray albums
#      records = []
#      records.push(albums)
#    else records = albums
#
#    albums = @toID(records)
#
#    gas = GalleriesAlbum.filter(target.id, filterOptions)
#    for ga in gas
#      unless albums.indexOf(ga.album_id) is -1
#        Gallery.removeFromSelection ga.album_id
#        ga.destroy()
#    
  init: (instance) ->
    return unless instance.id
    s = new Object()
    s[instance.id] = []
    @constructor.selection.push s
    
  selChange: (list) ->
  
  createJoin: (target) ->
    ga = new GalleriesAlbum
      gallery_id  : target.id
      album_id    : @id
      order       : GalleriesAlbum.next()
    ga.save()
  
  destroyJoin: (target) ->
    filterOptions =
      key:'gallery_id'
      joinTable: 'GalleriesAlbum'
      sorted: true
      
    albums = @constructor.toID([@]) #Album.toID(records)
    gas = GalleriesAlbum.filter(target.id, filterOptions)

    for ga in gas
      unless albums.indexOf(ga.album_id) is -1
        Gallery.removeFromSelection ga.album_id
        ga.destroy()
  
  contains: -> @constructor.contains @id
  
  photos: (max) ->
    @constructor.photos @id, max || @contains()
  
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

