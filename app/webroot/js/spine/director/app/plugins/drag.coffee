Spine = require("spine")
$      = Spine.$

Gallery         = require('models/gallery')
Album           = require('models/album')
Photo           = require('models/photo')
AlbumsPhoto     = require('models/albums_photo')
GalleriesAlbum  = require('models/galleries_album')

Controller = Spine.Controller

Controller.Drag =
  
  extended: ->
    
    Include =
      init: ->
        Spine.dragItem = null
        
      dragstart: (e) ->
        
        event = e.originalEvent
        el = $(e.target)
        
        #cancel all drag events for no-data-elements
        unless record = el.item()
          e.stopPropagation()
          e.preventDefault()
          return
          
        parentEl = el.parents('.data')
        parentModel = parentEl.data('tmplItem')?.data.constructor or parentEl.data('current')?.model
        parentRecord = parentEl.data('tmplItem')?.data or parentModel?.record or parentModel
        
        Spine.dragItem = {}
        Spine.dragItem.el = el
        Spine.dragItem.els = []
        Spine.dragItem.source = record
        Spine.dragItem.origin = parentRecord
        
        @trigger('drag:help', e, record, parentRecord)
        @trigger('drag:start', e, @, record)
        
        parentEl.addClass('drag-in-progress')
        
        if parentModel
          data = []
          data.update parentRecord.selectionList() 
        else
          return
        
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
        $('.drag-in-progress').removeClass('drag-in-progress')
        @trigger('drag:end', e, data)

      drop: (e, data) ->
        $('.drag-in-progress').removeClass('drag-in-progress')
        clearTimeout Spine.timer
        event = e.originalEvent
        data = event.dataTransfer.getData('text/json');
        try
          data = JSON.parse(data)
        catch e
        @trigger('drag:drop', e, data)
        
      # helper methods
        
      dragHelp: (e, item, origin) ->
        if origin.selectionList().indexOf(item.id) is -1
          item.constructor.trigger('activate', item.id, origin)
        
      dragStart: (e, controller, record) ->
        console.log 'dragStart'
        el = $(e.currentTarget)
        event = e.originalEvent
        source = Spine.dragItem.source
        Spine.dragItem.targetEl = null
        Spine.selection = new Array
        unless source
          alert 'no source'
          return
        # check for drags from sublist and set its origin
        if el.parents('#sidebar').length
          originEl = el.parents('.gal.data')
          origin = originEl.item()
          selection = origin.selectionList().slice(0)
#          Spine.dragItem.origin = origin
        else
          switch source.constructor.className
            when 'Album'
              selection = Gallery.selectionList().slice(0)
            when 'Photo'
              selection = Album.selectionList().slice(0)

        Spine.selection.update selection

      dragEnter: (e) ->
        console.log 'dragEnter'
        return unless Spine.dragItem
        el = indicator = $(e.target).closest('.data')
        selector = el.attr('data-drag-over')
        if selector then indicator = el.children('.'+selector)
        
        target = Spine.dragItem.target = el.data('tmplItem')?.data or el.data('current')?.model.record
        source = Spine.dragItem.source
        origin = Spine.dragItem.origin
        
        Spine.dragItem.closest?.removeClass('over nodrop')
        Spine.dragItem.closest = indicator
        
        if @validateDrop target, source, origin
          Spine.dragItem.closest.addClass('over')

      dragOver: (e) =>

      dragLeave: (e) =>

      dragEnd: (e) =>
        Spine.dragItem.closest?.removeClass('over nodrop')

      dragDrop: (e, record) ->
        return unless Spine.dragItem # for image drops  
        console.log 'dragDrop'
        target = Spine.dragItem.target
        source = Spine.dragItem.source
        origin = Spine.dragItem.origin
        
        Spine.dragItem.closest?.removeClass('over nodrop')
        
        return unless @validateDrop target, source, origin
        
        hash = location.hash
        switch source.constructor.className
          when 'Album'
            selection = Spine.selection
            
            Album.trigger('destroy:join', selection, origin) if !@isCtrlClick(e) and origin
            Album.trigger('create:join', selection, target, => @navigate hash)

          when 'Photo'
            selection = Spine.selection
            photos = Photo.toRecords(selection)

            Photo.trigger 'create:join',
              photos: selection
              album: target
            , -> @navigate hash
            
            unless @isCtrlClick(e)
              Photo.trigger 'destroy:join',
                photos: selection
                album: origin
        
      validateDrop: (target, source, origin) =>
        return unless target
        switch source.constructor.className
          when 'Album'
            unless target.constructor.className is 'Gallery'
              return false
            unless (origin.id != target.id)
              return false

            items = GalleriesAlbum.filter(target.id, key: 'gallery_id')
            for item in items
              if item.album_id is source.id
                return false
            return true
          when 'Photo'
            unless target.constructor.className is 'Album'
              return false
            unless (origin.id != target.id)
              return false

            items = AlbumsPhoto.filter(target.id, key: 'album_id')
            for item in items
              if item.photo_id is source.id
                return false
            return true

          else return false
          
    @include Include

module?.exports = Drag = Controller.Drag