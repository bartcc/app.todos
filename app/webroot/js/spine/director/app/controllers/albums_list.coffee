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
    'click .item'             : 'click'
    'click .icon-set .delete' : 'deleteAlbum'
    'click .icon-set .back'   : 'back'
    'click .icon-set .zoom'   : 'zoom'
    'mouseenter .item'        : 'infoEnter'
    'mousemove'               : 'infoMove'
    'mousemove .item'         : 'infoUp'
    'mouseleave .item'        : 'infoBye'
    'drop'                    : 'drop'
    'dragstart .item'         : 'stopInfo'
    'dragstart'               : 'dragstart'
    
  constructor: ->
    super
    # initialize flickr's slideshow
#    @el.toggleSlideshow()
    Album.bind('update destroy', @proxy @change)
    Album.bind("ajaxError", Album.errorHandler)
    Photo.bind('refresh', @proxy @refreshBackgrounds)
    AlbumsPhoto.bind('beforeDestroy', @proxy @widowedAlbumsPhoto)
    AlbumsPhoto.bind('destroy create', @proxy @updateBackgrounds)
    GalleriesAlbum.bind('change', @proxy @changeRelatedAlbum)
    Album.bind('activate', @proxy @activate)
    
  change: (album, mode, options) ->
    switch mode
      when 'update'
        return
        @updateTemplate(album)
      when 'destroy'
        @children().forItem(album, true).remove()
    @refreshElements()
  
  changeRelatedAlbum: (item, mode) ->
    # if we change a different gallery from within the sidebar, should not be reflected here
    return unless Gallery.record.id is item['gallery_id']
    return unless album = Album.exists(item['album_id'])
    
    switch mode
      when 'create'
        wipe = Gallery.record and Gallery.record.count() is 1
        @el.empty() if wipe
        @append @template album
        @renderBackgrounds [album]
        @el.sortable('destroy').sortable('album')
        
      when 'destroy'
        albumEl = @children().forItem(album, true)
        albumEl.remove()
        if gallery = Gallery.record
          @parent.render() unless gallery.count()
          
      when 'update'
        album = Album.exists(item['album_id'])
        @change(album, mode)
        @el.sortable('destroy').sortable('album')
        
    Album.trigger('activate', Gallery.selectionList())
    @el
  
  render: (items=[], mode) ->
    console.log 'AlbumsList::render'
    if items.length
      @html @template items
    else
      if Gallery.record
        if Album.count()
          @html '<label class="invite"><span class="enlightened">This Gallery has no albums. &nbsp;<button class="optCreateAlbum dark large">New Album</button><button class="optShowAllAlbums dark large">Show existing Albums</button></span></label>'
        else
          @html '<label class="invite"><span class="enlightened">This Gallery has no albums.<br>It\'s time to create one.<br><button class="optCreateAlbum dark large">New Album</button></span></label>'
      else
        @html '<label class="invite"><span class="enlightened">You have no albums so far.<br><button class="optCreateAlbum dark large">New Album</button></span></label>'
    
    @renderBackgrounds items, mode
    Album.trigger('activate', Gallery.selectionList())
    @el
  
  updateTemplate: (album) ->
    helper =
      refresh: =>
        el = @children().forItem(album)
        tb = $('.thumbnail', el)
        el: el
        tb: tb

    elements = helper.refresh()
    
    #on "change" events Spine additionally triggers "create/update/destroy" respectively
    return unless elements.el().length
    active = elements.el.hasClass('active')
    css = elements.el.attr('style')
    tmplItem = elements.el.tmplItem()
    tmplItem.tmpl = $( "#albumsTemplate" ).template()
    tmplItem.update()
    
    elements = helper.refresh()
    
    elements.el.toggleClass('active', active)
    elments.el.attr('style', css)
    @refreshElements()
    
  exposeSelection: ->
    list = Gallery.selectionList().slice(0)
    
    list.push Album.record.id if !list.length and Album.record
    @deselect()
    for id in list
      if album = Album.exists(id)
        el = @children().forItem(album, true)
        el.addClass("active")
        if Album.record.id is album.id
          el.addClass("hot")
        
    Spine.trigger('expose:sublistSelection', Gallery.record)
  
  activate: (items = [], toggle) ->
    id = null
    unless Spine.isArray items
      items = [items]
    
    for item in items
      if album = Album.exists(item?.id or item)
        unless album.destroyed
          album.addToSelection() unless toggle
          unless id
            id = album.id
      
    if id
      App.sidebar.list.expand(Gallery.record, true)
      App.sidebar.list.closeAllSublists(Gallery.record)
      
    Album.current(Gallery.selectionList()[0] or null)
      
    @exposeSelection()
  
  select: (items = [], lonely) ->
    unless Spine.isArray items
      items = [items]
    
    for item in items
      item.addRemoveSelection(lonely)
      
    Album.trigger('activate', item, true)
    
  click: (e) ->
    console.log 'AlbumsList::click'
    item = $(e.currentTarget).item()
    @select(item, @isCtrlClick(e))
    
    
    e.stopPropagation()
    e.preventDefault()
    
  zoom: (e) ->
    item = $(e.currentTarget).item()
    
    @select(item, true)
    @stopInfo()
    @navigate '/gallery', (Gallery.record?.id or ''), item.id
    
    e.stopPropagation()
    e.preventDefault()
  
  updateBackgrounds: (ap, mode) ->
    console.log 'AlbumsList::updateBackgrounds'
    albums = ap.albums()
    @renderBackgrounds albums
    
  refreshBackgrounds: (photos) ->
    album = App.upload.album
    @renderBackgrounds [album] if album
  
  # remember the AlbumPhoto before it gets deleted (to remove widowed photo thumbnails)
  widowedAlbumsPhoto: (ap) ->
    @widows = ap.albums()
  
  renderBackgrounds: (albums) ->
    console.log 'AlbumsList::renderBackgrounds'
    return unless App.ready
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

  back: ->
    @navigate '/galleries/'

  deleteAlbum: (e) ->
    item = $(e.currentTarget).item()
    return unless item?.constructor?.className is 'Album'
#    Gallery.updateSelection item.id
    
    el = $(e.currentTarget).parents('.item')
    el.removeClass('in')
    
    @stopInfo()
    
    window.setTimeout( =>
      Spine.trigger('destroy:album', [item.id])
      el.remove()
    , 200)
    
    
    e.stopPropagation()
    e.preventDefault()
    
  infoUp: (e) =>
    @info.up(e)
    el = $('.icon-set' , $(e.currentTarget)).addClass('in').removeClass('out')
    
  infoBye: (e) =>
    @info.bye()
    el = $('.icon-set' , $(e.currentTarget)).addClass('out').removeClass('in')
    
  stopInfo: (e) =>
    @info.bye()
    
  infoEnter: (e) ->
    
  infoMove: (e) ->

module?.exports = AlbumsList