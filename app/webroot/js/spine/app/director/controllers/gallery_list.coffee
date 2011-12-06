Spine ?= require("spine")
$      = Spine.$

class GalleryList extends Spine.Controller

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
    $('#galleriesContentTemplate').tmpl(items)
    
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
    
  template: -> arguments[0]

  change: (item, mode, e) =>
    console.log 'GalleryList::change'
    previous = @current
    if e
      cmdKey = @isCtrlClick(e)
      dblclick = e.type is 'dblclick' 

    @children().removeClass("active")
    if (!cmdKey)
      # don't touch @current if we're just updating
      switch mode
        when 'destroy'
          @current = false
        else
          @current = item unless mode is 'update'
          @children().forItem(@current).addClass("active")
    else
      @current = false
    
    Gallery.current(@current)
    Spine.trigger('change:selectedGallery', @current, mode)# if !previous or previous?.id != @current?.id or cmdKey
    
    if mode is 'edit'
      App.showView.btnEditGallery.click()
    else if mode is 'show'
      Spine.trigger('show:albums')
        
  render: (galleries, gallery, mode) ->
    console.log 'GalleryList::render'
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
        App.ready = true
        @children(":first").click()

  renderAllSublist: ->
    for gal in Gallery.records
      @renderOneSublist gal
  
  renderOneSublist: (gallery = Gallery.record) ->
    console.log 'GalleryList::renderSublist'
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
  
  updateTemplate: (gallery) ->
    galleryEl = @children().forItem(gallery)
    galleryContentEl = $('.item-content', galleryEl)
    tmplItem = galleryContentEl.tmplItem()
    tmplItem.tmpl = $( "#galleriesContentTemplate" ).template()
    tmplItem.update()# unless Gallery.record.id is gallery.id
    
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
  
  exposeSublistSelection: (gallery) ->
    console.log 'GalleryList::exposeSublistSelection'
    galleryEl = @children().forItem(gallery)
    albums = galleryEl.find('li')
    albums.removeClass('active')
    for id in Gallery.selectionList()
      album = Album.find(id) if Album.exists(id)
      albums.forItem(album).addClass('active') 

  clickAlb: (e) ->
    console.log 'GalleryList::albclick'
    albumEl = $(e.currentTarget)
    galleryEl = $(e.currentTarget).closest('li.gal')
    
    album = albumEl.item()
    gallery = galleryEl.item()
    
    unless @isCtrlClick(e)
      previous = Album.record
      Gallery.current(gallery)
      Album.current(album)
      Gallery.updateSelection [album.id]

      if App.hmanager.hasActive()
        @openPanel('album', App.showView.btnAlbum)

    else
      Gallery.current()
      Album.current()
      Gallery.emptySelection()
      Album.emptySelection()
      
    @change Gallery.record
    @exposeSublistSelection(Gallery.record)
    App.showView.trigger('change:toolbar', 'Album')
    Spine.trigger('show:photos')
    Spine.trigger('change:selectedAlbum', album) unless album.id is previous?.id
    
    e.stopPropagation()
    e.preventDefault()
    false
    
  click: (e) ->
    console.log 'GalleryList::click'
    item = $(e.target).item()
    
    @change item, 'show', e
    @exposeSublistSelection(item)
    
    App.showView.trigger('change:toolbar', 'Gallery')
    
    e.stopPropagation()
    e.preventDefault()
    false

  dblclick: (e) ->
    console.log 'GalleryList::edit'
    item = $(e.target).item()
    App.showView.lockToolbar()
    @change item, 'edit', e
    App.showView.unlockToolbar()
    
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
      @exposeSublistSelection gallery
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
    
module?.exports = GalleryList