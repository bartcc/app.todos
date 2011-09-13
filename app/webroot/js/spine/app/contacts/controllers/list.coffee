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
    Contact.bind("change", @proxy @change)
    
  template: -> arguments[0]
  
  change: (item, mode) =>
    if item and !item.destroyed
      @current = item
      @children().removeClass("active")
      @children().forItem(@current).addClass("active")
      
      Spine.App.trigger('change', item, mode)
  
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
    @change item, 'show'
    
  edit: (e) ->
    item = $(e.target).item()
    @change item, 'edit'

module?.exports = Spine.List