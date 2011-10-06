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

  template: -> arguments[0]

  change: (item, mode, e) =>
    console.log 'GalleryList::change'

    #alert item if item

    if e
      cmdKey = e.metaKey || e.ctrlKey
      dblclick = e.type is 'dblclick'

    if !(item?.destroyed) and item?.reload()
      oldId = @current?.id
      newId = item.id
      changed = !(oldId is newId) or !(oldId)
      @children().removeClass("active")
      unless cmdKey
        @current = item
        @children().forItem(@current).addClass("active")
      else
        @current = false

      Gallery.current(@current)
      
      changed = true if !(@current) or dblclick
      
      Spine.trigger('change:selectedGallery', @current, mode) if changed
  
  render: (items, item) ->
    console.log 'GalleryList::render'
    #inject counter
    for record in items
      record.count = Album.filter(record.id).length
    
    @items = items
    @html @template(@items)
    @change item or @current
    if @selectFirst
      unless @children(".active").length
        @children(":first").click()

  children: (sel) ->
    @el.children(sel)

  click: (e) ->
    console.log 'GalleryList::click'
    item = $(e.target).item()
    @change item, 'show', e

  edit: (e) ->
    console.log 'GalleryList::edit'
    item = $(e.target).item()
    @change item, 'edit', e


module?.exports = Spine.GalleryList