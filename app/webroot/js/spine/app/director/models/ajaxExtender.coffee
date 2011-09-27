Spine ?= require("spine")
$      = Spine.$
Model  = Spine.Model

Singleton.Extender =

  extended: ->
    include = 

      create: (params) ->
        console.log 'create'
        @send params,
              type:    "DELETE"
              data:    ''#JSON.stringify(@record)
              url:     @base
              #success: @recordResponse(params)
              #error: @errorResponse(params)

      destroy: (params) ->
        console.log 'destroy'
        @send params,
              type:    "DELETE"
              url:     @url
              success: @blankResponse(params)
              error: @errorResponse(params)

      update: (params) ->
        console.log 'update'
        @send params,
              type:    "PUT"
              data:    JSON.stringify(@records)
              url:     @url
              success: @recordResponse(params)
              error:   @errorResponse(params)

      empty: (atts) ->


    @extend include

    