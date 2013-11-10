Spine           = require("spine")
$               = Spine.$
Album           = require('models/album')
Gallery         = require('models/gallery')
AlbumsPhoto     = require('models/albums_photo')
GalleriesAlbum  = require('models/galleries_album')

Drag            = require("plugins/drag")
KeyEnhancer     = require("plugins/key_enhancer")
Extender        = require('plugins/controller_extender')

require("plugins/tmpl")

class SidebarList extends Spine.Controller

  @extend Drag
  @extend KeyEnhancer
  @extend Extender
  
  elements:
    '.gal.item'               : 'item'
    '.expander'               : 'expander'

  events:
    'click'                           : 'show'
    "click      .gal.item"            : "click"
    "dblclick   .gal.item"            : "dblclick"
    "click      .alb.item"            : "clickAlbum"
    "click      .expander"            : "expand"
    'dragstart  .sublist-item'        : 'dragstart'
    'dragenter  .sublist-item'        : 'dragenter'
    'dragleave  .sublist-item'        : 'dragleave'
    'drop       .sublist-item'        : 'drop'
    'dragend    .sublist-item'        : 'dragend'

  selectFirst: true
    
  contentTemplate: (items) ->
    $('#sidebarContentTemplate').tmpl(items)
    
  sublistTemplate: (items) ->
    $('#albumsSublistTemplate').tmpl(items)
    
  ctaTemplate: (item) ->
    $('#ctaTemplate').tmpl(item)
    
  constructor: ->
    super
    AlbumsPhoto.bind('change', @proxy @renderItemFromAlbumsPhoto)
    GalleriesAlbum.bind('change', @proxy @renderItemFromGalleriesAlbum)
    Gallery.bind('change', @proxy @change)
    Album.bind('refresh change', @proxy @renderAllSublist)
    Spine.bind('drag:timeout', @proxy @expandAfterTimeout)
    Spine.bind('expose:sublistSelection', @proxy @exposeSublistSelection)
    Spine.bind('gallery:exposeSelection', @proxy @exposeSelection)
    Gallery.bind('activate', @proxy @activate)
    
  template: -> arguments[0]

  change: (item, mode, e) =>
    console.log 'SidebarList::change'
    ctrlClick = @isCtrlClick(e?)
    
    unless ctrlClick
      switch mode
        when 'create'
          @current = item
          @create item
        when 'update'
          @current = item
          @update item
        when 'destroy'
          @current = false
          @destroy item
        when 'edit'
          Spine.trigger('edit:gallery')
        when 'show'
          @current = item
          @navigate '/gallery/' + Gallery.record?.id
        when 'photo'
          @current = item
          
    else
      @current = false
      switch mode
        when 'show'
          @navigate '/gallery/' + Gallery.record?.id + '/' + Album.record?.id
          
    
    @activate(@current) if @current
        
  create: (item) ->
    @append @template item
    @reorder item
  
  update: (item) ->
    @updateTemplate item
    @reorder item
  
  destroy: (item) ->
    @children().forItem(item, true).remove()
  
  checkChange: (item, mode) ->
  
  render: (items, mode) ->
    console.log 'SidebarList::render'
    
    @html @template items.sort(Gallery.nameSort)
    
    if (!@current or @current.destroyed) and !(mode is 'update')
      unless @children(".active").length
        App.ready = true
  
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
    
  renderOne: (item, mode) ->
    console.log 'SidebarList::renderOne'
  
  renderAll: (items) ->
    @html @template items.sort(Gallery.nameSort)

  renderAllSublist: ->
    console.log 'SidebarList::renderAllSublist'
    for gal of Gallery.irecords
      @renderOneSublist Gallery.irecords[gal]
  
  renderOneSublist: (gallery = Gallery.record) ->
    console.log 'SidebarList::renderOneSublist'
    return unless gallery
    filterOptions =
      key:'gallery_id'
      joinTable: 'GalleriesAlbum'
      sorted: true
    albums = Album.filterRelated(gallery.id, filterOptions)
    for album in albums
      album.count = AlbumsPhoto.filter(album.id, key: 'album_id').length
    albums.push {flash: 'no albums'} unless albums.length
    
    galleryEl = @children().forItem(gallery)
    gallerySublist = $('ul', galleryEl)
    gallerySublist.html @sublistTemplate(albums)
    
    @updateTemplate gallery
    @exposeSublistSelection()
  
  exposeSelection: (item = Gallery.record) ->
    console.log 'SidebarList::exposeSelection'
    @deselect()
    @children().forItem(item).addClass("active") if item
    @exposeSublistSelection()
        
  exposeSublistSelection: ->
    console.log 'SidebarList::exposeSublistSelection'
    removeAlbumSelection = =>
      galleries = []
      galleries.push val for item, val of Gallery.irecords
      for item in galleries
        galleryEl = @children().forItem(item)
        albums = galleryEl.find('li')
        albums.removeClass('selected').removeClass('active')
        
    removeAlbumSelection()
  
  updateTemplate: (item) ->
    galleryEl = @children().forItem(item)
    galleryContentEl = $('.item-content', galleryEl)
    tmplItem = galleryContentEl.tmplItem()
    tmplItem.tmpl = $( "#sidebarContentTemplate" ).template()
    try
      tmplItem.update()
    catch e
    
  renderItemFromGalleriesAlbum: (ga, mode) ->
    gallery = Gallery.find(ga.gallery_id) if Gallery.exists(ga.gallery_id)
    @renderOneSublist gallery if gallery
    
  renderItemFromAlbum: (album) ->
    gas = GalleriesAlbum.filter(album.id, key: 'album_id')
    for ga in gas
      @renderItemFromGalleriesAlbum ga
      
  renderItemFromAlbumsPhoto: (ap) ->
    gas = GalleriesAlbum.filter(ap.album_id, key: 'album_id')
    for ga in gas
      @renderItemFromGalleriesAlbum ga
  
  exposeSelection_: (e) ->
    @children().removeClass('active')
    $('.alb', @el).removeClass('active')
    
    galleryEl = $(e.target).parents('.gal').addClass('active')
    albumEl = $(e.target).parents('.alb').addClass('active')
  
  activate: (idOrRecord) ->
    Gallery.current(idOrRecord)
    @exposeSelection()

  exposeSelection: (item = Gallery.record) ->
    @children().removeClass('active')
    @children().forItem(item).addClass("active") if item
    @exposeSublistSelection()

  exposeSublistSelection: (gal = Gallery.record) ->
    removeAlbumSelection = =>
      galleries = []
      galleries.push val for item, val of Gallery.irecords
      for item in galleries
        galleryEl = @children().forItem(item)
        albums = galleryEl.find('li')
        albums.removeClass('selected').removeClass('active')
        $('.glyphicon', albums).removeClass('glyphicon-folder-open')
        
        
    if gal
      removeAlbumSelection()
      galleryEl = @children().forItem(Gallery.record)
      albums = galleryEl.find('li')
      album = Album.record
      if album
        albums.forItem(album).addClass('selected')
        album = Album.exists(Album.record.id)
        activeEl = albums.forItem(album).addClass('active')
        $('.glyphicon', activeEl).addClass('glyphicon-folder-open')
