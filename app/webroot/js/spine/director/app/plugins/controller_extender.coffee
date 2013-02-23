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

      isCtrlClick: (e) ->
        return unless e
        e?.metaKey or e?.ctrlKey or e?.altKey

      children: (sel) ->
        @el.children(sel)

      deselect: () ->
        @el.deselect()

      sortable: (type) ->
        @el.sortable type
        
    @extend Extend
    @include Include

module?.exports = Controller.Extender