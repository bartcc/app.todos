class Photo extends Spine.Model
  @configure "Photo", 'title', "description", 'filesize', 'captured', 'exposure', "iso", 'longitude', 'aperture', 'make', 'model', 'user_id'

  @extend Spine.Model.Ajax
  @extend Spine.Model.AjaxRelations
  @extend Spine.Model.Filter
  @extend Spine.Model.Extender

  @selectAttributes: ['title', "description", 'user_id']

  @foreignModels: ->
    'Album':
      className             : 'Album'
      joinTable             : 'AlbumsPhoto'
      foreignKey            : 'photo_id'
      associationForeignKey : 'album_id'

  @url: ->
    '' + base_url + @className.toLowerCase() + 's'

  @nameSort: (a, b) ->
    aa = (a or '').name?.toLowerCase()
    bb = (b or '').name?.toLowerCase()
    return if aa == bb then 0 else if aa < bb then -1 else 1
  
  @defaults:
    width: 140
    height: 140
    square: 1
    quality: 70
  
  @uri: (items, params) ->
    options = $.extend({}, @defaults, params)
    
    $.ajax
      url: base_url + 'photos/uri/' + options.width + '/' + options.height + '/' + options.square + '/' + options.quality
      data: JSON.stringify(items)
      type: 'POST'
      success: @success
      error: @error
  
  @success: (json) =>
    console.log 'Ajax::success'
    Photo.trigger('uri', json)
    
  @error: (json) =>
    Photo.trigger('ajaxError', json)
    
  selectAttributes: ->
    result = {}
    result[attr] = @[attr] for attr in @constructor.selectAttributes
    result

  # loops over each record
  select: (id) ->
    #id should be album.id
    ap = AlbumsPhoto.filter(id)
    for record in ap
      return true if record.photo_id is @id

Spine.Model.Photo = Photo