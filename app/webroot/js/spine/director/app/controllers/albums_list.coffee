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
    Album.bind('change', @proxy @change)
    Album.bind("ajaxError", Album.errorHandler)
    Photo.bind('refresh', @proxy @refreshBackgrounds)
    AlbumsPhoto.bind('beforeDestroy', @proxy @widowedAlbumsPhoto)
    AlbumsPhoto.bind('destroy create', @proxy @updateBackgrounds)
    GalleriesAlbum.bind('change', @proxy @changeRelatedAlbum)
    Spine.bind('album:activate', @proxy @activate)
    
  change: (album, mode, options) ->
    switch mode
      when 'update'
        el = =>
          try
            @children().forItem(album)
          catch e
            []
        tb = -> $('.thumbnail', el())

        #Spine triggers 'update' also on new items
        return unless el().length

        active = el().hasClass('active')
        css = el().attr('style')
        tmplItem = el().tmplItem()
        tmplItem.tmpl = $( "#albumsTemplate" ).template()
        tmplItem.update()
        el().toggleClass('active', active)
        el().attr('style', css)
        @refreshElements()
        
      when 'destroy'
        @children().forItem(album, true).remove()
    
      when 'create'
        unless Gallery.record
          @children().forItem(album, true).remove()
        
  render: (items=[], mode) ->
    console.log 'AlbumsList::render'
      
    if items.length
      @html @template items
    else
      if !Gallery.record
        @navigate '/galleries/'
      else if Album.count()
        @html '<label class="invite"><span class="enlightened">This Gallery has no albums. &nbsp;<button class="optCreateAlbum dark large">New Album</button><button class="optShowAllAlbums dark large">Show existing Albums</button></span></label>'
      else
        @html '<label class="invite"><span class="enlightened">This Gallery has no albums.<br>It\'s time to create one.<br><button class="optCreateAlbum dark large">New Album</button></span></label>'
    
    
    @renderBackgrounds items, mode
    @el
  
  changeRelatedAlbum: (item, mode) ->
    # if we change a different gallery from within the sidebar, should not be reflected here
    return unless Gallery.record.id is item['gallery_id']
    return unless album = Album.exists(item['album_id'])
    
    switch mode
      when 'create'
        wipe = Gallery.record and Gallery.record.contains() is 1
        @el.empty() if wipe
        @append @template album
        @renderBackgrounds [album]
        @el.sortable('destroy').sortable('album')
        
      when 'destroy'
        albumEl = @children().forItem(album, true)
        albumEl.remove()
        if gallery = Gallery.record
          @parent.render() unless gallery.contains()
          
      when 'update'
        album = Album.exists(item['album_id'])
        @change(album, mode)
        @el.sortable('destroy').sortable('album')
        
    @exposeSelection()
    @el
  
  updateTemplate: (item) ->
    
    
  exposeSelection: ->
    list = Gallery.selectionList()
    list.push Album.record.id if !list.length and Album.record
    @deselect()
    for id in list
      if item = Album.exists(id)
        el = @children().forItem(item, true)
        el.addClass("active")
        
    Spine.trigger('expose:sublistSelection', Gallery.record)
  
  activate: (id) ->
    selection = Gallery.selectionList()
    return unless Spine.isArray selection
    
    if selection.length
      last = Album.exists(selection[selection.length-1])
      unless last?.destroyed
        Album.current(last)
    if id and Album.exists(id)
      Album.current(id)
    else
      Album.current()
      
    @exposeSelection()
  
  select: (item, lonely) ->
    it = item?.addRemoveSelection(lonely)
    Spine.trigger('album:activate')
    
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
    return unless album?.contains?()
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
    el.css('backgroundImage', css)
  
  click: (e) ->
    console.log 'AlbumsList::click'
    item = $(e.currentTarget).item()
    @select(item, @isCtrlClick(e))
    
    e.stopPropagation()
    e.preventDefault()

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
    Gallery.updateSelection item.id
    
    el = $(e.currentTarget).parents('.item')
    el.removeClass('in')
    
    @stopInfo()
    
    window.setTimeout( =>
      Spine.trigger('destroy:album')
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