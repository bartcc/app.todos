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
    processData: false
    headers: {'X-Requested-With': 'XMLHttpRequest'}
    dataType: 'json'
  
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
    
class Uri extends Base
  constructor: (@model,  params, mode = 'html', @callback) ->
    super
    @photos = @model.all()
    
    options = $.extend({}, @settings, params)
    @url = @uri options
  
  settings:
    square: 1
    quality: 70
    
  test: ->
    cache = @model.cache null, @url
    if cache.length
      @callback cache
    else if @photos.length
      @get()
      
  recordResponse: (uris) =>
    @model.addToCache null, @url, uris, @mode
    @callback uris
    
  errorResponse: (xhr, statusText, error) =>
    @model.trigger('ajaxError', xhr, statusText, error)

class UriCollection extends Base
  constructor: (@record, params, mode, @callback, max) ->
    super
    type = @record.constructor.className
    switch type
      when 'Album'
        # get all photos of the album
        photos = AlbumsPhoto.photos(@record.id)
        max = max or photos.length
        @mode = mode
        @photos = photos[0...max]
      when 'Photo'
        @photos = [@record]
        
    options = $.extend({}, @settings, params)
    @url = @uri options
    
  settings:
    width: 140
    height: 140
    square: 1
    quality: 70
  
  test: ->
    cache = @record.cache @url
    if cache?.length
      @callback cache, @record
    else
      @get()
      
  all: ->
    @queue =>
      @ajax(
        type: "POST"
        url: base_url + 'photos/uri/' + @url
        data: JSON.stringify(@photos)
      ).success(@recordResponse)
       .error(@errorResponse)

  recordResponse: (uris) =>
    @record.addToCache @url, uris, @mode
    @callback uris, @record
    
  errorResponse: (xhr, statusText, error) =>
    @record.trigger('ajaxError', xhr, statusText, error)
  
Model.Uri =
  
  extended: ->
    
    Include =
      uri: (params, mode, callback, max) -> new UriCollection(@, params, mode, callback, max).test()
      
    Extend =
      uri: (params, mode, callback) -> new Uri(@, params, mode, callback).test()
      
    @include Include
    @extend Extend