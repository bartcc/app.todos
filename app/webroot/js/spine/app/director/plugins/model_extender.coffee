Spine ?= require("spine")
$      = Spine.$
Model  = Spine.Model

Model.Extender =

  extended: ->

    Extend =
      
      record: false
      
      selection: [global:[]]

      changed: ->
        !(@oldPrevious is @record) or !(@pevious or (@record?.id is @previous.id))

      current: (recordOrID) ->
        rec = false
        id = recordOrID?.id or recordOrID
        rec = @find(id) if @exists(id)
        @oldPrevious = @previous
        @previous = rec
        @record = rec

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
                res.push obj[key]
              else introspect obj[key]
          
          if @isArray(obj)
            for val in obj
              introspect val

        for obj in json
          introspect(obj)
        res
      
      selectionList: (recordID) =>
        id = recordID or @record?.id
        return @selection[0].global unless id
        for item in @selection
          return item[id] if item[id]

      updateSelection: (list, id) ->
        @emptySelection list, id

      emptySelection: (list = [], id) ->
        originalList = @selectionList(id)
        originalList[0...originalList.length] = list
        @trigger('change:selection', originalList)
        originalList

      removeFromSelection: (model, id) ->
        record = @find(id) if @exists(id)
        return unless record
        list = model.selectionList()
        record.remove list
        @trigger('change:selection', list)
        list

      isArray: (value) ->
        Object::toString.call(value) is "[object Array]"

      isObject: (value) ->
        Object::toString.call(value) is "[object Object]"

      selected: ->
        @record
        
      toID: (records = @records) ->
        ids = for record in records
          record.id
      
      errorHandler: (record, xhr, statusText, error) ->
        status = xhr.status
        unless status is 200
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
        
      customErrorHandler: (record, xhr) ->
        console.log record
        console.log xhr
        status = xhr.status
        unless status is 200
          error = new Error
            flash       : '<strong style="color:red">Login failed</strong>'
            xhr         : xhr

          error.save()
          User.redirect 'users/login'
          
    Include =
      
      selectionList: ->
        @constructor.selectionList @id

      updateSelection: (list) ->
        @constructor.updateSelection list, @id

      emptySelection: (list) ->
        @constructor.emptySelection list, @id

      addRemoveSelection: (model, isMetaKey) ->
        list = model.selectionList()
        return unless list
        unless isMetaKey
          @addUnique(list)
        else
          @addRemove(list)
        model.trigger('change:selection', list)
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
        @constructor.trigger('change:selection', list)
        list

      addRemove: (list) ->
        unless @id in list
          list.push @id
        else
          index = list.indexOf(@id)
          list.splice(index, 1) unless index is -1
        @constructor.trigger('change:selection', list)
        list

      remove: (list) ->
        index = list.indexOf(@id)
        list.splice(index, 1) unless index is -1
        @constructor.trigger('change:selection', list)
        list
 

    @extend Extend
    @include Include

    