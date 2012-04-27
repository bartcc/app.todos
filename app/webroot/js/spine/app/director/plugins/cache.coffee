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
        throw 'record ' + id + ' is not configured '

      cache: (record, url) ->
        cached = @cacheList record?.id
        return unless cached
        for item in cached
          if item[url]
            return item[url]
        @initCache cached, url
        @cache record, url
         
      initCache: (cached, url) ->
        o = new Object()
        o[url]=[]
        cached.push o
         
      addToCache: (record, url, uris, mode) ->
        if mode is 'html'
          cache = @cacheList record?.id
          for item in cache
            if item[url]
              arr = item[url]
              arr[0...arr.length] = []
              arr.push uri for uri in uris
        else if uris.length
          cache = @cache(record, url)
          cache.push uri for uri in uris
        cache
        
      destroyCache: (id) ->
        for item, index in @caches
          if item[id]
            spliced = @caches.splice index, 1
            return spliced

      clearCache: (id) ->
        originalList = @cacheList(id)
        originalList[0...originalList.length] = [] #if originalList
        originalList
          
    Include =
      
      cache: (url) ->
        @constructor.cache @, url

      addToCache: (url, uri, mode) ->
        @constructor.addToCache(@, url, uri, mode)

      destroyCache: ->
        @constructor.destroyCache @id

      clearCache: ->
        list = @constructor.clearCache @id
 

    @extend Extend
    @include Include