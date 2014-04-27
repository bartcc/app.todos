Spine           = require("spine")
$               = Spine.$
Gallery         = require('models/gallery')
GalleriesAlbum  = require('models/galleries_album')
AlbumsPhoto     = require('models/albums_photo')
Drag            = require("plugins/drag")
Extender        = require('plugins/controller_extender')

require("plugins/tmpl")

class GalleriesList extends Spine.Controller

  @extend Drag
  @extend Extender
  
  events:
    'click .opt-SlideshowPlay'      : 'slideshowPlay'
    'click .glyphicon-set .back'    : 'back'
    'click .glyphicon-set .delete'  : 'deleteGallery'
    'click .glyphicon-set .zoom'    : 'zoom'
    
    'mousemove .item'               : 'infoUp'
    'mouseleave .item'              : 'infoBye'
    
    'dragover'                      : 'dragover'
  
  constructor: ->
    super
    Gallery.bind('change', @proxy @renderOne)
    Gallery.bind('change:selection', @proxy @exposeSelection)
    Gallery.bind('current', @proxy @exposeSelection)
    Photo.bind('destroy', @proxy @renderRelated)
    Album.bind('destroy', @proxy @renderRelated)
    
    Album.bind('collection:changed', @proxy @renderRelated)
    
  renderRelated: ->
    return unless @parent.isActive()
    console.log 'GalleriesList::renderRelated'
    @updateTemplates()
    
  renderOne: (item, mode) ->
    console.log 'GalleriesList::renderOne'
    switch mode
      when 'create'
        if Gallery.count() is 1
          @el.empty()
        @append @template item
        @exposeSelection item

      when 'update'
        try
          @updateTemplates()
        catch e
        @reorder item
        @exposeSelection item
          
    @el

  render: (items, mode) ->
    console.log 'GalleriesList::render'
    @html @template items
    @exposeSelection()
    @el

  updateTemplates: ->
    console.log 'GalleriesList::updateTemplates'
    for gallery in Gallery.records
      galleryEl = @children().forItem(gallery)
      active = galleryEl.hasClass('active')
      contentEl = $('.thumbnail', galleryEl)
      tmplItem = contentEl.tmplItem()
      alert 'no tmpl item' unless tmplItem
      if tmplItem
        tmplItem.tmpl = $( "#galleriesTemplate" ).template()
        tmplItem.update?()
        galleryEl = @children().forItem(gallery).toggleClass('active hot', active)

  reorder: (item) ->
    id = item.id
    index = (id, list) ->
      for itm, i in list
        return i if itm.id is id
      i
    
    children = @children()
    oldEl = @children().forItem(item)
    idxBeforeSort =  @children().index(oldEl)
    idxAfterSort = index(id, Gallery.all().sort(Gallery.nameSort))
    newEl = $(children[idxAfterSort])
    if idxBeforeSort < idxAfterSort
      newEl.after oldEl
    else if idxBeforeSort > idxAfterSort
      newEl.before oldEl

  exposeSelection: (item=Gallery.record) ->
    console.log 'GalleriesList::exposeSelection'
    @deselect()
    if item
      el = @children().forItem(item, true)
      el.addClass("active hot")
      
    App.showView.trigger('change:toolbarOne')
        
  zoom: (e) ->
    console.log 'GalleriesList::zoom'
    item = $(e.currentTarget).item()
    @navigate '/gallery', item.id
    e.preventDefault()
    e.stopPropagation()
    
  back: (e) ->
    @navigate '/overview/'
    e.preventDefault()
    e.stopPropagation()
    
  deleteGallery: (e) ->
    item = $(e.currentTarget).item()
    el = $(e.currentTarget).parents('.item')
    Spine.trigger('destroy:gallery', item.id) if item
    
  infoUp: (e) =>
    el = $('.glyphicon-set' , $(e.currentTarget)).addClass('in').removeClass('out')
    e.preventDefault()
    
  infoBye: (e) =>
    el = $('.glyphicon-set' , $(e.currentTarget)).addClass('out').removeClass('in')
    e.preventDefault()
    
  slideshowPlay: (e) ->
    gallery = $(e.currentTarget).closest('.item').item()
    Gallery.trigger('activate', gallery.id)
    App.slideshowView.trigger('play')

module?.exports = GalleriesList