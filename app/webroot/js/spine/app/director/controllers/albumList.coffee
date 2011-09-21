Spine ?= require("spine")
$      = Spine.$

class Spine.AlbumList extends Spine.Controller
  events:
    "click .item": "click",
    "dblclick .item": "edit"
    
  selectFirst: true
    
  constructor: ->
    super
    @bind("change", @change)
    Album.bind("change", @proxy @change)
    Gallery.bind("change", @proxy @change)
    
  template: -> arguments[0]
  
  change: (item, mode) =>
    #console.log 'AlbumList::change: '
    if item and !item.destroyed
      #console.log item
      @current = item
      @children().removeClass("active")
      @children().forItem(@current).addClass("active")
      
      #Spine.App.trigger('change', item, mode)
  
  render: (items) ->
    #console.log 'AlbumList::render'
    @items = items if items
    #console.log @items
    @html @template(@items)
    #@change @current
#    if @selectFirst
#      unless @children(".active").length
#        @children(":first").click()
        
  children: (sel) ->
    @el.children(sel)
    
  click: (e) ->
    item = $(e.target).item()
    #console.log 'AlbumList::click'
    #console.log item
    @change item, 'show'
    
  edit: (e) ->
    item = $(e.target).item()
    @change item, 'edit'

module?.exports = Spine.AlbumList