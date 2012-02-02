Spine ?= require("spine")
$      = Spine.$

class AlbumsList extends Spine.Controller
  
  events:
    'click .item'                   : "click"    
    'dblclick .item'                : 'dblclick'
    'mousemove .item .thumbnail'    : 'infoUp'
    'mouseleave .item .thumbnail'   : 'infoBye'
    'dragstart .item .thumbnail'    : 'infoBye'
    
  constructor: ->
    super
    Photo.bind('refresh', @proxy @refreshBackgrounds)
    AlbumsPhoto.bind('beforeDestroy', @proxy @deleteBackgrounds)
#    AlbumsPhoto.bind('create', @proxy @addBackgrounds)
    AlbumsPhoto.bind('change', @proxy @changeBackgrounds)
    Album.bind('sortupdate', @proxy @sortupdate)
    Album.bind("ajaxError", Album.errorHandler)
    Spine.bind('album:activate', @proxy @activate)
    
  template: -> arguments[0]
  
  albumPhotosTemplate: (items) ->
    $('#albumPhotosTemplate').tmpl items
  
  change: (items) ->
    @renderBackgrounds items# if items.length
  
  select: (item, e) ->
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
  
    selection = Gallery.selectionList()
    if selection.length is 1
      first = Album.find(selection[0]) if Album.exists(selection[0])

      if !first?.destroyed
        @current = first
        Album.current(first)
    else
        Album.current()
    
    @exposeSelection()
  
  render: (items, mode) ->
    console.log 'AlbumsList::render'
    if items.length
      @html @template items
    else
      if Album.count()
        @html '<div class="invite"><span class="enlightened invite">This Gallery has no albums. &nbsp;<button class="optCreateAlbum dark invite">New Album</button><button class="optShowAllAlbums dark invite">Show available Albums</button></span></div>'
      else
        @html '<div class="invite"><span class="enlightened invite">Time to create a new album. &nbsp;<button class="optCreateAlbum dark invite">New Album</button></span></div>'
        
    @change items, mode
    @el
    
  refreshBackgrounds: (photos) ->
    uploadAlbum = App.upload.album
    @renderBackgrounds [uploadAlbum] if uploadAlbum
  
  changeBackgrounds: (ap, mode) ->
    console.log 'AlbumsList::changeBackgrounds'
    albums = ap.albums()
    @renderBackgrounds albums, mode
  
  deleteBackgrounds: (ap) ->
    @savedAlbums = ap.albums()
  
  renderBackgrounds: (albums, mode) ->
    return unless App.ready
    console.log 'AlbumsList::renderBackgrounds'

    if albums.length
      @processAlbum album for album in albums
    else if @savedAlbums?.length
      @processAlbum album for album in @savedAlbums
  
  processAlbum: (album) ->
    album.uri
      width: 50
      height: 50
      , 'append'
      , (xhr, album) =>
        @callback(xhr, album)
      , 4
  
  callback: (json, item) =>
    el = @children().forItem(item)
    searchJSON = (itm) ->
      for key, value of itm
        value
    css = for itm in json
      arr = searchJSON itm
      'url(' + arr[0].src + ')'
    el.css('backgroundImage', css)
  
  create: ->
    Spine.trigger('create:album')

  click: (e) ->
    console.log 'AlbumsList::click'
    item = $(e.currentTarget).item()
    
    list = item.addRemoveSelection(@isCtrlClick(e))
    
    @select item, e
    Spine.trigger('change:toolbarOne', ['Album'])
    
    e.stopPropagation()
    e.preventDefault()

  dblclick: (e) ->
    #@openPanel('album', App.showView.btnAlbum)
      
    Spine.trigger('change:toolbarOne', ['Photos'], App.showView.initSlider)
    Spine.trigger('show:photos')
    
    e.stopPropagation()
    e.preventDefault()
    false
  
  edit: (e) ->
    console.log 'AlbumsList::edit'
    item = $(e.target).item()
    @change item
    
  sortupdate: (e, item) ->
    @children().each (index) ->
      item = $(@).item()
      if item
        if Gallery.record
          ga = (GalleriesAlbum.filter(item.id, func: 'selectAlbum'))[0]
          unless (ga?.order) is index
            ga.order = index
            ga.save()
        else
          album = (Album.filter(item.id, func: 'selectAlbum'))[0]
          album.order = index
          album.save()
    
  closeInfo: (e) =>
    @el.click()
    e.stopPropagation()
    e.preventDefault()
    
  infoUp: (e) =>
    e.stopPropagation()
    e.preventDefault()
    @info.up(e)
    
  infoBye: (e) =>
    @info.bye()

module?.exports = AlbumsList