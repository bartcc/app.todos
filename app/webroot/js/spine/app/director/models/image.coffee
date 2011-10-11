class Image extends Spine.Model
  @configure "Image", 'title', "description", "exif"

  @extend Spine.Model.Ajax
  @extend Spine.Model.AjaxRelations
  @extend Spine.Model.Filter
  @extend Spine.Model.Extender

  @selectAttributes: ['title', "description", "exif"]

  @foreignModels: ->
    'Album':
      className             : 'Album'
      joinTable             : 'AlbumsImage'
      foreignKey            : 'image_id'
      associationForeignKey : 'album_id'

  @url: ->
    '' + base_url + @className.toLowerCase() + 's'

  @nameSort: (a, b) ->
    aa = (a or '').name?.toLowerCase()
    bb = (b or '').name?.toLowerCase()
    return if aa == bb then 0 else if aa < bb then -1 else 1

  selectAttributes: ->
    result = {}
    result[attr] = @[attr] for attr in @constructor.selectAttributes
    result

Spine.Model.Image = Image