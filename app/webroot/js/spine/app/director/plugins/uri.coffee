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
    
  get: (item) ->
    @queue =>
      @ajax(
        type: "POST"
        url: base_url + 'photos/uri/' + @url
        data: JSON.stringify(@photos)
      ).success(@recordResponse)
       .error(@errorResponse)
       
  uri: (options) ->
    options.width + '/' + options.height + '/' + options.square + '/' + options.quality
    
class UriCollection extends Base
  constructor: (@model, items, params, mode = 'html', @callback) ->
    super
    @photos = for item in items
      Photo.find(item['Photo'].id) if Photo.exists(item['Photo'].id)
    
    options = $.extend({}, @settings, params)
    @url = @uri options
  
  settings:
    square: 1
    quality: 70
    
  test: ->
    @get()
      
  recordResponse: (uris) =>
    @model.addToCache @url, uris, @mode
    @callback uris
    
  errorResponse: ->

class Uri extends Base
  constructor: (@record, params, mode, @callback, max) ->
    super
    # get all photos of the album
    if @record
      aps = AlbumsPhoto.filter(@record.id, key: 'album_id')
      max = max or aps.length-1
      @mode = mode
      @photos = for ap in aps[0..max]
        Photo.find(ap.photo_id)
      
    options = $.extend({}, @settings, params)
    @url = @uri options
    
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
      
  all: ->
    @queue =>
      @ajax(
        type: "POST"
        url: base_url + 'photos/uri/' + @url
        data: JSON.stringify(@photos)
      ).success(@collectionResponse)
       .error(@errorResponse)

  recordResponse: (uris) =>
    @record.addToCache @url, uris, @mode
    @callback uris, @record
    
  errorResponse: ->
  
Model.Uri =
  
  extended: ->
    
    Include =
      uri: (params, mode, callback, max) -> new Uri(@, params, mode, callback, max).test()
      
    Extend =
      uri: (items, params, mode, callback) -> new UriCollection(@, items, params, mode, callback).test()
      
    @include Include
    @extend Extend
    