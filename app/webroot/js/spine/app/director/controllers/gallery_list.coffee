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
#    @sublist = new ImageList
#      el: @items,
#      template: @template

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
      
    App.showView.trigger('change:toolbar', 'Gallery')

  
  render: (items, item, mode) ->
    console.log 'GalleryList::render'
    unless item
      #inject counter
      for record in items
        record.count = Album.filter(record.id).length

      @items = items
      @html @template @items
    else if mode is 'update'
      old_content = $('.item-content', '#'+item.id)
      new_content = $('.item-content', @template item).html()
      old_content.html new_content
    else if mode is 'create'
      @append @template item
    else if mode is 'destroy'
      $('#'+item.id).remove()

    @change item, mode
    if (!@current or @current.destroyed) and !(mode is 'update')
      unless @children(".active").length
        @children(":first").click()

  renderSublist: (gallery) ->
    console.log 'GalleryList::renderSublist'
    albums = Album.filter(gallery.id)
    # inject albums extras
    albums.push {flash: 'no albums'} unless albums.length
    $('#'+gallery.id+' ul').html @sublistTemplate(albums)
    
    @exposeSublistSelection(gallery)
    
  exposeSublistSelection: (gallery) ->
    console.log 'GalleryList::exposeSublistSelection'
    gallery = @children().forItem(gallery)
    albums = gallery.find('li')
    albums.removeClass('active')
    for id in Gallery.selectionList()
      album = Album.find(id)
      albums.forItem(album).addClass('active') 

  children: (sel) ->
    @el.children(sel)

  clickAlb: (e) ->
    console.log 'GalleryList::albclick'
    albumEl = $(e.currentTarget)
    galleryEl = $(e.currentTarget).closest('li.gal')
    
    album = albumEl.item()
    gallery = galleryEl.item()
    
    Gallery.current(gallery)
    Album.current(album)
    
    Gallery.updateSelection [album.id]
    
    if App.hmanager.hasActive()
      @openPanel('album', App.showView.btnAlbum)
      
    @change gallery
    Spine.trigger('change:selectedAlbum', album)
    Spine.trigger('show:photos', album)
    
    e.stopPropagation()
    e.preventDefault()
    false
    
  click: (e) ->
    console.log 'GalleryList::click'
    item = $(e.target).item()
    #Spine.trigger('change:selected', item.constructor.className) unless @isCtrlClick(e)
    # Note: don't trigger toolbar here - since Spine.trigger('change:toolbar', 'Gallery')
    @change item, 'show', e
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
      content.show()
    else
      content.hide()

    e.stopPropagation()
    e.preventDefault()
    false

module?.exports = GalleryList