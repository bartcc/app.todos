Spine       = require("spine")
$           = Spine.$
Controller  = Spine.Controller
GalleriesAlbum = require('models/galleries_album')
AlbumsPhoto    = require('models/albums_photo')

Controller.Extender =
  
  extended: ->
    
    Extend = 
    
      empty: ->
        console.log 'empty'
        @constructor.apply @, arguments
        
    
    
    Include = 
    
      init: ->
        @el.data('current',
          model: null
          models: null
        )
        
      createImage: (url) ->
        img = new Image()
        img.src = url
        img
  
      activated: ->
  
      focusFirstInput: (el=@el) ->
        return unless el
        $('input', el).first().focus().select() if el.is(':visible')
        el

      focus: ->
        @el.focus()

      panelIsActive: (controller) ->
        App[controller].isActive()
        
      openPanel: (controller) ->
        ui = App.vmanager.externalUI(App[controller])
        ui.click()

      closePanel: (controller, target) ->
        App[controller].activate()
        ui = App.vmanager.externalUI(App[controller])
        ui.click()

      isCtrlClick: (e) ->
        e?.metaKey or e?.ctrlKey or e?.altKey

      children: (sel) ->
        @el.children(sel)

      deselect: (args...) ->
        @el.deselect(args...)

      sortable: (type) ->
        @el.sortable type
        
      findModelElement: (item) ->
        @children().forItem(item, true)
        
      dragStart: (e, controller) ->
        console.log 'dragStart'
        el = $(e.currentTarget)
        event = e.originalEvent
        Spine.dragItem.targetEl = null
        source = Spine.dragItem.source
        unless source
          alert 'no source'
          return
        # check for drags from sublist and set its origin
        if el.parents('ul.sublist').length
          fromSidebar = true
          selection = [source.id]
          id = el.parents('li.item')[0].id
          Spine.dragItem.origin = Gallery.find(id) if (id and Gallery.exists(id))
        else
          switch source.constructor.className
            when 'Album'
              selection = Gallery.selectionList()
            when 'Photo'
              selection = Album.selectionList()

        return unless Album.isArray(selection)
        
        # make an unselected item part of selection only if there is nothing selected yet
        if !(source.id in selection)# and !(selection.length)
          list = source.emptySelection().push source.id

        Spine.selection = selection.slice(0)

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

      dropComplete: (e, record) ->
        console.log 'dropComplete'
        target = Spine.dragItem.target
        source = Spine.dragItem.source
        origin = Spine.dragItem.origin
        
        Spine.dragItem.closest?.removeClass('over nodrop')
        return unless @validateDrop target, source, origin
        hash = location.hash
        switch source.constructor.className
          when 'Album'
            selection = Spine.selection
            Album.trigger('create:join', selection, target, -> @navigate hash)
            unless @isCtrlClick(e)
              Album.trigger('destroy:join', selection, origin) if origin

          when 'Photo'
            selection = Spine.selection
            photos = Photo.toRecords(selection)

            Photo.trigger 'create:join',
              options =
                photos: selection
                album: target
              , -> @navigate hash
            
            unless @isCtrlClick(e)
              Photo.trigger 'destroy:join',
                options =
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
      
    @extend Extend
    @include Include

module?.exports = Controller.Extender