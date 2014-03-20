Spine           = require("spine")
$               = Spine.$
Model           = Spine.Model
Gallery         = require('models/gallery')
Album           = require('models/album')
Photo           = require('models/photo')
AlbumsPhoto     = require('models/albums_photo')
GalleriesAlbum  = require('models/galleries_album')
Extender        = require("plugins/controller_extender")
Drag            = require("plugins/drag")

require("plugins/tmpl")

class AlbumsList extends Spine.Controller
  
  @extend Extender
  @extend Drag
  
  events:
    'click .item'                  : 'click'
    'click .glyphicon-set .delete' : 'deleteAlbum'
    'click .glyphicon-set .back'   : 'back'
    'click .glyphicon-set .zoom'   : 'zoom'
    'dragstart .item'              : 'stopInfo'
    'dragstart'                    : 'dragstart'
    'mousemove .item'              : 'infoUp'
    'mouseleave .item'             : 'infoBye'
    
  constructor: ->
    super
    @bind('drag:start', @proxy @dragStart)
    Album.bind('update', @proxy @updateTemplate)
    Album.bind("ajaxError", Album.errorHandler)
    Album.bind('activate', @proxy @activate)
    Photo.bind('refresh', @proxy @refreshBackgrounds)
    AlbumsPhoto.bind('beforeDestroy', @proxy @widowedAlbumsPhoto)
    AlbumsPhoto.bind('destroy create', @proxy @updateBackgrounds)
    GalleriesAlbum.bind('change', @proxy @changeRelatedAlbum)
    
  changeRelatedAlbum: (item, mode) ->
    console.log 'AlbumsList::changeRelatedAlbum'
    # if we change a different gallery from within the sidebar, it should not be reflected here
    return unless @parent.isActive()
    return unless Gallery.record
    return unless Gallery.record.id is item['gallery_id']
    return unless album = Album.exists(item['album_id'])
    
    switch mode
      when 'create'
        wipe = Gallery.record and Gallery.record.count() is 1
        @el.empty() if wipe
        @append @template album
        @renderBackgrounds [album]
        @activate album.id
        @el.sortable('destroy').sortable()
        
      when 'destroy'
        albumEl = @children().forItem(album, true)
        albumEl.detach()
        if gallery = Gallery.record
          @parent.render() unless gallery.count()
          
      when 'update'
        @el.sortable('destroy').sortable()
    
    @refreshElements()
    @el
  
  render: (items=[], mode) ->
    console.log 'AlbumsList::render'
    if items.length
      @html @template items
      @renderBackgrounds items, mode
      @el.sortable() if Gallery.record
      @activate()
    else
      if Gallery.record
        if Album.count()
          @html '<label class="invite"><span class="enlightened">This Gallery has no albums. &nbsp;<div><span><button class="opt-CreateAlbum dark large">New Album</button></span><span><button class="opt-ShowAllAlbums dark large">Show existing Albums</button></span></div></span></label>'
        else
          @html '<label class="invite"><span class="enlightened">This Gallery has no albums.<br>It\'s time to create one.<div><button class="opt-CreateAlbum dark large">New Album</button></div></span></label>'
      else
        @html '<label class="invite"><span class="enlightened">You don\'t have any albums yet<div><button class="opt-CreateAlbum dark large">New Album</button></div></span></label>'
    @el
  
  updateTemplate: (album) ->
    albumEl = @children().forItem(album)
    contentEl = $('.thumbnail', albumEl)
    active = albumEl.hasClass('active')
    hot = albumEl.hasClass('hot')
    style = contentEl.attr('style')
    tmplItem = contentEl.tmplItem()
    alert 'no tmpl item' unless tmplItem
    if tmplItem
      tmplItem.tmpl = $( "#albumsTemplate" ).template()
      tmplItem.update?()
      albumEl = @children().forItem(album)
      contentEl = $('.thumbnail', albumEl)
      albumEl.toggleClass('active', active)
      albumEl.toggleClass('hot', hot)
      contentEl.attr('style', style)
    @el.sortable()
    
  exposeSelection: ->
    @deselect()
    list = Gallery.selectionList()
    for id in list
      if album = Album.exists(id)
        el = @children().forItem(album, true)
        el.addClass("active")
        if Album.record.id is album.id
          el.addClass("hot")
        
    Spine.trigger('expose:sublistSelection', Gallery.record)
  
  activate: (items=Gallery.selectionList()) ->
    id = null
    unless Album.isArray items
      unique = true
      items = [items]
    
    id = items[0]
    for item in items
      if album = Album.exists item
        album.addToSelection(unique)
        
    if id
      App.sidebar.list.expand(Gallery.record, true)
      
    Album.current(id)
