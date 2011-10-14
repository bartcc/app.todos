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
    return($("#contactsTemplate").tmpl(items))

  constructor: ->
    super
    Spine.list = @list = new Spine.List
      el: @items,
      template: @template
    Contact.bind "refresh change", @proxy @render

  filter: ->
    @query = @input.val();
    @render();

  render: ->
    items = Contact.filter @query
    items = items.sort Contact.nameSort
    @list.render items

  newAttributes: ->
    first_name: ''
    last_name: ''

  create: (e) ->
    e.preventDefault()
    contact = new Contact @newAttributes()
    contact.save()
  
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