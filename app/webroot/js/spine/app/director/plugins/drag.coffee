Spine ?= require("spine")
$      = Spine.$

Controller = Spine.Controller

Controller.Drag =
  
  extended: ->
    
    Include =
      init: ->
        Spine.dragItem = null

      dragstart: (e, data) =>
        el = $(e.target)
        target = el.item()
        el.addClass('dragged')
        Spine.dragItem = {}
        Spine.dragItem.source = el.item()
        #Spine.dragItem.origin = $(e.target).item()
        event = e.originalEvent
        event.dataTransfer.effectAllowed = 'move'
        event.dataTransfer.setData('text/html', Spine.dragItem);
        Spine.trigger('drag:start', e)

      dragenter: (e, data) ->
#        $(e.target).addClass('over')
        Spine.trigger('drag:enter', e)

      dragover: (e, data) ->
        event = e.originalEvent
        event.stopPropagation() if event.stopPropagation
        event.dataTransfer.dropEffect = 'move'
        Spine.trigger('drag:over', e)
        false

      dragleave: (e, data) ->
#        el = $(e.target)
#        target = el.item()
#        el.removeClass('over')
        Spine.trigger('drag:leave', e)

      dragend: (e, data) ->
        $(e.target).removeClass('dragged')

      drop: (e) =>
        el = $(e.target)
        target = el.item()
        event = e.originalEvent
        event.stopPropagation() if event.stopPropagation
        el.removeClass('over nodrop')
        Spine.trigger('drag:drop', target, e)
        Spine.dragItem = null
        false

    @include Include
