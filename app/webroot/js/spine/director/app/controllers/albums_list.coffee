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
    'click .opt-AddAlbums'         : 'add'
    'click .glyphicon-set .delete' : 'deleteAlbum'
    'click .glyphicon-set .back'   : 'back'
    'click .glyphicon-set .zoom'   : 'zoom'
    
    'dragstart'                    : 'dragstart'
    'drop'                         : 'drop'
    
    
  constructor: ->
    super
    @widows = []
    @bind('drag:start', @proxy @dragStart)
    @bind('drag:drop', @proxy @dragDrop)
    
    Album.bind('update', @proxy @updateTemplate)
    Album.bind("ajaxError", Album.errorHandler)
    Photo.bind('refresh', @proxy @refreshBackgrounds)
    AlbumsPhoto.bind('beforeDestroy', @proxy @widowedAlbumsPhoto)
    AlbumsPhoto.bind('destroy create', @proxy @updateBackgrounds)
    GalleriesAlbum.bind('change', @proxy @changeRelatedAlbum)
    Gallery.bind('change:selection', @proxy @exposeSelection)
    
  changeRelatedAlbum: (item, mode) ->
    console.log 'AlbumsList::changeRelatedAlbum'
    return unless @parent and @parent.isActive()
    return unless Gallery.record
    return unless Gallery.record.id is item['gallery_id']
    return unless album = Album.exists(item['album_id'])
    
    switch mode
      when 'create'
        wipe = Gallery.record and Gallery.record.count() is 1
        @el.empty() if wipe
        @append @template album
        @renderBackgrounds [album]
        @exposeSelection()
        @el.sortable('destroy').sortable()
        $('.tooltips', @el).tooltip()
        
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
      @exposeSelection()
    else if mode is 'add'
      @html '<label class="invite"><span class="enlightened">Nothing to add. &nbsp;</span></label>'
      @append '<h3><label class="invite label label-default"><span class="enlightened">Either no more albums can be added or there is no gallery selected.</span></label></h3>'
    else
      if Gallery.record
        if Album.count()
          @html '<label class="invite"><span class="enlightened">This Gallery has no albums. &nbsp;<div><span><button class="opt-CreateAlbum dark large">New Album</button></span><span><button class="opt-AddAlbums dark large">Add existing Albums</button></span></div></span></label>'
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
  
  exposeSelection: (selection) ->
    @deselect()
    list = selection or Gallery.selectionList()
    for id in list
      if album = Album.exists(id)
        el = @children().forItem(album, true)
        el.addClass("active")
    if album = Album.exists(list.first())
      el = @children().forItem(album, true)
      el.addClass("hot")
      
  updateBackgrounds: (ap, mode) ->
    console.log 'AlbumsList::updateBackgrounds'
    albums = ap.albums()
    @renderBackgrounds albums
    
  refreshBackgrounds: (photos) ->
    console.log 'AlbumsList::refreshBackgrounds'
    album = App.upload.album
    @renderBackgrounds [album] if album
  
  # remember the Album since
  # after AlbumPhoto is destroyed the Album container cannot be retrieved anymore
  widowedAlbumsPhoto: (ap) ->
    list = ap.albums()
    @widows.push item for item in list
    @widows
  
  renderBackgrounds: (albums) ->
    console.log 'AlbumsList::renderBackgrounds'
    if @widows.length
      Model.Uri.Ajax.cache = false
      for album in @widows
        @processAlbum album
      @widows = []
      Model.Uri.Ajax.cache = true
    else if albums.length
      for album in albums
        @processAlbum album
  
  processAlbum: (album) ->
    data = album.photos(4)
    
    Photo.uri
      width: 50
      height: 50,
      (xhr, rec) => @callback(xhr, album)
      data
      
  callback: (json, album) ->
    console.log 'AlbumsList::callback'
    el = @children().forItem(album)
    thumb = $('.thumbnail', el)
    search = (o) ->
      for key, val of o
        return o[key].src
    
    res = []
    for jsn in json
      res.push search(jsn)
      
    css = for itm, index in res
      'url(' + itm + ')'
      
    check_css =  ->
      (['url(img/drag_info.png)'] unless css.length) or css
      
    thumb.css('backgroundImage', check_css())

  zoom: (e) ->
    item = $(e.currentTarget).item()
    
#    @parent.select(item, true)
    @parent.stopInfo()
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
#      Gallery.removeFromSelection item.id
    , 200)
    
    e.stopPropagation()
    e.preventDefault()
    
  add: (e) ->
    e.stopPropagation()
    e.preventDefault()
    
    Spine.trigger('albums:add')
    
  dragStart: (e, id) ->
    if Gallery.selectionList().indexOf(id) is -1
      Album.trigger('activate', id)
      
  dragDrop: (e) ->
    
    
module?.exports = AlbumsList