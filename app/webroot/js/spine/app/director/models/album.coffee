
class Album extends Spine.Model
  @configure "Album", 'title', 'description', 'user_id'

  @extend Spine.Model.Ajax
  @extend Spine.Model.AjaxRelations
  @extend Spine.Model.Filter
  @extend Spine.Model.Extender

  @selectAttributes: ['title']

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
    'Bitmap':
      className             : 'Bitmap'
      joinTable             : 'AlbumsBitmap'
      foreignKey            : 'album_id'
      associationForeignKey : 'image_id'

  init: (instance) ->
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