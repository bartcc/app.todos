Spine ?= require("spine")
$      = Spine.$

Controller = Spine.Controller

Controller.Drag =
  
  extended: ->
    
    Include =
      init: ->
        Spine.dragItem = null
        
      dragstart: (e, data) =>
        console.log 'Drag::dragstart'
        el = $(e.target)
        el.addClass('dragged')
        Spine.dragItem = {}
        Spine.dragItem.el = el
        Spine.dragItem.source = el.item()
        parentDataElement = $(e.target).parents('.data')
        Spine.dragItem.origin = parentDataElement.data()?.tmplItem?.data or parentDataElement.data()?.current.record
        event = e.originalEvent
        event.dataTransfer.effectAllowed = 'move'
        event.dataTransfer.setData('text/html', Spine.dragItem);
        Spine.trigger('drag:start', e, @)

      dragenter: (e, data) ->
        console.log 'Drag::dragenter'
#        $(e.target).addClass('over')
        func =  -> Spine.trigger('drag:timeout', e)
        clearTimeout Spine.timer
        Spine.timer = setTimeout(func, 1000)
        Spine.trigger('drag:enter', e, @)

      dragover: (e, data) ->
        console.log 'Drag::dragover'
        event = e.originalEvent
        event.stopPropagation()
        event.dataTransfer.dropEffect = 'move'
        Spine.trigger('drag:over', e, @)
        false

      dragleave: (e, data) ->
        console.log 'Drag::dragleave'
        Spine.trigger('drag:leave', e, @)

      dragend: (e, data) ->
        console.log 'Drag::dragend'
        $(e.target).removeClass('dragged')

      drop: (e, data) =>
        console.log 'Drag::drop'
        console.log data
        clearTimeout Spine.timer
        event = e.originalEvent
        Spine.dragItem?.el.removeClass('dragged')
        Spine.trigger('drag:drop', e, data)
#        event.stopPropagation()
        
    @include Include
