Spine ?= require("spine")
$      = Spine.$

class AlbumList extends Spine.Controller
  
  events:
    'click .item'             : "click"    
    'dblclick .item'          : 'dblclick'
    
  selectFirst: true
    
  constructor: ->
    super
    Spine.bind('album:exposeSelection', @proxy @exposeSelection)
    
  template: -> arguments[0]
  
  albumPhotosTemplate: (items) ->
    $('#albumPhotosTemplate').tmpl items
  
  change: (items) ->
    console.log 'AlbumList::change'
    @renderBackgrounds items if items.length
  
  select: (item) ->
    @exposeSelection()
    if item and !item.destroyed
      Album.current(item)
      
    Spine.trigger('change:selectedAlbum', item)
    
  exposeSelection: ->
    list = Gallery.selectionList()
    @children().removeClass("active")
    for id in list
      if Album.exists(id)
        item = Album.find(id) 
        @children().forItem(item).addClass("active")
    current = if list.length is 1 then list[0]
    Album.current(current)
        
    Spine.trigger('expose:sublistSelection', Gallery.record) if Gallery.record
  
  render: (items) ->
    console.log 'AlbumList::render'
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
    console.log 'AlbumList::renderBackgrounds'
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
    console.log 'AlbumList::callback'
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
    console.log 'AlbumList::click'
    item = $(e.target).item()
    
    # open Album panel if any panel is open
#    if App.hmanager.hasActive()
#      @openPanel('album', App.showView.btnAlbum)
    
    item.addRemoveSelection(Gallery, @isCtrlClick(e))
    @select item
    App.showView.trigger('change:toolbar', 'Album')
    
    e.stopPropagation()
    e.preventDefault()
    false

  dblclick: (e) ->
    #@openPanel('album', App.showView.btnAlbum)
    item = $(e.currentTarget).item()
    Spine.trigger('show:photos', item)
    
    e.stopPropagation()
    e.preventDefault()
    false
  
  edit: (e) ->
    console.log 'AlbumList::edit'
    item = $(e.target).item()
    @change item

module?.exports = AlbumList