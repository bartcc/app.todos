Spine ?= require("spine")
$      = Spine.$

Spine.Controller.include
  focusFirstInput: (el) ->
    return unless el
    $('input', el).first().focus().select() if el.is(':visible')
    el

  openPanel: (controller, target) ->
    App[controller].deactivate()
    target.click()
    
  closePanel: (controller, target) ->
    App[controller].activate()
    target.click()

  isCtrlClick: (e) ->
    e.metaKey or e.ctrlKey or e.altKey


Spine.Controller.extend

  createImage: (url) ->
    img = new Image()
    img.src = url
    img

  empty: ->
    console.log 'empty'
    @constructor.apply @, arguments