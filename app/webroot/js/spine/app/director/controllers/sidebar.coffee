Spine ?= require("spine")
$      = Spine.$

class Sidebar extends Spine.Controller

  elements:
    ".items"  : "items"
    "input"   : "input"

  #Attach event delegation
  events:
    "click button"          : "create"
    "keyup input"           : "filter"
    "click input"           : "filter"
    "dblclick .draghandle"  : 'toggleDraghandle'

  #Render template
  template: (items) ->
    return($("#galleriesTemplate").tmpl(items))

  constructor: ->
    super
    Spine.App.list = @list = new Spine.List
      el: @items,
      template: @template
    Gallerie.bind "refresh change", @proxy @render

  filter: ->
    @query = @input.val();
    @render();

  render: ->
    items = Gallerie.filter @query
    items = items.sort Gallerie.nameSort
    @list.render items

  newAttributes: ->
    name: ''
    author: ''

  #Called when 'Create' button is clicked
  create: (e) ->
    e.preventDefault()
    album = new Gallerie @newAttributes()
    album.save()
  
  toggleDraghandle: ->
    width = =>
      width =  @el.width()
      max = App.vmanager.max()
      min = App.vmanager.min
      if width >= min and width < max-20
        max+"px"
      else
        min+'px'
    
    @el.animate
      width: width()
      400

module?.exports = Sidebar