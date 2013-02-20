Spine ?= require("spine")
$      = Spine.$

class SidebarList extends Spine.Controller

  @extend Spine.Controller.Drag
  @extend Spine.Controller.KeyEnhancer
  
  elements:
    '.gal.item'               : 'item'
    '.expander'               : 'expander'

  events:
    'click'                           : 'show'
    "click      .gal.item"            : "click",
    "dblclick   .gal.item"            : "dblclick"
    "click      .alb.item"            : "clickAlbum",
    "click      .expander"            : "expand"
    'dragstart  .sublist-item'        : 'dragstart'
    'dragenter  .sublist-item'        : 'dragenter'
    'dragleave  .sublist-item'        : 'dragleave'
    'drop       .sublist-item'        : 'drop'
    'dragend    .sublist-item'        : 'dragend'

  selectFirst: false
    
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
    Album.bind('update', @proxy @renderAllSublist)
    Spine.bind('render:galleryAllSublist', @proxy @renderAllSublist)
    Spine.bind('drag:timeout', @proxy @expandAfterTimeout)
    Spine.bind('expose:sublistSelection', @proxy @exposeSublistSelection)
    Spine.bind('gallery:exposeSelection', @proxy @exposeSelection)
    Spine.bind('gallery:activate', @proxy @activate)
    
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
#          @update item
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
#        @children(":first").click()
  
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
    for gal of Gallery.records
      @renderOneSublist Gallery.records[gal]
  
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
    console.log gallery
    console.log galleryEl
    gallerySublist = $('ul', galleryEl)
    gallerySublist.html @sublistTemplate(albums)
    
    @updateTemplate gallery
  
  exposeSelection: (item = Gallery.record) ->
    console.log 'SidebarList::exposeSelection'
    @deselect()
    alert 'deselect'
    @children().forItem(item).addClass("active") if item
    @exposeSublistSelection()
        
  exposeSublistSelection: ->
    console.log 'SidebarList::exposeSublistSelection'
    removeAlbumSelection = =>
      galleries = []
      galleries.push val for item, val of Gallery.records
      for item in galleries
        galleryEl = @children().forItem(item)
        albums = galleryEl.find('li')
        albums.removeClass('selected').removeClass('active')
        
    if Gallery.record
      removeAlbumSelection()
      galleryEl = @children().forItem(Gallery.record)
      albums = galleryEl.find('li')
      for id in Gallery.selectionList()
        album = Album.find(id) if Album.exists(id)
        if album
          albums.forItem(album).addClass('selected')
          if id is Album.record?.id
            album = Album.exists(Album.record.id)
            albums.forItem(album).addClass('active')
    else
      removeAlbumSelection()
  
  updateTemplate: (item) ->
    console.log item
    galleryEl = @children().forItem(item)
    galleryContentEl = $('.item-content', galleryEl)
    console.log galleryContentEl
    tmplItem = galleryContentEl.tmplItem()
    if tmplItem
      console.log tmplItem
      tmplItem.tmpl = $( "#sidebarContentTemplate" ).template()
      tmplItem.update()
      # restore active
#      @exposeSublistSelection item
    
  renderItemFromGalleriesAlbum: (ga, mode) ->
    gallery = Gallery.find(ga.gallery_id) if Gallery.exists(ga.gallery_id)
    @renderOneSublist gallery
    
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
#    Spine.trigger('show:albums')
    item = Gallery.current(idOrRecord)
    diff = item?.id is not Gallery.record?.id
    @navigate '/gallery', item.id if diff
    @exposeSelection()

  exposeSelection: (item = Gallery.record) ->
    @children().removeClass('active')
    @children().forItem(item).addClass("active") if item
    @exposeSublistSelection()

  exposeSublistSelection: ->
    removeAlbumSelection = =>
      galleries = []
      galleries.push val for item, val of Gallery.records
      for item in galleries
        galleryEl = @children().forItem(item)
        albums = galleryEl.find('li')
        albums.removeClass('selected').removeClass('active')
        
    if Gallery.record
      removeAlbumSelection()
      galleryEl = @children().forItem(Gallery.record)
      albums = galleryEl.find('li')
      for id in Gallery.selectionList()
        album = Album.find(id) if Album.exists(id)
        if album
          albums.forItem(album).addClass('selected')
          if id is Album.record?.id
            album = Album.exists(Album.record.id)
            albums.forItem(album).addClass('active')
    else
      removeAlbumSelection()

  clickAlbum: (e) ->
    galleryEl = $(e.target).parents('.gal').addClass('active')
#    albumEl = $(e.target).parents('.alb').addClass('active')
    albumEl = $(e.currentTarget)
    galleryEl = $(e.currentTarget).closest('.gal')
    
    album = albumEl.item()
    gallery = galleryEl.item()
    
    unless @isCtrlClick(e)
#      unless Album.current.id is album.id
      album.updateSelection [album.id]
      @navigate '/gallery', gallery.id + '/' + album.id
    else
      @navigate '/photos/'
    
    
    @exposeSelection_(e)
    e.stopPropagation()
    e.preventDefault()
    
  click: (e) ->
    console.log 'SidebarList::click'
    $(e.currentTarget).closest('.gal').addClass('active')
#    dont act on no-gallery items like the 'no album' - info
    item = $(e.target).closest('.data').item()
    
    App.contentManager.change App.showView
    @navigate '/gallery', item?.id or ''
    
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
    
    
  expand: (e, force = false) ->
    parent = $(e.target).parents('li')
    gallery = parent.item()
    icon = $('.expander', parent)
    content = $('.sublist', parent)

    if force
      icon.toggleClass('expand', force)
    else
      icon.toggleClass('expand')
      
    if $('.expand', parent).length
      @renderOneSublist gallery
#      @exposeSublistSelection()
      content.show()
    else
      content.hide()

    e.stopPropagation()
    e.preventDefault()

  show: (e) ->
    App.contentManager.change App.showView
    e.stopPropagation()
    e.preventDefault()
    
module?.exports = SidebarList