Spine       = require("spine")
$           = Spine.$
Controller  = Spine.Controller

Controller.Extender =
  
  extended: ->
    
    Extend = 
    
      createImage: (url) ->
        img = new Image()
        img.src = url
        img

      empty: ->
        console.log 'empty'
        @constructor.apply @, arguments
    
    
    Include = 
  
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
        
    @extend Extend
    @include Include

module?.exports = Controller.Extender