Spine ?= require("spine")
$      = Spine.$
Model  = Spine.Model

Model.Extender =

  extended: ->

    Extend =
      
      record: false

      selection: [global:[]]

      fromJSON: (objects) ->
        @createJoinTables objects
        key = @className
        json = @fromArray(objects, key) if @isArray(objects)# and objects[key]#test for READ or PUT !
        json || @__super__.constructor.fromJSON.call @, objects

      createJoinTables: (arr) ->
        return unless @isArray(arr)
        joinTables = @joinTables()
 
        for key in joinTables
          Spine.Model[key].refresh(@createJoin arr, key)
        
      joinTables: ->
        fModels = @foreignModels()
        joinTables = for key, value of fModels
          fModels[key]['joinTable']
        joinTables

      fromArray: (arr, key) ->
        res = []
        extract = (obj) =>
          unless @isArray obj[key]
            item = =>
              res.push new @(obj[key])
            itm = item()
        
        extract(obj) for obj in arr
        res
        
      createJoin: (json, tableName) ->
        res = []
        introspect = (obj) =>
          if @isObject(obj)
            for key, val of obj
              if key is tableName
                #res.push(new Spine.Model[tableName](obj[key]))
                res.push obj[key]
              else introspect obj[key]
          
          if @isArray(obj)
            for val in obj
              introspect val

        for obj in json
          introspect(obj)
        res
      

      selectionList: (recordID) =>
        id = recordID or @record.id
        return @selection[0].global unless id
        for item in @selection
          return item[id] if item[id]

      updateSelection: (list, id) ->
        @emptySelection list, id

      emptySelection: (list = [], id) ->
        originalList = @selectionList(id)
        originalList[0...originalList.length] = list
        originalList

      removeFromSelection: (model, id) ->
        record = @find(id) if @exists(id)
        return unless record
        list = model.selectionList()
        record.remove list
        list

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
        
      toID: (records = @records) ->
        ids = for record in records
          record.id
      
      errorHandler: (record, xhr, statusText, error) ->
        unless statusText.status is 200
          error = new Error
            record      : record
            xhr         : xhr
            statusText  : statusText
            error       : error

          error.save()
          User.redirect 'users/login'
          
        console.log record
        console.log xhr
        console.log statusText
        console.log error
        
        
    Include =
      
      selectionList: ->
        @constructor.selectionList @id

      updateSelection: (list) ->
        @constructor.updateSelection list, @id

      emptySelection: (list) ->
        @constructor.updateSelection list, @id

      addRemoveSelection: (model, isMetaKey) ->
        list = model.selectionList()
        return unless list
        unless isMetaKey
          @addUnique(list)
        else
          @addRemove(list)
        list

      #prevents an update if model hasn't changed
      updateChangedAttributes: (atts) ->
        origAtts = @attributes()
        for key, value of atts
          unless origAtts[key] is value
            invalid = yes
            @[key] = value

        @save() if invalid
        
      #private
      
      addUnique: (list) ->
        list[0...list.length] = [@id]

      addRemove: (list) ->
        unless @id in list
          list.push @id
        else
          index = list.indexOf(@id)
          list.splice(index, 1) unless index is -1
        list

      remove: (list) ->
        index = list.indexOf(@id)
        list.splice(index, 1) unless index is -1
        list
 

    @extend Extend
    @include Include

    