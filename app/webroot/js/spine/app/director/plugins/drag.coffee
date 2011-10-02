Spine ?= require("spine")
$      = Spine.$

Controller = Spine.Controller

Controller.Drag =
  
  extended: ->
    
    Include =
      init: ->
        Spine.dragItem = null

      dragstart: (e, data) =>
        event = e.originalEvent
        $(e.target).addClass('dragged')
        Spine.dragItem = $(e.target).item()
        event.dataTransfer.effectAllowed = 'move'
        event.dataTransfer.setData('text/html', Spine.dragItem);

      dragenter: (e, data) ->
        $(e.target).addClass('over')

      dragover: (e, data) ->
        event = e.originalEvent
        event.stopPropagation() if event.stopPropagation
        event.dataTransfer.dropEffect = 'move'
        false

      dragleave: (e, data) ->
        $(e.target).removeClass('over')

      dragend: (e, data) ->
        $(e.target).removeClass('dragged')

      drop: (e) =>
        event = e.originalEvent
        event.stopPropagation() if event.stopPropagation
        target = $(e.target).item()
        $(e.target).removeClass('over')
        Spine.trigger('drag:dropped', Spine.dragItem, target)
        Spine.dragItem = null
        false

    @include Include
