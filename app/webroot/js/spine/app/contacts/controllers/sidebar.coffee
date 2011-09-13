$ = jQuery
class Sidebar extends Spine.Controller

  elements:
    ".items"  : "items"
    "input"   : "input"

  #Attach event delegation
  events:
    "click button"  : "create"
    "keyup input"   : "filter"
    "click input"   : "filter"

  #Render template
  template: (items) ->
    return($("#contactsTemplate").tmpl(items))

  constructor: ->
    super
    Spine.App.list = @list = new Spine.List
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

  #Called when 'Create' button is clicked
  create: (e) ->
    e.preventDefault()
    contact = new Contact @newAttributes()
    contact.save()