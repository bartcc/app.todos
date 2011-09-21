Spine ?= require("spine")
$      = Spine.$
Model  = Spine.Model

Model.Extender =

  extended: ->
    extend =
      joinTableRecords: {}
      fromJSON: (objects) ->
        @createJoinTables objects
        json = @__super__.constructor.fromJSON.call @, objects
        key = @className
        json = @fromArray(json, key) if @isArray(json) #test for READ or PUT !
        json
        
      createJoinTables: (arr) ->
        return unless @isArray(arr)
        if @joinTables and @joinTables.length
          keys = []
          keys.push key for key in @joinTables

          res = @introspectJSON arr, key for key in keys
          for item in res
            @joinTableRecords[item.id] = item
          #console.log @joinTableRecords

      fromArray: (arr, key) ->
        res = []
        extract = (val, key) =>
          unless @isArray val[key]
            item = =>
              new @(val[key])
            itm = item()
            if itm.id then res.push itm
        
        extract(value, key) for value in arr
        res

      introspectJSON: (json, jointable) ->
        res = []
        introspect = (obj) =>
          if @isObject(obj)
            for key, val of obj
              if key is jointable then res.push(new window[jointable](obj[key]))
              else introspect obj[key]
          
          if @isArray(obj)
            for val in obj
              introspect val

        for obj in json
          introspect(obj)
        res

      isArray: (value) ->
        Object::toString.call(value) is "[object Array]"

      isObject: (value) ->
        Object::toString.call(value) is "[object Object]"
      
    include =
      #prevents an update if model hasn't changed
      updateChangedAttributes: (atts) ->
        origAtts = @attributes()
        for key, value of atts
          unless origAtts[key] is value
            invalid = yes
            @[key] = value

        @save() if invalid

    @extend extend
    @include include

    