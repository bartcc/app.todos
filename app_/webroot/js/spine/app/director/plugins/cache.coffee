Spine ?= require("spine")
$      = Spine.$
Model  = Spine.Model

Model.Cache =

  extended: ->

    Extend =
      
      caches: [global:[]]
      
      cacheList: (recordID) =>
        id = recordID or 'global'
        return unless id
        for item in @caches
          return item[id] if item[id]

      cache: (record, url) ->
        cache = @cacheList record?.id
        return unless cache
        for item in cache
          return item[url] if item[url]
        dummy = {}
        dummy[url]=[]
        cache.push dummy
        return @cache record, url
          
      addToCache: (record, url, uri, mode) ->
        cache = @cacheList record?.id
        return unless cache
        if mode is 'append'
          cache = @cache(record, url)
          cache.push ur for ur in uri
        else
          dummy = {}
          dummy[url] = uri
          cache[0...cache.length] = []
          cache.push dummy# unless @cache(record, url)
        cache

      removeFromCache: (record) ->
        for item in @caches
          if item[record.id]
            spliced = @caches.splice index,1
            return spliced

      clearCache: (id) ->
        originalList = @cacheList(id)
        originalList[0...originalList.length] = [] if originalList
        originalList
          
    Include =
      
      cache: (url) ->
        @constructor.cache @, url

      addToCache: (url, uri, mode) ->
        @constructor.addToCache(@, url, uri, mode)

      removeFromCache: ->
        @constructor.removeFromCache @

      clearCache: ->
        list = @constructor.clearCache @id
 

    @extend Extend
    @include Include