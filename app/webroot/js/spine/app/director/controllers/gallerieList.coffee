Spine ?= require("spine")
$      = Spine.$

class Spine.GalleryList extends Spine.Controller
  events:
    "dblclick .item": "edit"
    "click .item"   : "click",
    
  elements:
    '.item'         : 'item'

  selectFirst: true
    
  constructor: ->
    super
    @bind("change", @change)
    #Gallery.bind("change", @proxy @change)

  template: -> arguments[0]
  
  change: (item, mode, e) =>
    console.log 'GalleryList::change'
    if e
      shiftKey = e.shiftKey
      dblclick = e.type is 'dblclick'
    if item?.reload()
      oldId = @current?.id
      newId = item.id
      changed = !(oldId is newId) or !(oldId)
      @children().removeClass("active")
      unless shiftKey
        @current = item
        @children().forItem(@current).addClass("active")
      else
        @current = null
      Gallery.current(@current)
      
      changed = true if !(@current) or dblclick
      
      Spine.App.trigger('change:selectedGallery', @current, mode) if changed
  
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
    #@stopEvent(e)
    console.log 'GalleryList::click'
    item = $(e.target).item()
    @change item, 'show', e

  edit: (e) ->
    console.log 'GalleryList::edit'
    item = $(e.target).item()
    @change item, 'edit', e

  stopEvent: (e) ->
    if (e.stopPropagation)
      e.stopPropagation()
      e.preventDefault()
    else
      e.cancelBubble = true

module?.exports = Spine.GalleryList