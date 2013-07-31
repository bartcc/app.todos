Spine  = require('spine')
$      = Spine.$
Model  = Spine.Model
Gallery        = require('models/gallery')
Album          = require('models/album')
Photo          = require('models/photo')
AlbumsPhoto    = require('models/albums_photo')
GalleriesAlbum = require('models/galleries_album')
require('spine/lib/ajax')

class Builder
  
  constructor: (@record) ->
    @data = {}
    @model = @record.constructor
    @foreignModels = @model.foreignModels?()

  newWrapper: (key) ->
    throw('No classname found') unless key.className
    data = {}
    data[key.className] = {}
    data
    
  build: ->
    # for HABTM
    if @foreignModels
      @fModels = for key, value of @foreignModels
        @foreignModels[key]

      for key in @fModels
        model = Model[key.className]
        records = model.filterRelated @record.id,
          key: key.foreignKey
          joinTable: key.joinTable

        selected = @newWrapper model
        selected[model.className] = @model.toID(records)
        @data[model.className] = selected

    @data[@model.className] = @record
    @data[@model.className]

class Request extends Spine.Singleton
  constructor: (@record) ->
    super
    @data = new Builder(@record).build()
  
  create: (params, options) ->
    @ajaxQueue(
      params,
      type: "POST"
      data: JSON.stringify(@data)
      url:  Spine.Ajax.getURL(@model)
    ).done(@recordResponse(options))
     .fail(@failResponse(options))

  update: (params, options) ->
    @ajaxQueue(
      params,
      type: "PUT"
      data: JSON.stringify(@data)
      url:  Spine.Ajax.getURL(@record)
    ).done(@recordResponse(options))
     .fail(@failResponse(options))

AjaxRelations =
  
  extended: ->
    
    Include =
      ajax: -> new Request @
      
      
    @include Include
    
module?.exports = Model.AjaxRelations = AjaxRelations