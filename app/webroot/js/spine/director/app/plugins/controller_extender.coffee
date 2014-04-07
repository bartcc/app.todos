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
    
      createImage: (url) ->
        img = new Image()
        img.src = url
        img
  
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
        return unless e
        e?.metaKey or e?.ctrlKey or e?.altKey

      children: (sel) ->
        @el.children(sel)

      deselect: (args...) ->
        @el.deselect(args...)

      sortable: (type) ->
        @el.sortable type
        
      findModelElement: (item) ->
        @children().forItem(item, true)
        
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
      
      dragStart: (e, controller) ->
        return unless Spine.dragItem
        el = $(e.currentTarget)
        event = e.originalEvent
        Spine.dragItem.targetEl = null
        source = Spine.dragItem.source
        return unless source
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

        # make an unselected item part of selection only if there is nothing selected yet
        return unless Album.isArray(selection)
        if !(source.id in selection)# and !(selection.length)
          list = source.emptySelection().push source.id

        Spine.clonedSelection = selection.slice(0)

      dragEnter: (e) ->
        return unless Spine.dragItem
        el = $(e.target).closest('.data')
        return unless el.length
        target = el.item() or el.data('current').model.record
        source = Spine.dragItem.source
        origin = Spine.dragItem.origin or Gallery.record
        Spine.dragItem.closest?.removeClass('over nodrop')
        Spine.dragItem.closest = el
        return if target.id is origin.id
        if res = @validateDrop target, source, origin
          Spine.dragItem.closest.addClass('over')
        else
          Spine.dragItem.closest.addClass('nodrop')

      dragOver: (e) =>

      dragLeave: (e) =>

      dragEnd: (e) ->
        Spine.dragItem.closest?.removeClass('over nodrop')
      
      dropComplete: (e, record) ->
        return unless Spine.dragItem
        Spine.dragItem.closest?.removeClass('over nodrop')
        target = Spine.dragItem.closest?.data()?.current?.record or Spine.dragItem.closest?.item()
        source = Spine.dragItem.source
        origin = Spine.dragItem.origin

        return unless @validateDrop target, source, origin

        switch source.constructor.className
          when 'Album'
            albums = Album.toRecords(Spine.clonedSelection)
            for album in albums
              album.createJoin(target) if target
              album.destroyJoin(origin) if origin  unless @isCtrlClick(e)

          when 'Photo'
            photos = []
            Photo.each (record) =>
              photos.push record unless Spine.clonedSelection.indexOf(record.id) is -1

            Photo.trigger('create:join', photos.toID(), target)
            Photo.trigger('destroy:join', photos.toID(), origin) unless @isCtrlClick(e)
      
    @extend Extend
    @include Include

module?.exports = Controller.Extender