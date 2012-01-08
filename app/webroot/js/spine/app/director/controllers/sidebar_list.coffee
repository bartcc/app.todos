Spine ?= require("spine")
$      = Spine.$

class SidebarList extends Spine.Controller

  @extend Spine.Controller.Drag

  elements:
    '.gal.item'               : 'item'
    '.expander'               : 'expander'

  events:
    'click'                           : 'show'
    "click      .gal.item"            : "click",
    "dblclick   .gal.item"            : "dblclick"
    "click      .alb.item"            : "clickAlb",
    "click      .expander"            : "expand"
    'dragstart  .sublist-item'        : 'dragstart'
    'dragenter  .sublist-item'        : 'dragenter'
    'dragover   .sublist-item'        : 'dragover'
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
    Album.bind('change', @proxy @renderItemFromAlbum)
    Spine.bind('render:galleryAllSublist', @proxy @renderAllSublist)
    Spine.bind('drag:timeout', @proxy @expandExpander)
    Spine.bind('expose:sublistSelection', @proxy @exposeSublistSelection)
    Spine.bind('gallery:exposeSelection', @proxy @exposeSelection)
    Spine.bind('gallery:activate', @proxy @activate)
    
  template: -> arguments[0]

  change: (item, mode, e) =>
    console.log 'SidebarList::change'
    
    
    ctrlClick = @isCtrlClick(e) if e
    unless ctrlClick
      switch mode
        when 'destroy'
          @current = false
        when 'edit'
          Spine.trigger('edit:gallery')
        when 'show'
          @current = item
          Spine.trigger('show:albums')
        when 'photo'
          @current = item
        when 'create'
          @current = item
          
    else
      @current = false
      switch mode
        when 'show'
          Spine.trigger('show:albums')
          
    Gallery.current(@current)
    @activate(@current)
        
  render: (galleries, gallery, mode) ->
    console.log 'SidebarList::render'
    # render a specific (activated) item
    if gallery and mode
      switch mode
        when 'update'
          @updateTemplate gallery
        when 'create'
          @append @template gallery
        when 'destroy'
          @children().forItem(gallery, true).remove()
          
    else if galleries
      @items = galleries
      @html @template @items
    
    @change gallery, mode
    if (!@current or @current.destroyed) and !(mode is 'update')
      unless @children(".active").length
#        App.ready = true
        @children(":first").click()

  renderAllSublist: ->
    for gal in Gallery.records
      @renderOneSublist gal
  
  renderOneSublist: (gallery = Gallery.record) ->
    console.log 'SidebarList::renderSublist'
    return unless gallery
    filterOptions =
      key:'gallery_id'
      joinTable: 'GalleriesAlbum'
    albums = Album.filter(gallery.id, filterOptions)
    for album in albums
      album.count = AlbumsPhoto.filter(album.id, key: 'album_id').length
    albums.push {flash: 'no albums'} unless albums.length
    
    galleryEl = @children().forItem(gallery)
    gallerySublist = $('ul', galleryEl)
    gallerySublist.html @sublistTemplate(albums)
    
    @updateTemplate gallery  
  
  activate: (gallery = Gallery.record) ->
    selectedAlbums = Gallery.selectionList()
    if selectedAlbums.length is 1
      active = Album.find(selectedAlbums[0]) if Album.exists(selectedAlbums[0])
      if active and !active.destroyed
        Album.current(active)
      else
        Album.current()
    else
      Album.current()
        
    selectedPhotos = Album.selectionList()
    if selectedPhotos.length is 1
      active = Photo.find(selectedPhotos[0]) if Photo.exists(selectedPhotos[0])
      if active and !active.destroyed
        Photo.current(active)
      else
        Photo.current()
    else
      Photo.current()
        
    @exposeSelection(gallery)
    Spine.trigger('change:selectedGallery', gallery, @mode)
    Spine.trigger('change:selectedAlbum', Album.record)
    Spine.trigger('change:selectedPhoto', Photo.record)
  
  updateTemplate: (gallery) ->
    galleryEl = @children().forItem(gallery)
    galleryContentEl = $('.item-content', galleryEl)
    tmplItem = galleryContentEl.tmplItem()
    tmplItem.tmpl = $( "#sidebarContentTemplate" ).template()
    tmplItem.update()
    # restore active
    @exposeSublistSelection gallery
    
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
  
  exposeSelection: (gallery) ->
    console.log 'SidebarList::exposeSelection'
    @deselect()
    @children().forItem(gallery).addClass("active") if gallery
    @exposeSublistSelection gallery
        
  exposeSublistSelection: (gallery) ->
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
        albums.forItem(album).addClass('selected')
      if Album.exists(Album.activeRecord?.id)
        album = Album.find(Album.activeRecord.id)
        albums.forItem(album).addClass('active')
    else
      removeAlbumSelection()

  clickAlb: (e) ->
    console.log 'SidebarList::albclick'
    albumEl = $(e.currentTarget)
    galleryEl = $(e.currentTarget).closest('li.gal')
    
    album = Album.activeRecord = albumEl.item()
    gallery = galleryEl.item()
    
    unless @isCtrlClick(e)
      previous = Album.record
      Gallery.current(gallery)
      Album.current(album)
      Gallery.updateSelection [album.id]

#      if App.hmanager.hasActive()
#        @openPanel('album', App.showView.btnAlbum)

      
      @exposeSublistSelection(Gallery.record)
#      Spine.trigger('change:selectedAlbum', album, Album.changed())
      Spine.trigger('change:selectedAlbum', album, (!previous or !(album.id is previous.id)))
      Spine.trigger('show:photos')
      @change Gallery.record, 'photo', e
    else
      Spine.trigger('show:allPhotos', true)
      
    
    e.stopPropagation()
    e.preventDefault()
    false
    
  click: (e) ->
    console.log 'SidebarList::click'
    item = $(e.currentTarget).item()
    
    @change item, 'show', e
    
    Spine.trigger('change:toolbar', ['Gallery'])
    App.contentManager.change(App.showView)
    
    e.stopPropagation()
    e.preventDefault()
    false

  dblclick: (e) ->
    console.log 'SidebarList::dblclick'
    item = $(e.target).item()
#    App.showView.lockToolbar()
    @change item, 'edit', e
#    App.showView.unlockToolbar()
    
    e.stopPropagation()
    e.preventDefault()
    false

  expandExpander: (e) ->
    el = $(e.target)
    closest = (el.closest('.item')) or []
    if closest.length
      expander = $('.expander', closest)
      if expander.length
        @expand(e, true)

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
      @exposeSublistSelection Gallery.record
      content.show()
    else
      content.hide()

    e.stopPropagation()
    e.preventDefault()
    false

  show: (e) ->
    App.contentManager.change App.showView
    e.stopPropagation()
    e.preventDefault()
    false
    
    
module?.exports = SidebarList