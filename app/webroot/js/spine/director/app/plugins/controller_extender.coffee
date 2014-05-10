Spine       = require("spine")
$           = Spine.$
Controller  = Spine.Controller

Controller.Extender =
  
  extended: ->
    
    Extend = 
    
      empty: ->
        @log 'empty'
        @constructor.apply @, arguments
        
    Include = 
    
      init: ->
        
        @trace = !Spine.isProduction
        @logPrefix = '(' + @constructor.name + ')'
        
        @el.data('current',
          model: null
          models: null
        )
        
      createImage: (url, onload) ->
        img = new Image()
        img.onload = onload if onload
        img.src = url if url
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