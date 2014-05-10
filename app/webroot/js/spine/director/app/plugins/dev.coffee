Spine   = require("spine")
$       = Spine.$
Model   = Spine.Model

Ajax =

  enabled:  true
  cache: true
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

  ajaxQueue: (callback) ->
    Ajax.queue(callback)
    
  get: ->
    @ajaxQueue =>
      @ajax(
        type: "POST"
        url: base_url + 'photos/dev/' + @url
        data: JSON.stringify(@data)
      ).done(@recordResponse)
       .fail(@failResponse)
       
  uri: (options) ->
    ret = for o, val of options
      val
    ret.join('/')
       
class Develop extends Base

  constructor: (@model,  method, params, @callback, @data = []) ->
    super
    options = $.extend(method: method, @settings, params)
    @url = @uri options
    return
    
    return unless @data.length
    
  settings: {}
    
  recordResponse: (res) =>
    @callback res
    
  failResponse: (xhr, statusText, error) =>
    @model.trigger('ajaxError', xhr, statusText, error)

class DevelopCollection extends Base

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
  
  init: ->
    cache = @record.cache @url
    if cache?.length
      @callback cache, @record
    else
      @get()
      
  all: ->
    @ajaxQueue =>
      @ajax(
        type: "POST"
        url: base_url + 'photos/uri/' + @url
        data: JSON.stringify(@photos)
      ).done(@recordResponse)
       .fail(@failResponse)

  recordResponse: (uris) =>
    @callback uris, @record
    
  failResponse: (xhr, statusText, error) =>
    @record.trigger('ajaxError', xhr, statusText, error)
  
Dev =
  
  extended: ->
    
    Include =
      dev: (params, mode, callback, max) -> new DevelopCollection(@, params, mode, callback, max).get()
      
    Extend =
      dev: (method, params, callback, data) -> new Develop(@, method, params, callback, data).get()
      
    @include Include
    @extend Extend

Dev.Ajax = Ajax
module?.exports = Model.Dev = Dev