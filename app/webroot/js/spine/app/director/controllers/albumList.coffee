Spine ?= require("spine")
$      = Spine.$

class Spine.AlbumList extends Spine.Controller

  events:
    "click .item"      : "click"
    "dblclick .item"   : "dblclick"
    
  selectFirst: true
    
  constructor: ->
    super
    @bind("change", @change)
    #Album.bind("change", @proxy @change)
    #Gallery.bind("change", @proxy @change)
    
  template: -> arguments[0]
  
  change: (item, mode) =>
    console.log 'AlbumList::change'
    album = @selectedAlbum(item?.id)
    if album and !album.destroyed
      
      @current = album
      @children().removeClass("active")
      @children().forItem(@current).addClass("active")
      
      Spine.App.trigger('change:album', @current, mode)
  
  render: (items) ->
    console.log 'AlbumList::render'
    @items = items if items
    @html @template(@items)
    @change()
    @
      
  selectedAlbum: (id) ->
    gal = Gallery.selected()
    albumid = id or gal.selectedAlbumId
    return unless albumid
    alb = Album.find(albumid)
    try
      Gallery.record.updateAttribute('selectedAlbumId', albumid, {silent:true})
    catch e
      alert 'You must select a Gallery first!'
      return
    alb

  children: (sel) ->
    @el.children(sel)
    
  click: (e) ->
    item = $(e.target).item()
    console.log 'AlbumList::click'
    
    if App.hmanager.hasActive()
      @dblclick()

    @change item
    
  dblclick: ->
    App.album.deactivate()
    App.albums.albumBtn.click()

  edit: (e) ->
    console.log 'AlbumList::edit'
    item = $(e.target).item()
    @change item, 'edit'

module?.exports = Spine.AlbumList