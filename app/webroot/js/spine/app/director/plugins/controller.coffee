Spine ?= require("spine")
$      = Spine.$

Spine.Controller.include
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
    
Spine.Controller.extend

  createImage: (url) ->
    img = new Image()
    img.src = url
    img

  empty: ->
    console.log 'empty'
    @constructor.apply @, arguments