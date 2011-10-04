Spine ?= require("spine")
$      = Spine.$
Model  = Spine.Model

Model.Extender =

  extended: ->

    Extend =
      
      record: false

      selection: [global:[]]

      joinTableRecords: {}

      fromJSON: (objects) ->
        Spine.joinTableRecords = @createJoinTables objects
        #@createJoinTables objects
        #console.log @joinTableRecords
        #@createJoinTables objects
        #json = @__super__.constructor.fromJSON.call @, objects
        key = @className
        json = @fromArray(objects, key) if @isArray(objects) #test for READ or PUT !
        json || @__super__.constructor.fromJSON.call @, objects

      createJoinTables_: (arr) ->
        console.log 'ModelExtender::createJoinTable'
        return unless @isArray(arr) or @isArray(@joinTables)
        table = {}
        res = @createJoin arr, table for table in @joinTables
        table[item.id] = item for item in res
        console.log table
        table

      createJoinTables: (arr) ->
        return unless @isArray(arr)
        table = {}
        joinTables = @joinTables()
 
        for key in joinTables
          Spine.Model[key].refresh(@createJoin arr, key )
        

      fromArray: (arr, key) ->
        res = []
        extract = (obj) =>
          unless @isArray obj[key]
            item = =>
              inst = new @(obj[key])
              res.push inst
            itm = item()
        
        extract(obj) for obj in arr
        res
        
      createJoin: (json, tableName) ->
        res = []
        introspect = (obj) =>
          if @isObject(obj)
            for key, val of obj
              if key is tableName then res.push(new Spine.Model[tableName](obj[key]))
              else introspect obj[key]
          
          if @isArray(obj)
            for val in obj
              introspect val

        for obj in json
          introspect(obj)
        #console.log tableName
        #console.log res
        res
      

      selectionList: =>
        id = @record.id
        return @selection[0].global unless id
        for item in @selection
          return item[id] if item[id]

      emptySelection: ->
        list = @selectionList()
        list[0...list.length] = []
        list

      removeFromSelection: (id) ->
        album = Album.find(id)
        album.addRemoveSelection @, true

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
        
      toId: (records = @records) ->
        #return null unless records.length
        ids = for record in records
          record.id
      
    Include =
      
      #prevents an update if model hasn't changed
      updateChangedAttributes: (atts) ->
        origAtts = @attributes()
        for key, value of atts
          unless origAtts[key] is value
            invalid = yes
            @[key] = value

        @save() if invalid

      addRemoveSelection: (model, isMetaKey) ->
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

 

    @extend Extend
    @include Include

    