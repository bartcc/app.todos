Spine       = require("spine")
$           = Spine.$
Controller  = Spine.Controller
#GalleriesAlbum = require('models/galleries_album')
#AlbumsPhoto    = require('models/albums_photo')

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
        
      find: (sel) ->
        @el.find(sel)

      deselect: (args...) ->
        @el.deselect(args...)

      sortable: (type) ->
        @el.sortable type
        
      findModelElement: (item) ->
        @children().forItem(item, true)
        
    
      
    @extend Extend
    @include Include

module?.exports = Controller.Extender