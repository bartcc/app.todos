Spine ?= require("spine")
$      = Spine.$
Model  = Spine.Model

Ajax =

  enabled:  true
  pending:  false
  requests: []
  
  requestNext: ->
    next = @requests.shift()
    if next
      @request(next)
    else
      @pending = false
      Spine.trigger('uri:alldone')

  request: (callback) ->
    (do callback).complete(=> do @requestNext)
      
  queue: (callback) ->
    return unless @enabled
    if @pending
      @requests.push(callback)
    else
      @pending = true
      @request(callback)    
    callback
    
class Base
  defaults:
    contentType: 'application/json'
    dataType: 'json'
    processData: false
    headers: {'X-Requested-With': 'XMLHttpRequest'}
  
  ajax: (params, defaults) ->
    $.ajax($.extend({}, @defaults, defaults, params))
    
  queue: (callback) ->
    Ajax.queue(callback)
    
class UriCollection extends Base
  constructor: (@model, params, @callback, max) ->
    @photos = Photo.filter()

class Uri extends Base
  constructor: (@record, params, @callback, max) ->
    super
    # get all photos of the album
    if @record
      aps = AlbumsPhoto.filter @record.id
      max = max or aps.length-1
      @photos = for ap in aps[0..max]
        Photo.find(ap.photo_id)
      
    options = $.extend({}, @settings, params)
    @url = options.width + '/' + options.height + '/' + options.square + '/' + options.quality
    
  settings:
    width: 140
    height: 140
    square: 1
    quality: 70
    
  test: ->
    cache = @record.cache @url
    if cache
      @callback cache, @record
    else if @photos.length
      @get()
    
  get: ->
    @queue =>
      @ajax(
        type: "POST"
        url: base_url + 'photos/uri/' + @url
        data: JSON.stringify(@photos)
      ).success(@recordResponse)
       .error(@errorResponse)
       
  all: ->
    @queue =>
      @ajax(
        type: "POST"
        url: base_url + 'photos/uri/' + @url
        data: JSON.stringify(@photos)
      ).success(@collectionResponse)
       .error(@errorResponse)

  recordResponse: (uris) =>
    @record.addToCache @url, uris
    @callback uris, @record
    
  errorResponse: ->
  
Model.Uri =
  
  extended: ->
    
    Include =
      uri: (params, callback, max) -> new Uri(@, params, callback, max).test()
      
    @include Include
    