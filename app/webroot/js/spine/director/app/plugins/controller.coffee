Spine = require("spine")
$      = Spine.$
Controller = Spine.Controller

Controller.Extender = ->

  Extend = 

    createImage: (url) ->
      img = new Image()
      img.src = url
      img

    empty: ->
      console.log 'empty'

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

      @constructor.apply @, arguments

  extended: ->
    @extend Extend
    @include Include
    
exports?.module =  Controller.Extender