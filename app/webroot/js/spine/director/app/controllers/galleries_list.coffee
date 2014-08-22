Spine           = require("spine")
$               = Spine.$
Root            = require("models/root")
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
    'click .dropdown-toggle'        : 'dropdownToggle'
    'click .delete'                 : 'deleteGallery'
    'click .zoom'                   : 'zoom'
    
    'mousemove .item'               : 'infoUp'
    'mouseleave .item'              : 'infoBye'
    
    'dragover'                      : 'dragover'
  
  constructor: ->
    super
    Root.bind('change:selection', @proxy @exposeSelection)
    Gallery.bind('change', @proxy @renderOne)
    Photo.bind('destroy', @proxy @renderRelated)
    Album.bind('destroy', @proxy @renderRelated)
    
    Album.bind('change:collection', @proxy @renderRelated)
    
  renderRelated: ->
    return unless @parent.isActive()
    @log 'renderRelated'
    @updateTemplates()
    
  renderOne: (item, mode) ->
    @log 'renderOne'
    switch mode
      when 'create'
        if Gallery.count() is 1
          @el.empty()
        @append @template item
        @exposeSelection item
      when 'update'
        try
          @updateTemplates()
          $('.dropdown-toggle', @el).dropdown()
        catch e
        @reorder item
        @exposeSelection item
          
    @el

  render: (items, mode) ->
    @log 'render'
    @html @template items
    @exposeSelection()
    $('.dropdown-toggle', @el).dropdown()
    @el

  updateTemplates: ->
    @log 'updateTemplates'
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

  exposeSelection: (item, sel) ->
    @log 'exposeSelection'
    
    selection = sel || Root.selectionList()
    @deselect()
    
    for id in selection
      $('#'+id, @el).addClass("active hot")
      
    App.showView.trigger('change:toolbarOne')
    @parent.focus()
        
  dropdownToggle: (e) ->
    el = $(e.currentTarget)
    el.dropdown()
    e.preventDefault()
    e.stopPropagation()
        
  zoom: (e) ->
    @log 'zoom'
    item = $(e.currentTarget).item()
    @navigate '/gallery', item.id
    
  back: (e) ->
    @navigate '/overview', ''
    
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