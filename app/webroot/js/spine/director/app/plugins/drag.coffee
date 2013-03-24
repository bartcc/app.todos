Spine = require("spine")
$      = Spine.$
Controller = Spine.Controller

Controller.Drag =
  
  extended: ->
    
    Include =
      init: ->
        Spine.dragItem = null
        
      dragstart: (e, data) =>
        el = $(e.target)
        el.addClass('dragged')
        Spine.dragItem = {}
        Spine.dragItem.el = el
        Spine.dragItem.source = el.item()
        console.log "Spine.dragItem.source"
        console.log Spine.dragItem.source
        parentDataElement = $(e.target).parents('.parent.data')
        console.log "$(e.target).parents('.parent.data')"
        console.log parentDataElement
        Spine.dragItem.origin = parentDataElement.data()?.tmplItem?.data or parentDataElement.data()?.current.record
        event = e.originalEvent
        event.dataTransfer?.effectAllowed = 'move'
        event.dataTransfer?.setData('text/html', Spine.dragItem);
        Spine.trigger('drag:start', e, @)

      dragenter: (e, data) ->
#        $(e.target).addClass('over')
        func =  -> Spine.trigger('drag:timeout', e)
        clearTimeout Spine.timer
        Spine.timer = setTimeout(func, 1000)
        Spine.trigger('drag:enter', e, @)
        
      dragover: (e, data) ->
        event = e.originalEvent
        event.stopPropagation()
        event.preventDefault()
        event.dataTransfer?.dropEffect = 'move'
        Spine.trigger('drag:over', e, @)

      dragleave: (e, data) ->
        Spine.trigger('drag:leave', e, @)

      dragend: (e, data) ->
        $(e.target).removeClass('dragged')

      drop: (e, data) =>
        clearTimeout Spine.timer
        event = e.originalEvent
        Spine.dragItem?.el.removeClass('dragged')
        Spine.trigger('drag:drop', e, data)
        
    @include Include

module?.exports = Drag = Controller.Drag