Spine ?= require("spine")
$      = Spine.$

Controller = Spine.Controller

Controller.Sort =
  
  extended: ->
    
    Include =
      init: ->
        Spine.sortItem = null
        
      sortstart: (e) ->
        dt = e.originalEvent.dataTransfer

        dt.setData "Text", JSON.stringify
          html:   options.text( item )
          type:   options.type

        # dt.setData("URL", options.type );
        $('._dragging').removeClass('_dragging')
        item.addClass('_dragging')
        
        Spine.trigger('sort:dragstart', e, @)
        return true
        
      sortend: (e) ->
        $('._dragging').removeClass('_dragging')
        $('li.' + options.css).remove()

        try
          unless (JSON.parse( e.originalEvent.dataTransfer.getData("Text") ).type is options.type)
            return true
        catch e
          return true

        return false
        
      sortenter: (e) ->
        try
          unless (e.originalEvent.dataTransfer.getData("Text") && JSON.parse( e.originalEvent.dataTransfer.getData("Text") ).type is options.type)
            return true
        catch e
          return true
        
        Spine.trigger('sort:dragenter', e, @)
        return false
        
      sortleave: (e) ->
        try
          unless (e.originalEvent.dataTransfer.getData("Text") && JSON.parse( e.originalEvent.dataTransfer.getData("Text") ).type is options.type)
            return true;
        catch e
          return true

        $('li.'+options.css).remove()
        
        Spine.trigger('sort:dragleave', e, @)
        return false
        
      sort: (e, data) ->
        try
          unless (JSON.parse( e.originalEvent.dataTransfer.getData("Text") ).type is options.type)
            return true
        catch e
          return true
          
        source = $('._dragging')
        $('li.'+options.css).remove()

        it = $( JSON.parse( e.originalEvent.dataTransfer.getData('Text') ).html ).hide()

        if ( e.pageY - $(@).position().top > $(@).height() )
          it.insertAfter @
        else
          it.insertBefore @
        
        # -> initSortItem it
        
        # data not saved
        if ( !options.drop( $src.get(0), it.get(0) ) )
          it.remove()
          return false

        source.remove()
        it.fadeIn()
        
        Spine.trigger('sort:drop', e, @)
        return false
        
      sortover: (e, data) ->
        try
          unless (e.originalEvent.dataTransfer.getData("Text") && JSON.parse( e.originalEvent.dataTransfer.getData("Text") ).type is options.type)
            return true
        catch e
          return true

        $('li.'+options.css).remove()

        if ( e.pageY - $(this).position().top > $(@).height() )
          $('<li class="'+options.css+'"></li>').insertAfter @
        else
          $('<li class="'+options.css+'"></li>').insertBefore @

        Spine.trigger('sort:dragover', e, @)
        return false
        
        
      initSortItem_: (item, options) ->
        
        options.drag_target( item ).attr('draggable', true)
        .bind 'dragstart', (e) ->
          
          dt = e.originalEvent.dataTransfer
          
          dt.setData "Text", JSON.stringify
            html:   options.text( item )
            type:   options.type
          
          # dt.setData("URL", options.type );
          $('._dragging').removeClass('_dragging')
          item.addClass('_dragging')
          
          return true
          
        .bind 'dragend', (e) ->
          
          $('._dragging').removeClass('_dragging')
          $('li.' + options.css).remove()
          
          try
            unless (JSON.parse( e.originalEvent.dataTransfer.getData("Text") ).type is options.type)
              return true
          catch e
            return true
          
          return false
          
        .bind 'dragenter', (e) ->
          
          try
            unless (e.originalEvent.dataTransfer.getData("Text") && JSON.parse( e.originalEvent.dataTransfer.getData("Text") ).type is options.type)
              return true
          catch e
            return true
            
          return false
          
        .bind 'dragleave', (e) ->
          
          try
            unless (e.originalEvent.dataTransfer.getData("Text") && JSON.parse( e.originalEvent.dataTransfer.getData("Text") ).type is options.type)
              return true;
          catch e
            return true
          
          $('li.'+options.css).remove()
          
          return false
          
        .bind 'drop', (e) ->
        
          try
            unless (JSON.parse( e.originalEvent.dataTransfer.getData("Text") ).type is options.type)
              return true
          catch e
            return true
	                
          source = $('._dragging')
          $('li.'+options.css).remove()
	                
          it = $( JSON.parse( e.originalEvent.dataTransfer.getData('Text') ).html ).hide()
	                
          if ( e.pageY - $(@).position().top > $(@).height() )
            it.insertAfter @
          else
            it.insertBefore @
          
          _initItem it
	                
          # data not saved
          if ( !options.drop( $src.get(0), $item.get(0) ) )
            it.remove()
            return false
          
          source.remove()
          it.fadeIn()
          return false
          
        .bind 'dragover', (e) ->
          
          try
            unless (e.originalEvent.dataTransfer.getData("Text") && JSON.parse( e.originalEvent.dataTransfer.getData("Text") ).type is options.type)
              return true
          catch e
            return true
          
          $('li.'+options.css).remove()
          
          if ( e.pageY - $(this).position().top > $(@).height() )
            $('<li class="'+options.css+'"></li>').insertAfter @
          else
            $('<li class="'+options.css+'"></li>').insertBefore @
          
          return false
        
      dragstart: (e, data) =>
        console.log 'Sort::sortstart'
        el = $(e.target)
        el.addClass('dragged')
        Spine.sortItem = {}
        Spine.sortItem.el = el
        Spine.sortItem.source = el.item()
        parentDataElement = $(e.target).parents('.data')
        Spine.sortItem.origin = parentDataElement.data()?.tmplItem?.data or parentDataElement.data()?.current.record
        event = e.originalEvent
        event.dataTransfer.effectAllowed = 'move'
        event.dataTransfer.setData('text/html', Spine.sortItem);
        Spine.trigger('sort:start', e, @)

      dragenter: (e, data) ->
        console.log 'Sort::dragenter'
#        $(e.target).addClass('over')
        func =  -> Spine.trigger('sort:timeout', e)
        clearTimeout Spine.timer
        Spine.timer = setTimeout(func, 1000)
        Spine.trigger('sort:enter', e, @)

      dragover: (e, data) ->
        console.log 'Sort::dragover'
        event = e.originalEvent
        event.stopPropagation()
        event.dataTransfer.dropEffect = 'move'
        Spine.trigger('sort:over', e, @)
        false

      dragleave: (e, data) ->
        console.log 'Sort::dragleave'
        Spine.trigger('sort:leave', e, @)

      dragend: (e, data) ->
        console.log 'Sort::dragend'
        $(e.target).removeClass('dragged')

      drop: (e, data) =>
        console.log 'Sort::drop'
        console.log data
        clearTimeout Spine.timer
        event = e.originalEvent
        Spine.sortItem?.el.removeClass('dragged')
        Spine.trigger('sort:drop', e, @)
#        event.stopPropagation()
        
    @include Include
