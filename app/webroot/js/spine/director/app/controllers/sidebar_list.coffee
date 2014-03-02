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
    "click      .gal.item"            : 'clickGallery'
    "click      .alb.item"            : 'clickAlbum'
    "click      .expander"            : 'clickExpander'
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
    GalleriesAlbum.bind('destroy create update', @proxy @renderItemFromGalleriesAlbum)
    Gallery.bind('change', @proxy @change)
#    Album.bind('refresh destroy create update', @proxy @renderAllSublist)
    Album.one('refresh', @proxy @renderAllSublist)
    Album.bind('update destroy', @proxy @renderSublists)
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

  renderAllSublist: (album) ->
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
    
    
    @updateTemplate gallery
    @exposeSublistSelection gallery
  
  updateTemplate: (item) ->
    galleryEl = @children().forItem(item)
    galleryContentEl = $('.item-content', galleryEl)
    tmplItem = galleryContentEl.tmplItem()
    tmplItem.tmpl = $( "#sidebarContentTemplate" ).template()
    try
      tmplItem.update()
    catch e
    
  renderItemFromGalleriesAlbum: (ga) ->
    gallery = Gallery.exists(ga.gallery_id)
    @renderOneSublist gallery if gallery
    
  renderItemFromPhoto: (photo) ->
    for photo in photos
      albums = AlbumsPhoto.albums(photo)
      for album in albums
        Photo.triggerdestroyJoin photo, album
  
  renderItemFromAlbum: (album) ->
    gas = GalleriesAlbum.filter(album.id, key: 'album_id')
    for ga in gas
      @renderItemFromGalleriesAlbum ga
      
  renderItemFromAlbumsPhoto: (ap) ->
    console.log 'SidebarList::renderItemFromAlbumsPhoto'
    gas = GalleriesAlbum.filter(ap.album_id, key: 'album_id')
    for ga in gas
      @renderItemFromGalleriesAlbum ga
  
  exposeSelection: (item = Gallery.record) ->
    @children().removeClass('active')
    @children().forItem(item).addClass("active") if item
    @exposeSublistSelection()
    
  exposeSublistSelection: (gallery = Gallery.record) ->
    console.log 'SidebarList::exposeSublistSelection'
    removeAlbumSelection = =>
      galleries = []
      galleries.push gal for gal in Gallery.records
      for item in galleries
        galleryEl = @children().forItem(item)
        albumsEl = galleryEl.find('li')
        $('.glyphicon', albumsEl).removeClass('glyphicon-folder-open')
        
        
    if gallery
      removeAlbumSelection()
      galleryEl = @children().forItem(gallery)
      albumsEl = galleryEl.find('li')
      albumsEl.removeClass('selected').removeClass('active')
      
      albums = Gallery.selectionList()
      for album in albums
        if alb = Album.exists(album)
          albumsEl.forItem(alb).addClass('selected') 
        
      if activeAlbum = Album.exists(albums.first())
        activeEl = albumsEl.forItem(activeAlbum).addClass('active')
        $('.glyphicon', activeEl).addClass('glyphicon-folder-open')
        
    @refreshElements()
    
  activate: (idOrRecord) ->
    Gallery.current(idOrRecord)
    Album.trigger('activate', Gallery.selectionList()[0])
    @exposeSelection()

  clickAlbum: (e) ->
    galleryEl = $(e.target).parents('.gal').addClass('active')
    albumEl = $(e.currentTarget)
    galleryEl = $(e.currentTarget).closest('.gal')
    
    album = albumEl.item()
    gallery = galleryEl.item()
    
    Gallery.updateSelection [album.id]
    
    @navigate '/gallery', gallery.id + '/' + album.id
    
    Gallery.trigger('activate', gallery)
    
    e.stopPropagation()
    e.preventDefault()
    
  clickGallery: (e) ->
    console.log 'SidebarList::clickGallery'
    e.stopPropagation()
    e.preventDefault()
    galleryEl = $(e.target).closest('li.gal')
    item = galleryEl.item()
    @expand(item) if item
    $(e.currentTarget).closest('.gal').addClass('active')
    item = $(e.target).closest('.data').item()
    
    @navigate '/gallery', item?.id or ''
    
#    @closeAllSublists(Gallery.record)
    
  clickExpander: (e) ->
    console.log 'expander'
    galleryEl = $(e.target).closest('li.gal')
    item = galleryEl.item()
    @expand(item, false, e) if item
    
    e.stopPropagation()
    e.preventDefault()
    
    
  expand: (item, force, e) ->
    galleryEl = @galleryFromItem(item)
    expander = $('.expander', galleryEl)
    if e
      targetIsExpander = $(e.currentTarget).hasClass('expander')
    
    if force
      @openSublist(galleryEl)
    else
      isOpen = expander.hasClass('open')
      isActive = galleryEl.hasClass('active')

      if isOpen
        @closeSublist(galleryEl) if isActive or targetIsExpander
      else
        @openSublist(galleryEl)
        
  openSublist: (el) ->
    expander = $('.expander', el)
    sublist = $('.sublist', el)
    expander.addClass('open')
    sublist.show()
    
  closeSublist: (el) ->
    expander = $('.expander', el)
    sublist = $('.sublist', el)
    expander.removeClass('open')
    sublist.hide()
      
  galleryFromItem: (item) ->
    @children().forItem(item)
    
  expandAfterTimeout: (e, timer) ->
    console.log timer
    clearTimeout timer
    galleryEl = $(e.target).closest('.gal.item')
    item = galleryEl.item()
    return unless item and item.id isnt Spine.dragItem.origin.id
    @expand(item, true)

  close: () ->
    
  closeAllSublists: (item) ->
    for gallery in Gallery.all()
      parentEl = @galleryFromItem gallery
      unless parentEl.hasClass('manual')
        @expand gallery, item?.id is gallery.id
        
    
  show: (e) ->
    App.contentManager.change App.showView
    e.stopPropagation()
    e.preventDefault()
    
module?.exports = SidebarList