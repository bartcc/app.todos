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
    # for HABTM // hasMany Join Model
    if @foreignModels
      @fModels = for key, value of @foreignModels
        @foreignModels[key]

      for key in @fModels
        foreignRecords = Model[key.joinTable].filter @record.id,
          key: key.foreignKey
        
        @data[key.joinTable] = foreignRecords
    
    @data[@model.className] = @record
    @data

class Request extends Spine.Ajax.Singleton
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