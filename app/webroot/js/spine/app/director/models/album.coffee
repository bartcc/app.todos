
class Album extends Spine.Model
  @configure "Album", "name", 'title', 'description'

  @extend Spine.Model.Ajax
  @extend Spine.Model.AjaxExtender
  @extend Spine.Model.Filter
  @extend Spine.Model.Extender

  @selectAttributes: ["name", 'title', "description"]

  @url: ->
    '' + base_url + @className.toLowerCase() + 's'

  @nameSort: (a, b) ->
    aa = (a or '').name?.toLowerCase()
    bb = (b or '').name?.toLowerCase()
    return if aa == bb then 0 else if aa < bb then -1 else 1

  @foreignModels: ->
    'Gallery':
      className: 'Gallery'
      joinTable: 'GalleriesAlbum'
      foreignKey: 'album_id'
      associationForeignKey: 'gallery_id'
      parent: 'Gallery'
    'Image':
      className: 'Image'
      joinTable: 'AlbumsImage'
      foreignKey: 'album_id'
      associationForeignKey: 'image_id'
      parent: 'Album'

  @joinTables: ->
    fModels = @foreignModels()
    joinTables = for key, value of fModels
      fModels[key]['joinTable']
    joinTables

  init: (instance) ->
    @constructor.counter = 0
    return unless instance
  
  selectAttributes: ->
    result = {}
    result[attr] = @[attr] for attr in @constructor.selectAttributes
    result

  select: (id) ->
    #id should be gallery.id
    ga = GalleriesAlbum.filter(id)
    for record in ga
      return true if record.album_id is @id
        

Spine.Model.Album = Album