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

      cache: (url) ->
        cached = @cacheList()
        return unless cached
        for item in cached
          if item[url]
            return item[url]
        @initCache cached, url
        @cache url
         
      initCache: (cached, url) ->
        o = new Object()
        o[url]=[]
        cached.push o
        
      addToCache: (url, uris, mode) ->
#        if mode is 'html'
        cache = @cacheList()
        for item in cache
          if item[url]
            arr = item[url]
            arr[0...arr.length] = []
            arr.push uri for uri in uris
        cache
        
      destroyCache: (id) ->
        list = @cacheList()
        
        findIdFromObject = (id, obj) ->
          for key, value of obj
            arr = obj[key]
            for itm, idx in arr
              if itm[id]
                return arr.splice(idx, 1)
        
        findItemsFromArray = (items) ->
          for itm, ix in items
            findIdFromObject(id, itm)
        
        findItemsFromArray list
            
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