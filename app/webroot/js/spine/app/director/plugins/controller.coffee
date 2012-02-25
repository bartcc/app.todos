Spine ?= require("spine")
$      = Spine.$

Spine.Controller.include
  focusFirstInput: (el) ->
    return unless el
    $('input', el).first().focus().select() if el.is(':visible')
    el

  panelIsActive: (controller) ->
    App[controller].isActive()

  openPanel: (controller, target) ->
    App[controller].deactivate()
    target.click()
    
  closePanel: (controller, target) ->
    App[controller].activate()
    target.click()

  isCtrlClick: (e) ->
    e.metaKey or e.ctrlKey or e.altKey

  children: (sel) ->
    @el.children(sel)
    
  deselect: () ->
    @el.deselect()
    
  sortable: (type) ->
    @el.sortable type
    
Spine.Controller.extend

  createImage: (url) ->
    img = new Image()
    img.src = url
    img

  empty: ->
    console.log 'empty'
    @constructor.apply @, arguments