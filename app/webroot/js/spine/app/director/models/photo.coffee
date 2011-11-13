class Photo extends Spine.Model
  @configure "Photo", 'title', "description", 'filesize', 'captured', 'exposure', "iso", 'longitude', 'aperture', 'make', 'model', 'user_id'

  @extend Spine.Model.Ajax
  @extend Spine.Model.AjaxRelations
  @extend Spine.Model.Filter
  @extend Spine.Model.Extender

  @cache: []

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
  
  @uri: (items, params, callback = @success) ->
    options = $.extend({}, @defaults, params)
    url = options.width + '/' + options.height + '/' + options.square + '/' + options.quality
    uri = Album.cache Album.record, url
    
    unless uri
      $.ajax
        url: base_url + 'photos/uri/' + url
        data: JSON.stringify(items)
        type: 'POST'
        success: (uri) ->
          Album.addToCache url, uri
          callback.call @, uri
        error: @error
    else
      callback.call @, uri
  
  @success: (uri) =>
    console.log 'Ajax::success'
    Photo.trigger('uri', uri)
    
  @error: (json) =>
    Photo.trigger('ajaxError', json)
  
  @create: (atts) ->
    console.log 'my create'
    @__super__.constructor.create.call @, atts
  
  @refresh: (values, options = {}) ->
    console.log 'my refresh'
    @__super__.constructor.refresh.call @, values, options
    console.log values
    
  init: (instance) ->
    cache = {}
    cache[instance.id] = {}
    @constructor.cache.push(cache)
  
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