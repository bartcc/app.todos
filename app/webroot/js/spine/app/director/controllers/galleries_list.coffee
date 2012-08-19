Spine ?= require("spine")
$      = Spine.$

class GalleriesList extends Spine.Controller

  @extend Spine.Controller.Drag
  
  events:
    'click'                   : 'clickDeselect'
    'click .item'             : 'click'
    'dblclick .item'          : 'zoom'
    'click .icon-set .delete' : 'deleteGallery'
    'click .icon-set .zoom'   : 'zoom'
    'mousemove .item'         : 'infoUp'
    'mouseleave .item'        : 'infoBye'
  
  constructor: ->
    super
    Spine.bind('change:selectedGallery', @proxy @change)

  change: (item) ->
    console.log 'GalleryList::change'
    @exposeSelection(item)
    
        
  render: (items) ->
    console.log 'GalleryList::render'
    @html @template items
    @el

  select: (item) =>
    Spine.trigger('gallery:activate', item)
    App.showView.trigger('change:toolbarOne', ['Default'])
    
  exposeSelection: (item) ->
    console.log 'GalleryList::exposeSelection'
    @deselect()
    if item
      el = @children().forItem(item)
      el.addClass("active")
      App.showView.trigger('change:toolbarOne')
    Spine.trigger('gallery:exposeSelection', item)
        
  clickDeselect: (e) ->
    Gallery.current()
    
  click: (e) ->
    console.log 'GalleryList::click'
    item = $(e.currentTarget).item()
    
    @select item
    e.stopPropagation()
    e.preventDefault()

  zoom: (e) ->
    console.log 'GalleryList::zoom'
    item = $(e.currentTarget).item()
    return unless item?.constructor?.className is 'Gallery'
    Gallery.current item
    @navigate '/gallery', Gallery.record.id
    
    e.stopPropagation()
    e.preventDefault()
    
  deleteGallery: (e) ->
    item = $(e.currentTarget).item()
    el = $(e.currentTarget).parents('.item')
    el.removeClass('in')
    
    window.setTimeout( ->
      Spine.trigger('destroy:gallery', item)
    , 300)
    
    e.preventDefault()
    e.stopPropagation()
    
  infoUp: (e) =>
    el = $('.icon-set' , $(e.currentTarget)).addClass('in').removeClass('out')
    e.preventDefault()
    
  infoBye: (e) =>
    el = $('.icon-set' , $(e.currentTarget)).addClass('out').removeClass('in')
    e.preventDefault()

module?.exports = GalleriesList