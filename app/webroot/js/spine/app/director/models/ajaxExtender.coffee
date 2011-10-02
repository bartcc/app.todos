Spine ?= require("spine")
$      = Spine.$
Model  = Spine.Model

class Request extends Base
  constructor: (@record) ->
    @data = {}
    
    @model = @record.constructor
    @foreignModel = Spine.Model[@model.foreignModel]
    @joinTable = Spine.Model[@model.joinTable]
    @associationForeignKey = @model.associationForeignKey
    @foreignKey = @model.foreignKey

    if @foreignModel and @foreignModel.record
      @data[@foreignModel.className] = @foreignModel.record
    @data[@model.className] = @record
    
  
  find: (params) ->
    @ajax(
      params,
      type: "GET"
      url:  @url
    )
  
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
    if @joinTable
      data = {}
      list = @joinTable.findAllByAttribute(@foreignKey, @model.record.id)
      ids = for item in list
        item[@associationForeignKey]
      data[@foreignModel.className] = ids
      @data[@foreignModel.className] = data
    @queue =>
      @ajax(
        params,
        type: "PUT"
        data: JSON.stringify(@data)
        url:  Ajax.getURL(@record)
      ).success(@recordResponse)
       .error(@errorResponse)
  
  destroy: (params) ->
    @queue =>
      @ajax(
        params,
        type: "DELETE"
        url:  Ajax.getURL(@record)
      ).success(@recordResponse)
       .error(@errorResponse)  

  # Private

  recordResponse: (data, status, xhr) =>
    @record.trigger("ajaxSuccess", @record, status, xhr)
    
    return if Spine.isBlank(data)
    data = @model.fromJSON(data)
    
    Ajax.disable =>        
      # ID change, need to do some shifting
      if data.id and @record.id isnt data.id
        @record.changeID(data.id)

      # Update with latest data
      @record.updateAttributes(data.attributes())      
      
  blankResponse: (data, status, xhr) =>
    @record.trigger("ajaxSuccess", @record, status, xhr)

  errorResponse: (xhr, statusText, error) =>
    @record.trigger("ajaxError", @record, xhr, statusText, error)

Model.AjaxExtender =
  
  extended: ->
    
    Include =
      ajax: -> new Request(this)
      
    @include Include