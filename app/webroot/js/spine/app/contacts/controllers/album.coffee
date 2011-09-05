Spine ?= require("spine")
$      = Spine.$

class Album extends Spine.Controller

  events:
    "click .item": "click"
    
  template: (item) ->
    $('#editContactTemplate').tmpl item

  constructor: ->
    super
    Spine.App.list.bind 'change', @proxy (item) ->
      @change item
    Contact.bind "change", @proxy (item) ->
      @change item
    #Spine.App.bind 'edit:contact', @proxy @render

  render: ->
    @el.html @template @current
    @

  change: (item) ->
    @current = item
    @render()

module?.exports = Album