#    else
#      removeAlbumSelection()
    @refreshElements()

  clickAlbum: (e) ->
    galleryEl = $(e.target).parents('.gal').addClass('active')
    albumEl = $(e.currentTarget)
    galleryEl = $(e.currentTarget).closest('.gal')
    
    album = albumEl.item()
    gallery = galleryEl.item()
    
    Gallery.trigger('activate', gallery)
    Album.trigger('activate', Gallery.updateSelection [album.id])
    @navigate '/gallery', gallery.id + '/' + album.id
    
    e.stopPropagation()
    e.preventDefault()
    
  click: (e) ->
    console.log 'SidebarList::click'
    $(e.currentTarget).closest('.gal').addClass('active')
#    dont act on no-gallery items like the 'no album' - info
    item = $(e.target).closest('.data').item()
    
    App.contentManager.change App.showView
    
    
    @navigate '/gallery', item?.id or ''
    
    App.sidebar.list.expand(Gallery.record, true)
    App.sidebar.list.closeAllSublists(Gallery.record)
    
    e.stopPropagation()
    e.preventDefault()
    

  dblclick: (e) ->
    console.log 'SidebarList::dblclick'
    item = $(e.target).item()
    @change item, 'edit', e
    
    e.stopPropagation()
    e.preventDefault()

  expandAfterTimeout: (e) ->
    clearTimeout Spine.timer
    el = $(e.target)
    closest = (el.closest('.item')) or []
    if closest.length
      expander = $('.expander', closest)
      if expander.length
        @expand(e, true)

  close: () ->
    
  expanderFromClick: (e) ->
    $(e.target).parents('li')
    
  expanderFromItem: (item) ->
    @children().forItem(item)
    
  expand: (eventOrItem, force) ->
    isEvent = eventOrItem?.originalEvent
    
    if isEvent
      parentEl = @expanderFromClick(eventOrItem)
      eventOrItem.stopPropagation()
      eventOrItem.preventDefault()
      toggle = true 
    else
      parentEl = @expanderFromItem(eventOrItem)
      
    gallery = parentEl.item()
    icon = $('.expander', parentEl)
    sublist = $('.sublist', parentEl)
    
    show = =>
      icon.addClass('open')
      @renderOneSublist gallery
      sublist.show()
    hide = ->
      icon.removeClass('open')
      sublist.hide()
      
    if toggle
      icon.toggleClass('glyphicon', force)
      if icon.hasClass('open') and !force
        parentEl.removeClass('manual')
        hide()
      else
        parentEl.addClass('manual')
        show()
    else
      if force
        show()
      else
        hide()
  
  closeAllSublists: (item) ->
    for gallery in Gallery.all()
      parentEl = @expanderFromItem gallery
      unless parentEl.hasClass('manual')
        @expand gallery, item?.id is gallery.id
        
    
  show: (e) ->
    App.contentManager.change App.showView
    e.stopPropagation()
    e.preventDefault()
    
module?.exports = SidebarList