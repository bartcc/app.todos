Spine ?= require("spine")
$      = Spine.$
Model  = Spine.Model

Model.Extender =

  extended: ->

    extend =
      
      record: false

      selection: [global:[]]

      joinTableRecords: {}

      fromJSON: (objects) ->
        @joinTableRecords = @createJoinTables objects
        #json = @__super__.constructor.fromJSON.call @, objects
        key = @className
        json = @fromArray(objects, key) if @isArray(objects) #test for READ or PUT !
        json || @__super__.constructor.fromJSON.call @, objects
        
      createJoinTables: (arr) ->
        return unless @isArray(arr)
        table = {}
        console.log @className
        if @joinTables?.length
          keys = []
          keys.push key for key in @joinTables

          res = @introspectJSON arr, key for key in keys
          
          table[item.id] = item for item in res
        table

      fromArray: (arr, key) ->
        res = []
        extract = (val) =>
          unless @isArray val[key]
            item = =>
              inst = new @(val[key])
              res.push inst
            itm = item()
        
        extract(value) for value in arr
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
      

      selectionList: =>
        id = @record.id
        for item in @selection
          return item[id] if item[id]
        return @selection[0].global

      isArray: (value) ->
        Object::toString.call(value) is "[object Array]"

      isObject: (value) ->
        Object::toString.call(value) is "[object Object]"

      current: (record) ->
        rec = false
        rec = @find(record.id) if @exists(record?.id)
        @record = rec
        @record or false

      selected: ->
        @record
      
    include =
      
      #prevents an update if model hasn't changed
      updateChangedAttributes: (atts) ->
        origAtts = @attributes()
        for key, value of atts
          unless origAtts[key] is value
            invalid = yes
            @[key] = value

        @save() if invalid

      addToSelection: (model, isMetaKey) ->
        list = model.selectionList()
        return unless list
        unless isMetaKey
          @addUnique(model, list)
        else
          @addRemove(model, list)
        list
      
      #private
      
      addUnique: (model, list) ->
        list[0...list.length] = [@id]

      addRemove: (model, list) ->
        unless @id in list
          list.push @id
        else
          index = list.indexOf(@id)
          list.splice(index, 1)
        list
 

    @extend extend
    @include include

    