#    unless Album.state
#      @navigate '/album_notfound'
#      return
    @exposeSelection()
  
  click: (e) ->
    item = $(e.currentTarget).item()
    @select(item, @isCtrlClick(e))
    
    e.stopPropagation()
    e.preventDefault()
    
  select: (items = [], exclusive) ->
    unless Spine.isArray items
      items = [items]
      
    list = []
    for item in items
      exists = Gallery.selectionList().indexOf(item.id) isnt -1
      if !Album.record and Gallery.selectionList().length and exists
        list = item.shiftSelection() if exists
      else
        list = item.addRemoveSelection(exclusive)
      
    Album.trigger('activate', list, true)
    
  updateBackgrounds: (ap, mode) ->
    console.log 'AlbumsList::updateBackgrounds'
    albums = ap.albums()
    @renderBackgrounds albums
    
  refreshBackgrounds: (photos) ->
    console.log 'AlbumsList::refreshBackgrounds'
    album = App.upload.album
    @renderBackgrounds [album] if album
  
  # remember the AlbumPhoto before it gets deleted (to remove widowed photo thumbnails)
  widowedAlbumsPhoto: (ap) ->
    @widows = ap.albums()
  
  renderBackgrounds: (albums) ->
    console.log 'AlbumsList::renderBackgrounds'
#    return unless App.ready
    if albums.length
      for album in albums
        @processAlbum album
    else if @widows?.length
      @processAlbum album for album in @widows
      @widows = []
  
  processAlbum: (album) ->
    data = album.photos(4)
      
    Photo.uri
      width: 50
      height: 50,
      (xhr, rec) => @callback(xhr, album)
      data
      
  callback: (json, album) =>
    console.log 'AlbumsList::callback'
    el = @children().forItem(album)
    el = $('.thumbnail', el)
    search = (o) ->
      for key, val of o
        return o[key].src
    
    res = []
    for jsn in json
      res.push search(jsn)
      
    css = for itm in res
      'url(' + itm + ')'
    check_css =  ->
      (['url(img/drag_info.png)'] unless css.length) or css
      
    el.css('backgroundImage', check_css())

  loadtest: (t) ->
    test = $('.item', @el).each ->
      len = $(@).data('queue')
      if len and len.length
        return true
      else
        return false 

  zoom: (e) ->
    item = $(e.currentTarget).item()
    
    @select(item, true)
    @stopInfo()
    @navigate '/gallery', (Gallery.record?.id or ''), item.id
    
    e.stopPropagation()
    e.preventDefault()
  
  back: (e) ->
    @navigate '/galleries/'

    e.stopPropagation()
    e.preventDefault()
    
  deleteAlbum: (e) ->
    item = $(e.currentTarget).item()
    return unless item?.constructor?.className is 'Album'
    
    el = @findModelElement item
    el.removeClass('in')
    
    
    window.setTimeout( =>
      Spine.trigger('destroy:album', [item.id])
      Gallery.removeFromSelection item.id
      @stopInfo()
    , 200)
    
    e.stopPropagation()
    e.preventDefault()
    
  infoUp: (e) =>
    @info.up(e)
    el = $('.glyphicon-set' , $(e.currentTarget)).addClass('in').removeClass('out')
    
  infoBye: (e) =>
    @info.bye(e)
    el = $('.glyphicon-set' , $(e.currentTarget)).addClass('out').removeClass('in')
    
  stopInfo: (e) =>
    @info.bye(e)
    
  dragStart: (e, o) ->
    if Gallery.selectionList().indexOf(Spine.dragItem.source.id) is -1
      @activate Spine.dragItem.source.id
    
module?.exports = AlbumsList