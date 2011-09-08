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

    @list.bind "change", @proxy (item) ->
      Spine.App.trigger("show:contact", item);

    Spine.App.bind "show:contact", @list.proxy @list.change
    #Re-render whenever contacts are populated or changed
    Contact.bind "refresh change", @proxy @render

  filter: ->
    @query = @input.val();
    @render();

  render: ->
    #Filter items by query
    items = Contact.filter @query
    #Filter by first name
    items = items.sort Contact.nameSort
    @list.render items
  newAttributes: ->
      first_name: ''
      last_name: ''

  #Called when 'Create' button is clicked
  create: (e) ->
    e.preventDefault()
    item = Contact.create @newAttributes()
    Spine.App.trigger "edit:contact", item