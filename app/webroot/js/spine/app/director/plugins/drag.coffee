Spine ?= require("spine")
$      = Spine.$

Controller = Spine.Controller

Controller.Drag =
  
  extended: ->
    
    Include =
      init: ->
        Spine.dragItem = null
        
      dragstart: (e, data) =>
        el = $(e.currentTarget)
        el.addClass('dragged')
        Spine.dragItem = {}
        Spine.dragItem.source = el.item()
        parentDataElement = $(e.target).parents('.data')
        Spine.dragItem.origin = parentDataElement.data().tmplItem?.data or parentDataElement.data()
        event = e.originalEvent
        event.dataTransfer.effectAllowed = 'move'
        event.dataTransfer.setData('text/html', Spine.dragItem);
        Spine.trigger('drag:start', e, @)

      dragenter: (e, data) ->
#        $(e.target).addClass('over')
        func =  -> Spine.trigger('drag:timeout', e)
        clearTimeout Spine.timer
        Spine.timer = setTimeout(func, 1000)
        Spine.trigger('drag:enter', e, @)

      dragover: (e, data) ->
        event = e.originalEvent
        event.stopPropagation() if event.stopPropagation
        event.dataTransfer.dropEffect = 'move'
        Spine.trigger('drag:over', e, @)
        false

      dragleave: (e, data) ->
#        el = $(e.target)
#        target = el.item()
#        el.removeClass('over')
        Spine.trigger('drag:leave', e, @)

      dragend: (e, data) ->
        $(e.target).removeClass('dragged')

      drop: (e) =>
        clearTimeout Spine.timer
        el = $(e.target)
        target = el.item()
        event = e.originalEvent
        event.stopPropagation() if event.stopPropagation
        el.removeClass('over nodrop')
        Spine.trigger('drag:drop', target, e)
        Spine.dragItem = null
        false

    @include Include
