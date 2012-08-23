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
#        console.log item
        throw 'record ' + id + ' is not configured '
        
      # returns array container
      cache: (url, id) ->
        cached = @cacheList(id)
        return unless cached
        for item in cached  
          # find the url
          for key, val of item
            return val if item[url]
         
      initCache: (id) ->
        arr = @caches
        arr.push(@hash(id))
        arr
        
      hash: (key) ->
        o = new Object()
        o[key]=[]
        o
        
      hasCache: (url, id) ->
        !!(@cache(url, id).length)
        
      addToCache: (url, uris) ->
        for uri in uris
          for key, val of uri
            item = @cacheList(key)
            item.push(@hash(url)) unless @keyExists.call(item, url)
            for itm in item
              if itm_url = itm[url]
                itm_url[0...itm_url.length] = []
                itm_url.push uri
                
      # test the existence of item that has item-object-key in an array
      # returns the item itself if true
      itemExists: (item) ->
        for key, val of item
          for thisItem in @
            return thisItem if thisItem[key]
        false
        
      # returns the item itself if true
      keyExists: (key) ->
        for thisItem in @
          return thisItem if thisItem[key]
        false
      
      addToCache_: (url, uris) ->
#        alert 'ADD TO CACHE'
#        console.log url
#        console.log uris
#        if mode is 'html'
        cache = @cacheList()
        url_ = ->
          for item in cache
            return item[url] if item[url]
            
          urlObj = {}
          urlObj[url] = []
          cache.push urlObj
          urlObj[url]
#            console.log arr
#            arr[0...arr.length] = []
#            arr.push uri for uri in uris
        uri_ = (arr) ->
          for uri in uris
            arr.push uri
            
        uri_(url_())
        
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
        
#        findItemsFromArray list
        
        for itm, idx in list
          if itm[id]
            list.splice(idx,1)
            
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