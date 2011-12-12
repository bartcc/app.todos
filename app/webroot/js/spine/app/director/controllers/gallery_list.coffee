Spine ?= require("spine")
$      = Spine.$

class GalleryList extends Spine.Controller

  @extend Spine.Controller.Drag
  
  events:
    'click .item'   : 'click'
    'dblclick .item': 'dblclick'
  
  constructor: ->
    super
    Spine.bind('change:selectedGallery', @proxy @exposeSelection)

  change: ->
    console.log 'GalleryList::change'
    Spine.trigger('show:albums')
        
  render: (items) ->
    console.log 'GalleryList::render'
    @html @template items
    @el

  select: (item) =>
    Gallery.current(item)
    @exposeSelection(item)
    Spine.trigger('gallery:exposeSelection', Gallery.record)
    Spine.trigger('change:selectedGallery', Gallery.record)
    
  exposeSelection: (item) ->
    console.log 'GalleryList::exposeSelection'
    @deselect()
    el = @children().forItem(item)
    el.addClass("active")
        
  click: (e) ->
    console.log 'GalleryList::click'
    item = $(e.currentTarget).item()
    @select item
    e.stopPropagation()
    e.preventDefault()
    false

  dblclick: (e) ->
    console.log 'GalleryList::dblclick'
    @change()
    e.stopPropagation()
    e.preventDefault()
    false

module?.exports = GalleryList