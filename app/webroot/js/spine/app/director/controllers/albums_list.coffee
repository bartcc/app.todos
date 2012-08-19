Spine ?= require("spine")
$      = Spine.$

class AlbumsList extends Spine.Controller
  
  events:
    'click .item'             : 'click'
    'click .icon-set .delete' : 'deleteAlbum'
    'click .icon-set .zoom'   : 'zoom'
#    'dblclick .item'          : 'dblclick'
#    'over'                    : 'hideInfo'
    'mouseenter .item'        : 'infoEnter'
    'mousemove'               : 'infoMove'
    'mousemove .item'         : 'infoUp'
    'mouseleave .item'        : 'infoBye'
    'dragstart .item'         : 'stopInfo'
    
  constructor: ->
    super
    # initialize twitters slideshow
#    @el.toggleSlideshow()
    Album.bind('sortupdate', @proxy @sortupdate)
    GalleriesAlbum.bind('destroy', @proxy @sortupdate)
    Photo.bind('refresh', @proxy @refreshBackgrounds)
    AlbumsPhoto.bind('beforeDestroy beforeCreate', @proxy @clearAlbumCache)
    AlbumsPhoto.bind('beforeDestroy', @proxy @widowedAlbumsPhoto)
    AlbumsPhoto.bind('destroy create', @proxy @changeBackgrounds)
    Album.bind("ajaxError", Album.errorHandler)
    Spine.bind('album:activate', @proxy @activate)
    Spine.bind('zoom:album', @proxy @zoom)
    
  template: -> arguments[0]
  
  albumPhotosTemplate: (items) ->
    $('#albumPhotosTemplate').tmpl items
  
  change: (items) ->
    @renderBackgrounds items
  
  select: (item, lonely) ->
    item?.addRemoveSelection(lonely)
    @activate()
    
  exposeSelection: ->
    list = Gallery.selectionList()
    @deselect()
    for id in list
      if Album.exists(id)
        item = Album.find(id)
        el = @children().forItem(item)
        el.addClass("active")
        
    Spine.trigger('expose:sublistSelection', Gallery.record)
  
  activate: ->
    console.log 'AlbumsList::activate'
    selection = Gallery.selectionList()
    if selection.length is 1
      first = Album.find(selection[0]) if Album.exists(selection[0])
      unless first?.destroyed
        Album.current(first)
    else
        Album.current()
        
    App.showView.trigger('change:toolbarOne')
    @exposeSelection()
  
  render: (items, mode) ->
    console.log 'AlbumsList::render'
    @el.toggleClass('all', !Gallery.record)
      
    if items.length
      @html @template items
    else
      if Album.count()
        @html '<label class="invite"><span class="enlightened">This Gallery has no albums. &nbsp;<button class="optCreateAlbum dark large">New Album</button><button class="optShowAllAlbums dark large">Show existing Albums</button></span></label>'
      else
        @html '<label class="invite"><span class="enlightened">Time to create a new album. &nbsp;<button class="optCreateAlbum dark large">New Album</button></span></label>'
        
    @change items, mode
    @el
    
  clearAlbumCache: (record) ->
    id = record?.album_id or record?.id
    Album.clearCache id
    
  refreshBackgrounds: (alb) ->
    album = App.upload.album || alb
    @renderBackgrounds [album] #if album
  
  changeBackgrounds: (ap, mode) ->
    console.log 'AlbumsList::changeBackgrounds'
    albums = ap.albums()
    @renderBackgrounds albums
  
  # remember the AlbumPhoto before it gets deleted (needed to remove widowed photo thumbnails)
  widowedAlbumsPhoto: (ap) ->
    @widows = ap.albums()
  
  renderBackgrounds: (albums) ->
    return unless App.ready

    if albums.length
      for album in albums
        @processAlbum album
    else if @widows?.length
      @processAlbum album for album in @widows
      @widows = []
  
  processAlbum: (album) ->
    return unless album.constructor.className is 'Album'
    data = album.photos(4)
      
    Photo.uri
      width: 50
      height: 50,
      (xhr, rec) => @callback(xhr, album),
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
  
  create: ->
    Spine.trigger('create:album')

  click: (e) ->
    console.log 'AlbumsList::click'
    item = $(e.currentTarget).item()
    
    @select(item, @isCtrlClick(e))
    
    e.stopPropagation()
    e.preventDefault()

  zoom: (e) ->
    item = $(e?.currentTarget).item() || Album.record
    return unless item?.constructor?.className is 'Album'
    @select(item, true)
    
    @navigate '/gallery/' + Gallery.record.id + '/' + item.id
    
    e?.stopPropagation()
    e?.preventDefault()
  
  deleteAlbum: (e) ->
    item = $(e.currentTarget).item()
    return unless item?.constructor?.className is 'Album'
    Gallery.updateSelection item.id
    
    el = $(e.currentTarget).parents('.item')
    el.removeClass('in')
    
    window.setTimeout( ->
      Spine.trigger('destroy:album')
    , 300)
    
    @stopInfo()
    
    e.stopPropagation()
    e.preventDefault()
    
  sortupdate: (e, item) ->
    @children().each (index) ->
      item = $(@).item()
#      console.log item
      if item and Gallery.record
        ga = GalleriesAlbum.filter(item.id, func: 'selectAlbum')[0]
        if ga and ga.order isnt index
          ga.order = index
          ga.save()
      else if item
        album = (Album.filter(item.id, func: 'selectAlbum'))[0]
        album.order = index
        album.save()
        
    @exposeSelection()
    
  infoUp: (e) =>
    @info.up(e)
    el = $('.icon-set' , $(e.currentTarget)).addClass('in').removeClass('out')
    e.preventDefault()
    
  infoBye: (e) =>
    @info.bye()
    el = $('.icon-set' , $(e.currentTarget)).addClass('out').removeClass('in')
    e.preventDefault()
    
  stopInfo: (e) =>
    @info.bye()
    
  infoEnter: (e) ->
#    el = $(e.target).find('.more-icon')
#    el.addClass('infast')
    
  infoMove: (e) ->
#    return unless $(e.target).hasClass('items')
#    el = $(e.target).find('.more-icon')
#    el.removeClass('in')

module?.exports = AlbumsList