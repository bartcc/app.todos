Spine ?= require("spine")
$      = Spine.$

class GalleriesList extends Spine.Controller

  @extend Spine.Controller.Drag
  
  events:
    'click .item'   : 'click'
    'dblclick .item': 'dblclick'
  
  constructor: ->
    super
    Spine.bind('change:selectedGallery', @proxy @exposeSelection)

  change: ->
    console.log 'GalleryList::change'
    
        
  render: (items) ->
    console.log 'GalleryList::render'
    @html @template items
    @el

  select: (item) =>
#    Spine.trigger('change:toolbarOne', ['Gallery'])
    Spine.trigger('change:toolbarOne', ['Default'])
    Spine.trigger('gallery:activate', item)
    
  exposeSelection: (item) ->
    console.log 'GalleryList::exposeSelection'
    @deselect()
    if item
      el = @children().forItem(item)
      el.addClass("active")
      Spine.trigger('gallery:exposeSelection', item)
      Spine.trigger('change:toolbarOne')
        
  click: (e) ->
    console.log 'GalleryList::click'
    item = $(e.currentTarget).item()
    
    @select item
    e.stopPropagation()
    e.preventDefault()

  dblclick: (e) ->
    console.log 'GalleryList::dblclick'
    Spine.trigger('show:albums')
    Spine.trigger('gallery:activate')
    
    e.stopPropagation()
    e.preventDefault()

module?.exports = GalleriesList