Spine ?= require("spine")
$      = Spine.$
Model  = Spine.Model

class Builder
  constructor: (record) ->
    @data = {}
    @record = record
    @model = record.constructor
    @foreignModels = @model.foreignModels()

  newWrapper: (key) ->
    throw('No Classname found') unless key.className
    data = {}
    data[key.className] = {}
    data
    

  exec: ->
    @fModels = for key, value of @foreignModels
      @foreignModels[key]

    for key in @fModels
      model = Spine.Model[key.className]
      parent = Spine.Model[key.parent]
      records = model.filter(@record.id)

      selected = @newWrapper model
      selected[model.className] = @model.toID(records)
      @data[model.className] = selected

    @data[@model.className] = @record
    @data

class Request extends Singleton
  constructor: (@record) ->
    super
    @data = new Builder(@record).exec()
  
  create: (params) ->
    @queue =>
      @ajax(
        params,
        type: "POST"
        data: JSON.stringify(@data)
        url:  Ajax.getURL(@model)
      ).success(@recordResponse)
       .error(@errorResponse)

  update: (params) ->
    @queue =>
      @ajax(
        params,
        type: "PUT"
        data: JSON.stringify(@data)
        url:  Ajax.getURL(@record)
      ).success(@recordResponse)
       .error(@errorResponse)

Model.AjaxExtender =
  
  extended: ->
    
    Include =
      ajax: -> new Request @
      
    @include Include