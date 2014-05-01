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
    Gallery.bind('change:collection', @proxy @renderGallery)
    Album.bind('change:collection', @proxy @renderAlbum)
    Gallery.bind('change', @proxy @change)
    Album.bind('create destroy update', @proxy @renderSublists)
    Gallery.bind('change:selection', @proxy @exposeSublistSelection)
    Gallery.bind('current', @proxy @exposeSelection)
    Gallery.bind('change:current', @proxy @scrollTo)
    Album.bind('current', @proxy @scrollTo)
    
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
    @children().forItem(item, true).detach()
  
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
    filterOptions =
      model: 'Gallery'
      key:'gallery_id'
      sorted: 'sortByOrder'
      
    albums = Album.filterRelated(gallery.id, filterOptions)
    for album in albums
      album.count = AlbumsPhoto.filter(album.id, key: 'album_id').length
      
    albums.push {flash: ' '} unless albums.length
    galleryEl = @children().forItem(gallery)
    gallerySublist = $('ul', galleryEl)
    gallerySublist.html @sublistTemplate(albums)
    gallerySublist.sortable('album')
    @exposeSublistSelection(gallery)
    
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
    
  renderAlbum: (item) ->
    gas = GalleriesAlbum.filter(item.id, key: 'album_id')
    for ga in gas
      if gallery = Gallery.exists ga.gallery_id
        @renderGallery gallery
    
  renderItemFromAlbumsPhoto: (ap) ->
    console.log 'SidebarList::renderItemFromAlbumsPhoto'
    gas = GalleriesAlbum.filter(ap.album_id, key: 'album_id')
    for ga in gas
      @renderItemFromGalleriesAlbum ga
  
  exposeSelection: (item) ->
    item = item or Gallery.record
    @children().removeClass('active')
    @children().forItem(item).addClass("active") if item
#    @exposeSublistSelection(item)
    
  exposeSublistSelection: (item) ->
    item = item or Gallery.record
    if item
      selection = item.selectionList()
      galleryEl = @children().forItem(item)
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
    
  scrollTo: (item, changed) ->
    return unless item and Gallery.record
    marginTop = 50
    marginBot = 50
    if item.constructor.className is 'Gallery'
      el = @children().forItem(Gallery.record)
      ul = $('ul', el)
      ul.hide() # messuring galleryEl w/o sublist
      ohc = el[0].offsetHeight
      speed = 300
    else
      ul = $('ul', el)
      el = $('li', ul).forItem(item)
      ohc = el[0].offsetHeight
      speed = 700
      
    ul.show()
    otc = el.offset().top
    stp = @el[0].scrollTop
    otp = @el.offset().top
    shp = @el[0].scrollHeight
    ohp = @el[0].offsetHeight  
    
    resMin = stp+otc-otp
    resMax = stp+otc-(otp+ohp-ohc)
    
    outOfRange = stp > resMin or stp < resMax
    outOfMinRange = stp > resMin
    outOfMaxRange = stp < resMax
    
    res = if outOfMinRange then resMin else if outOfMaxRange then resMax
    
    return unless outOfRange
    
    @el.animate scrollTop: res,
      queue: false
      duration: speed
      complete: =>
    
module?.exports = SidebarList