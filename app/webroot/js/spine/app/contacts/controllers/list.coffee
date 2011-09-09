Spine ?= require("spine")
$      = Spine.$

class Spine.List extends Spine.Controller
  events:
    "click .item": "click",
    "dblclick .item": "edit"
    
  selectFirst: true
    
  constructor: ->
    super
    @bind("change", @change)
    Contact.bind("create", @change)
    
  template: -> arguments[0]
  
  test: (item) =>
    console.log item
  
  change: (item) =>
    return unless item
    @current = item
    @children().removeClass("active")
    @children().forItem(@current).addClass("active")
  
  render: (items) ->
    @items = items if items
    @html @template(@items)
    @change @current
    if @selectFirst
      unless @children(".active").length
        @children(":first").click()
        
  children: (sel) ->
    @el.children(sel)
    
  click: (e) ->
    item = $(e.target).item()
    @trigger "change", item
    
  edit: (e) ->
    item = $(e.target).item()
    Spine.App.trigger 'edit:contact', item

module?.exports = Spine.List