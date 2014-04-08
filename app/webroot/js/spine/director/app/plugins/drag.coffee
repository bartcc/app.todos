Spine = require("spine")
$      = Spine.$
Controller = Spine.Controller

Controller.Drag =
  
  extended: ->
    
    Include =
      init: ->
        Spine.dragItem = null
        
      dragstart: (e) ->
        el = $(e.target)
        el.addClass('dragged')
        return unless record = el.item()
        id = el.item()?.id
        
        Spine.dragItem = {}
        Spine.dragItem.el = el
        Spine.dragItem.els = []
        Spine.dragItem.source = el.item()
        parentEl = el.parents('.parent.data')
        Spine.dragItem.origin = parent = parentEl.data('tmplItem')?.data or parentEl.data('current')?.model.record
        
        @trigger('drag:start', e, id)
        
        data = []
        data.push item for item in parent.selectionList()
        
        event = e.originalEvent
        event.dataTransfer.effectAllowed = 'move'
        event.dataTransfer.setData('text/json', JSON.stringify(data));
        className = record.constructor.className
        switch className
          when 'Album'
            img = if data.length is 1 then App.ALBUM_SINGLE_MOVE else App.ALBUM_DOUBLE_MOVE
          when 'Photo'
            img = if data.length is 1 then App.IMAGE_SINGLE_MOVE else App.IMAGE_DOUBLE_MOVE
        event.dataTransfer?.setDragImage(img, 45, 60);

      dragenter: (e, data) ->
        func =  => @trigger('drag:timeout', e, Spine.timer)
        clearTimeout Spine.timer
        Spine.timer = setTimeout(func, 1000)
        @trigger('drag:enter', e, data)
        
      dragover: (e, data) ->
        event = e.originalEvent
        event.stopPropagation()
        event.preventDefault()
        @trigger('drag:over', e, @)

      dragleave: (e, data) ->
        @trigger('drag:leave', e, @)

      dragend: (e, data) ->
        $(e.target).removeClass('dragged')
        @trigger('drag:end', e, data)

      drop: (e, data) ->
        clearTimeout Spine.timer
        event = e.originalEvent
        data = event.dataTransfer.getData('text/json');
        data = JSON.parse(data)
        @trigger('drag:drop', e, data)
        
    @include Include

module?.exports = Drag = Controller.Drag