Spine           = require("spine")
$               = Spine.$
Album           = require('models/album')
Gallery         = require('models/gallery')
AlbumsPhoto     = require('models/albums_photo')
GalleriesAlbum  = require('models/galleries_album')
Drag            = require("plugins/drag")
Extender        = require('plugins/controller_extender')
require("plugins/tmpl")

class SidebarList extends Spine.Controller

  @extend Drag
  @extend Extender
  
  elements:
    '.gal.item'               : 'item'

  events:
    "click      .item"            : 'click'
    "click      .expander"        : 'clickExpander'

  selectFirst: true
    
  contentTemplate: (items) ->
    $('#sidebarContentTemplate').tmpl(items)
    
  sublistTemplate: (items) ->
    $('#albumsSublistTemplate').tmpl(items)
    
  ctaTemplate: (item) ->
    $('#ctaTemplate').tmpl(item)
    
  constructor: ->
    super
    Spine.bind('changed:albums', @proxy @renderGallery)
    Gallery.bind('change', @proxy @change)
    Album.bind('create destroy update', @proxy @renderSublists)
    Gallery.bind('change:selection', @proxy @exposeSublistSelection)
    Gallery.bind('current', @proxy @exposeSelection)
    
  template: -> arguments[0]
  
  change: (item, mode, e) =>
    console.log 'SidebarList::change'
    
    switch mode
      when 'create'
        @current = item
        @create item
        @exposeSelection item
      when 'update'
        @current = item
        @update item
      when 'destroy'
        @current = false
        @destroy item
          
  create: (item) ->
    @append @template item
    @reorder item
  
  update: (item) ->
    @updateTemplate item
    @reorder item
  
  destroy: (item) ->
    @children().forItem(item, true).remove()
  
  render: (items, mode) ->
    console.log 'SidebarList::render'
    @children().addClass('invalid')
    for item in items
      galleryEl = @children().forItem(item)
      unless galleryEl.length
        @append @template item
        @reorder item
      else
        @updateTemplate(item).removeClass('invalid')
      @renderOneSublist item
    @children('.invalid').remove()
    
  reorder: (item) ->
    console.log 'SidebarList::reorder'
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
    
  updateSublist: (ga) ->
    gallery = Gallery.exists ga.gallery_id
    @renderOneSublist gallery
    
  renderAllSublist: ->
    console.log 'SidebarList::renderAllSublist'
    for gal, index in Gallery.records
      @renderOneSublist gal
      
  renderSublists: (album) ->
    console.log 'SidebarList::renderSublists'
    gas = GalleriesAlbum.filter(album.id, key: 'album_id')
    for ga in gas
      @renderOneSublist gallery if gallery = Gallery.exists ga.gallery_id
      
  renderOneSublist: (gallery = Gallery.record) ->
    console.log 'SidebarList::renderOneSublist'
    @updateTemplate gallery
    filterOptions =
      key:'gallery_id'
      joinTable: 'GalleriesAlbum'
      sorted: true
    albums = Album.filterRelated(gallery.id, filterOptions)
    for album in albums
      album.count = AlbumsPhoto.filter(album.id, key: 'album_id').length
    albums.push {flash: ' '} unless albums.length
    galleryEl = @children().forItem(gallery)
    gallerySublist = $('ul', galleryEl)
    gallerySublist.html @sublistTemplate(albums)
    gallerySublist.sortable('album')
    @exposeSublistSelection Gallery.selectionList()
    
  updateTemplate: (item) ->
    console.log 'SidebarList::updateTemplate'
    galleryEl = @children().forItem(item)
    galleryContentEl = $('.item-content', galleryEl)
    tmplItem = galleryContentEl.tmplItem()
    tmplItem.tmpl = $( "#sidebarContentTemplate" ).template()
    try
      tmplItem.update()
    catch e
    galleryEl
    
  renderItemFromGalleriesAlbum: (ga, mode) ->
    gallery = Gallery.exists(ga.gallery_id)
    if gallery
      @updateTemplate gallery
      @renderOneSublist gallery
    
  renderGallery: (item) ->
    @updateTemplate item
    @renderOneSublist item
    
  renderAlbum: (id) ->
    gas = GalleriesAlbum.filter(id, key: 'album_id')
    for ga in gas
      @renderGallery ga.gallery_id
    
  renderItemFromAlbumsPhoto: (ap) ->
    console.log 'SidebarList::renderItemFromAlbumsPhoto'
    gas = GalleriesAlbum.filter(ap.album_id, key: 'album_id')
    for ga in gas
      @renderItemFromGalleriesAlbum ga
  
  exposeSelection: (item) ->
    @children().removeClass('active')
    el = @children().forItem(item).addClass("active")# if item.id is Gallery.record.id
    
  exposeSublistSelection: (selection=Gallery.selectionList()) ->
        
    if gallery = Gallery.record
      galleryEl = @children().forItem(gallery)
      albumsEl = galleryEl.find('li')
      albumsEl.removeClass('selected active')
      $('.glyphicon', galleryEl).removeClass('glyphicon-folder-open')
      
      for id in selection
        if album = Album.exists(id)
          albumsEl.forItem(album).addClass('selected')

      if activeAlbum = Album.exists(first = selection.first())
        activeEl = albumsEl.forItem(activeAlbum).addClass('active')
        $('.glyphicon', activeEl).addClass('glyphicon-folder-open')
        
    @refreshElements()

  click: (e) ->
    el = $(e.target).closest('li')
    item = el.item()
    
    switch item.constructor.className
      when 'Gallery'
        @expand(item, App.showView.controller?.el.data('current').models isnt Album)
        @navigate '/gallery', item.id
        Gallery.current item.id if Gallery.record and Gallery.record.id is item.id
      when 'Album'
        gallery = $(e.target).closest('li.gal').item()
        @navigate '/gallery', gallery.id, item.id
        Album.current(item.id) if Album.record and Album.record.id is item.id
    
  expand: (item, force, e) ->
    galleryEl = @galleryFromItem(item)
    expander = $('.expander', galleryEl)
    if e
      targetIsExpander = $(e.currentTarget).hasClass('expander')
    
    if force
      @openSublist(galleryEl)
    else
      open = galleryEl.hasClass('open')
      closeif = galleryEl.hasClass('active') or targetIsExpander
      if open
        @closeSublist(galleryEl) if closeif 
      else
        @openSublist(galleryEl)
        
  openSublist: (el) ->
    el.addClass('open')
    
  closeSublist: (el) ->
    el.removeClass('open')
    
  closeAllSublists: (item) ->
    for gallery in Gallery.all()
      parentEl = @galleryFromItem gallery
      unless parentEl.hasClass('manual')
        @expand gallery, item?.id is gallery.id
  
  clickExpander: (e) ->
    galleryEl = $(e.target).closest('li.gal')
    item = galleryEl.item()
    @expand(item, false, e) if item
    
    e.stopPropagation()
    e.preventDefault()
    
  galleryFromItem: (item) ->
    @children().forItem(item)

  close: () ->
    
  show: (e) ->
    App.contentManager.change App.showView
    e.stopPropagation()
    e.preventDefault()
    
module?.exports = SidebarList