Spine ?= require("spine")
$      = Spine.$

class Spine.GalleryList extends Spine.Controller
  events:
    "click .item"   : "click",
    "dblclick .item": "edit"
    
  elements:
    '.item'         : 'item'

  selectFirst: true
    
  constructor: ->
    super
    @bind("change", @change)
    Gallery.bind("change", @proxy @change)

  template: -> arguments[0]
  
  change: (item, mode, shiftKey) =>
    console.log 'GalleryList::change'
    if item
      @children().removeClass("active")
      unless shiftKey
        Gallery.current(@current = item)
        @children().forItem(@current).addClass("active")
      else
        @current = null
      Gallery.current(@current)
      
      Spine.App.trigger('change:gallery', @current, mode)
  
  render: (items) ->
    console.log 'GalleryList::render'
    @items = items if items
    @html @template(@items)
    @change @current
    if @selectFirst
      unless @children(".active").length
        @children(":first").click()
        
  children: (sel) ->
    @el.children(sel)

  click: (e) ->
    console.log 'GalleryList::click'
    item = $(e.target).item()
    @change item, 'show', e.shiftKey
    false
    
  edit: (e) ->
    console.log 'GalleryList::edit'
    item = $(e.target).item()
    @change item, 'edit'

  stopEvent: (e) ->
    if (e.stopPropagation)
      e.stopPropagation()
    else
      e.cancelBubble = true

module?.exports = Spine.GalleryList