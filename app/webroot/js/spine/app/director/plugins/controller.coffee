Spine ?= require("spine")
$      = Spine.$

Spine.Controller.include
  focusFirstInput: (el) ->
    return unless el
    $('input', el).first().focus().select() if el.is(':visible')
    el

Spine.Controller.extend
  empty: ->
    console.log 'empty'
    @constructor.apply @, arguments