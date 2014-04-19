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
    
    'dragstart .item'                 : 'dragstart'
    'drop .item'                      : 'drop'
    'dragover   .items'               : 'dragover'
    
  constructor: ->
    super
    @widows = []
    
    Album.bind('update', @proxy @updateTemplate)
    Album.bind("ajaxError", Album.errorHandler)
    
    AlbumsPhoto.bind('beforeDestroy', @proxy @widowedAlbumsPhoto)
    Gallery.bind('change:selection', @proxy @exposeSelection)
    
  changedAlbums: (gallery) ->
    
    
  changeRelatedAlbum: (item, mode) ->
    return unless @parent and @parent.isActive()
    return unless Gallery.record
    return unless Gallery.record.id is item['gallery_id']
    return unless album = Album.exists(item['album_id'])
    console.log 'AlbumsList::changeRelatedAlbum'
    
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
        @exposeSelection()
          
      when 'update'
        @el.sortable('destroy').sortable()
    
    @refreshElements()
    @el
  
  render: (items=[], mode) ->
    console.log 'AlbumsList::render'
    if items.length
      @html @template items
      @renderBackgrounds items
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
    console.log 'AlbumsList::updateTemplate'
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
    console.log 'AlbumsList::exposeSelection'
    @deselect()
    list = selection or Gallery.selectionList()
    for id in list
      $('#'+id, @el).addClass("active")
    if first = list.first()
      $('#'+first, @el).addClass("hot")
    
#    for id in list
#      if album = Album.exists(id)
#        el = @children().forItem(album, true)
#        el.addClass("active")
#    if album = Album.exists(list.first())
#      el = @children().forItem(album, true)
#      el.addClass("hot")
      
  # workaround:
  # remember the Album since
  # after last AlbumPhoto is destroyed the Album container cannot be retrieved anymore
  widowedAlbumsPhoto: (ap) ->
    console.log 'AlbumsList::widowedAlbumsPhoto'
    list = ap.albums()
    @widows.push item for item in list
    @widows
  
  renderBackgrounds: (albums) ->
    console.log 'AlbumsList::renderBackgrounds'
    if @widows.length
      Model.Uri.Ajax.cache = false
      for widow in @widows
#        @processAlbum album
        $.when(@processAlbumDeferred(widow)).done (xhr, rec) =>
          @callback xhr, rec
      @widows = []
      Model.Uri.Ajax.cache = true
    for album in albums
#        @processAlbum album
      $.when(@processAlbumDeferred(album)).done (xhr, rec) =>
        @callback xhr, rec
  
  processAlbum: (album) ->
    data = album.photos(4)
  
    Photo.uri
      width: 50
      height: 50,
      (xhr, rec) => @callback(xhr, album)
      data
  
  processAlbumDeferred: (album) ->
    console.log 'AlbumsList::processAlbumDeferred'
    deferred = $.Deferred()
    data = album.photos(4)
    
    Photo.uri
      width: 50
      height: 50,
      (xhr, rec) -> deferred.resolve(xhr, album)#@callback(xhr, album)
      data
      
    deferred.promise()
      
  callback: (json, album) ->
    console.log 'AlbumsList::callback'
    el = $('#'+album.id, @el)
    thumb = $('.thumbnail', el)
    
    res = for jsn in json
      ret = for key, val of jsn
        val.src
      ret[0]
    
    css = for itm in res
      'url(' + itm + ')'
      
    thumb.css('backgroundImage', if css.length then css else 'url(img/drag_info.png)')

  zoom: (e) ->
    console.log 'AlbumsList::zoom'
    item = $(e.currentTarget).item()
    
#    @parent.select(item, true)
    @parent.stopInfo()
    @navigate '/gallery', (Gallery.record?.id or ''), item.id
    
    e.stopPropagation()
    e.preventDefault()
  
  back: (e) ->
    console.log 'AlbumsList::back'
    @navigate '/galleries/'

    e.stopPropagation()
    e.preventDefault()
    
  deleteAlbum: (e) ->
    console.log 'AlbumsList::deleteAlbum'
    item = $(e.currentTarget).item()
    return unless item?.constructor?.className is 'Album'
    
    Spine.trigger('destroy:album', [item.id])
    
    e.stopPropagation()
    e.preventDefault()
    
  add: (e) ->
    console.log 'AlbumsList::add'
    e.stopPropagation()
    e.preventDefault()
    
    Spine.trigger('albums:add')
    
module?.exports = AlbumsList