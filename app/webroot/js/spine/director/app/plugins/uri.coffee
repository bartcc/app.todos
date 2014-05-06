Spine   = require("spine")
$       = Spine.$
Model   = Spine.Model
Gallery = require('models/gallery')
Album   = require('models/album')
Photo   = require('models/photo')
AlbumsPhoto    = require('models/albums_photo')
GalleriesAlbum = require('models/galleries_album')

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
#    
  ajaxQueue: (callback) ->
    Ajax.queue(callback)
    
  get: ->
    @ajaxQueue =>
      @ajax(
        type: "POST"
        url: base_url + 'photos/uri/' + @url
        data: JSON.stringify(@data)
      ).done(@recordResponse)
       .fail(@failResponse)
       
  uri: (options) ->
    options.width + '/' + options.height + '/' + options.square + '/' + options.quality
    
class URI extends Base
  constructor: (@model,  params, @callback, @data = []) ->
    super
    options = $.extend({}, @settings, params)
    @url = @uri options
    
    return unless @data.length
  settings:
    square: 1
    quality: 70
    
  init: ->
    @get() unless @cache()
    
  cache: ->
    return unless Ajax.cache #force ajax call for empty data
    res = []
    for data, idx in @data
      raw = (@model.cache @url, data.id)
      if raw
        res.push raw
      else
        return
      
    @callback res
    return true
      
  recordResponse: (uris) =>
    @model.addToCache @url, uris
    @callback uris
    
  failResponse: (xhr, statusText, error) =>
    @model.trigger('ajaxError', xhr, statusText, error)

class URICollection extends Base
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
    @record.addToCache @url, uris, @mode
    @callback uris, @record
    
  failResponse: (xhr, statusText, error) =>
    @record.trigger('ajaxError', xhr, statusText, error)
  
Uri =
  
  extended: ->
    
    Include =
      uri: (params, mode, callback, max) -> new URICollection(@, params, mode, callback, max).init()
      
    Extend =
      uri: (params, callback, data) -> new URI(@, params, callback, data).init()
      
    @include Include
    @extend Extend

Uri.Ajax = Ajax
module?.exports = Model.Uri = Uri