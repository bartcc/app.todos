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
  
      focusFirstInput: (el) ->
        return unless el
        $('input', el).first().focus().select() if el.is(':visible')
        el

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
        
    @extend Extend
    @include Include

module?.exports = Controller.Extender