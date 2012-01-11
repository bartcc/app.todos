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
    Spine.bind('album:activate', @proxy @activate)
    
  template: -> arguments[0]
  
  albumPhotosTemplate: (items) ->
    $('#albumPhotosTemplate').tmpl items
  
  change: (items) ->
    console.log 'AlbumsList::change'
    @renderBackgrounds items if items.length
  
  select: (item, e) ->
    console.log 'AlbumsList::select'
    
#    @exposeSelection()
    @activate()
    
  exposeSelection: ->
    console.log 'AlbumsList::exposeSelection'
    list = Gallery.selectionList()
    @deselect()
    for id in list
      if Album.exists(id)
        item = Album.find(id)
        el = @children().forItem(item)
        el.addClass("active")
        
    Spine.trigger('expose:sublistSelection', Gallery.record)
  
  activate: (album) ->
  
    alb = Album.record
    gal = Gallery.record
    
    selection = Gallery.selectionList()
    if selection.length is 1
      newActive = Album.find(selection[0]) if Album.exists(selection[0])

      if !newActive?.destroyed
        @current = newActive
        Album.current(newActive)
    else
        Album.current()
    
    sameAlbum = Album.record?.eql?(alb) and !!alb
    
    Spine.trigger('change:selectedAlbum', Album.record) unless sameAlbum
    Spine.trigger('change:selectedPhoto', Photo.record)
    @exposeSelection()
  
  render: (items) ->
    console.log 'AlbumsList::render'
    if items.length
      @html @template items
    else
      if Album.count()
        @html '<div class="invite"><span class="enlightened invite">This Gallery has no albums. &nbsp;<button class="optCreateAlbum dark invite">New Album</button><button class="optShowAllAlbums dark invite">Show available Albums</button></span></div>'
      else
        @html '<div class="invite"><span class="enlightened invite">Time to create a new album. &nbsp;<button class="optCreateAlbum dark invite">New Album</button></span></div>'
        
    @change items
    @el
  
  renderBackgrounds: (albums) ->
    console.log 'AlbumsList::renderBackgrounds'
    return unless App.ready
    for album in albums
      album.uri
        width: 50
        height: 50
        , 'html'
        , (xhr, album) =>
          @callback(xhr, album)
        , 3
  
  callback: (json, item) =>
    console.log 'AlbumsList::callback'
    el = @children().forItem(item)
    searchJSON = (itm) ->
      res = for key, value of itm
        value
    css = for itm in json
      o = searchJSON itm
      'url(' + o[0].src + ')'
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