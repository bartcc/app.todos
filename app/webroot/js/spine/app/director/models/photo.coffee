class Photo extends Spine.Model
  @configure "Photo", 'title', "description", 'filesize', 'captured', 'exposure', "iso", 'longitude', 'aperture', 'make', 'model', 'user_id', 'order'

  @extend Spine.Model.Ajax
  @extend Spine.Model.AjaxRelations
  @extend Spine.Model.Filter
  @extend Spine.Model.Cache
  @extend Spine.Model.Uri
  @extend Spine.Model.Extender

  @selectAttributes: ['title', "description", 'user_id']
  
  @parentSelector: 'Album'
  
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
  
  @uri_: (album, params, callback = @success) =>
    options = $.extend({}, @defaults, params)
    
    # get all photos of the album
    aps = AlbumsPhoto.filter(album?.id, key: 'album_id')
    photos = for ap in aps
      Photo.find(ap.photo_id)
    return unless photos.length
    
    url = options.width + '/' + options.height + '/' + options.square + '/' + options.quality
    uri = Album.cache album, url
    
    # not in cache
    unless uri
      $.ajax
        url: base_url + 'photos/uri/' + url
        data: JSON.stringify(photos)
        type: 'POST'
        success: (uri) ->
          Album.addToCache album, url, uri
          callback.call @, uri
        error: @error
    else
      # continue with cached uris
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
    
  init: (instance) ->
    cache = {}
    cache[instance.id] = []
    @constructor.caches.push(cache)
  
  next: ->
    
  
  selectAttributes: ->
    result = {}
    result[attr] = @[attr] for attr in @constructor.selectAttributes
    result

  # loops over each record
  select: (joinTableItems) ->
    for record in joinTableItems
      return true if record.photo_id is @id and (@['order'] = record.order)?
      
  selectPhoto: (id) ->
    return true if id is @id
    false
      
  details: ->
    details =
      gallery : Gallery.record
      album   : Album.record
      photo   : Photo.record

Spine.Model.Photo = Photo