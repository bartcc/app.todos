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
#        console.log @caches
        throw 'record is not configured '

      cache: (record, url) ->
        cached = @cacheList record?.id
#        console.log 'testing cache for ' + record?.constructor.className + ' ' + record?.id
        return unless cached
        for item in cached
          if item[url]
            return item[url]
#        return false
        @initCache cached, url
        @cache record, url
         
      initCache: (cached, url) ->
#        cached = @cacheList record?.id
        o = new Object()
        o[url]=[]
        cached.push o
         
      addToCache: (record, url, uris, mode) ->
        cache = @cacheList record?.id
        if mode is 'append'
          cache = @cache(record, url)
          cache.push uri for uri in uris
        else if uris.length
          o = new Object()
          o[url] = uris
          cache[0...cache.length] = []
          cache.push o
        cache
        
      removeFromCache: (record) ->
        console.log 'removing from cache'
        for item, index in @caches
          if item[record.id]
            spliced = @caches.splice index, 1
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