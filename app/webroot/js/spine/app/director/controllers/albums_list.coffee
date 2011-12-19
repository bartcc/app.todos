Spine ?= require("spine")
$      = Spine.$

class AlbumsList extends Spine.Controller
  
  events:
    'click .item'                   : "click"    
    'dblclick .item'                : 'dblclick'
    'mousemove .item .thumbnail'    : 'previewUp'
    'mouseleave .item .thumbnail'   : 'previewBye'
    'dragstart .item .thumbnail'    : 'stopPreview'
    
  constructor: ->
    super
    Spine.bind('album:exposeSelection', @proxy @exposeSelection)
    
  template: -> arguments[0]
  
  albumPhotosTemplate: (items) ->
    $('#albumPhotosTemplate').tmpl items
  
  change: (items) ->
    console.log 'AlbumsList::change'
    @renderBackgrounds items if items.length
  
  select: (item, e) ->
    console.log 'AlbumsList::select'
    previous = Album.record
    if item and !item.destroyed
      @current = item
      Album.current(item)
    
    @exposeSelection()
    Spine.trigger('change:selectedAlbum', item, Album.changed())
#    Spine.trigger('change:selectedAlbum', item, (!previous or !(@current?.id is previous.id)))
    
  exposeSelection: ->
    console.log 'AlbumsList::exposeSelection'
    list = Gallery.selectionList()
    @deselect()
    for id in list
      if Album.exists(id)
        item = Album.find(id)
        el = @children().forItem(item)
        el.addClass("active")
#    current = if list.length is 1 then list[0]
#    Album.current(current)
        
    Spine.trigger('expose:sublistSelection', Gallery.record)# if Gallery.record
  
  render: (items) ->
    console.log 'AlbumsList::render'
    if items.length
      @html @template items
    else
      if Album.count()
        @html '<label class="invite"><span class="enlightened">This Gallery has no albums. &nbsp;</span></label><div class="invite"><button class="optCreateAlbum dark invite">New Album</button><button class="optShowAllAlbums dark invite">Show available Albums</button></div>'
      else
        @html '<label class="invite"><span class="enlightened">Time to create a new album. &nbsp;</span></label><div class="invite"><button class="optCreateAlbum dark invite">New Album</button></div>'
        
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
    item = $(e.target).item()
    item.addRemoveSelection(@isCtrlClick(e))
    
    @select item, e
    App.showView.trigger('change:toolbar', 'Album')
    
    e.stopPropagation()
    e.preventDefault()
    false

  dblclick: (e) ->
    #@openPanel('album', App.showView.btnAlbum)
    
    App.showView.trigger('change:toolbar', 'Photos')
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
    false
    
    
  previewUp: (e) =>
    e.stopPropagation()
    e.preventDefault()
    @preview.up(e)
    false
    
  previewBye: (e) =>
    e.stopPropagation()
    e.preventDefault()
    @preview.bye()
    false

  stopPreview: (e) =>
    @preview.bye()
  
module?.exports = AlbumsList