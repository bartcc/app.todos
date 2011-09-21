Spine ?= require("spine")
$      = Spine.$

class Spine.GalleryList extends Spine.Controller
  events:
    "click .item": "click",
    "dblclick .item": "edit"
    
  selectFirst: true
    
  constructor: ->
    super
    @bind("change", @change)
    Gallery.bind("change", @proxy @change)
    
  template: -> arguments[0]
  
  change: (item, mode) =>
    console.log 'GalleryList::change'
    if item and !item.destroyed
      @current = item
      #console.log Spine.App.galleryList.current.id
      @children().removeClass("active")
      @children().forItem(@current).addClass("active")
      
      Spine.App.trigger('change:gallery', item, mode)
  
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
    #console.log 'GalleryList::click'
    item = $(e.target).item()
    @change item, 'show'
    
  edit: (e) ->
    item = $(e.target).item()
    @change item, 'edit'

module?.exports = Spine.GalleryList