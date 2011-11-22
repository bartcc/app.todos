Spine ?= require("spine")
$      = Spine.$

class GalleryList extends Spine.Controller

  @extend Spine.Controller.Drag

  elements:
    '.gal.item'               : 'item'
    '.expander'               : 'expander'
    

  events:
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
    
  sublistTemplate: (items) ->
    $('#albumsSublistTemplate').tmpl(items)
    
  constructor: ->
    super
    Spine.bind('drag:timeout', @proxy @expandExpander)
    Spine.bind('render:sublist', @proxy @renderSublist)
    Spine.bind('expose:sublistSelection', @proxy @exposeSublistSelection)

  template: -> arguments[0]

  change: (item, mode, e) =>
    console.log 'GalleryList::change'
    
    if e
      cmdKey = @isCtrlClick(e)
      dblclick = e.type is 'dblclick' 

    @children().removeClass("active")
    if (!cmdKey and item)
      # don't touch @current if we're just updating
      @current = item unless mode is 'update'
      @children().forItem(@current).addClass("active")
    else
      @current = false

    Gallery.current(@current)
    Spine.trigger('change:selectedGallery', @current, mode)
    
    if mode is 'edit'
      App.showView.btnEditGallery.click()
        
  render: (albums, gallery, mode) ->
    console.log 'GalleryList::render'
    unless gallery
      @items = albums
      @html @template @items
    else
      switch mode
        when 'update'
          gallerEl = @children().forItem(gallery)
          gallerEl.html @template(gallery).html()
        when 'create'
          @append @template gallery
        when 'destroy'
          $('#'+gallery.id).remove()
#          gallerEl.remove()

    @change gallery, mode
    if (!@current or @current.destroyed) and !(mode is 'update')
      unless @children(".active").length
        App.ready = true
        @children(":first").click()

  renderSublist: (gallery) ->
    console.log 'GalleryList::renderSublist'
    albums = Album.filter(gallery.id)
    total = 0
    # inject total images
    for album in albums
      total += album.count = AlbumsPhoto.filter(album.id).length

    albums.push {flash: 'no albums'} unless albums.length
    $('#'+gallery.id+' ul').html @sublistTemplate(albums)
    $('.item-header .cta', '#'+gallery.id).html Album.filter(gallery.id).length + ' <span style="font-size: 0.5em;">(' + total + ')</span>'
    
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
    Gallery.current(gallery)
    
    unless @isCtrlClick(e)
      previous = Album.record
      Album.current(album)
      Gallery.updateSelection [album.id]

      if App.hmanager.hasActive()
        @openPanel('album', App.showView.btnAlbum)

    else
      Album.current()
      Gallery.emptySelection()
      Album.emptySelection()
      
    @change gallery
    @exposeSublistSelection(gallery)
    App.showView.trigger('change:toolbar', 'Album')
    Spine.trigger('show:photos', album)
    Spine.trigger('change:selectedAlbum', album) unless album.id is previous.id
    
    e.stopPropagation()
    e.preventDefault()
    false
    
  click: (e) ->
    console.log 'GalleryList::click'
    item = $(e.target).item()
    #Spine.trigger('change:selected', item.constructor.className) unless @isCtrlClick(e)
    # Note: don't trigger toolbar here - since Spine.trigger('change:toolbar', 'Gallery')
    
    @change item, 'show', e
    @exposeSublistSelection(item)
    App.showView.trigger('change:toolbar', 'Gallery')
    Spine.trigger('show:albums')
    
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
      @renderSublist gallery
      @exposeSublistSelection gallery
      content.show()
    else
      content.hide()

    e.stopPropagation()
    e.preventDefault()
    false

module?.exports = GalleryList