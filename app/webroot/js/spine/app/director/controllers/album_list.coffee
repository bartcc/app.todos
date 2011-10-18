Spine ?= require("spine")
$      = Spine.$

class Spine.AlbumList extends Spine.Controller
  
  elements:
    '.optCreate'              : 'btnCreate'

  events:
    'click .item'             : "click"    
    'dblclick .item'          : 'dblclick'
    'click .optCreate'        : 'create'
    
  selectFirst: true
    
  constructor: ->
    super
    @record = Gallery.record
    
  template: -> arguments[0]
  
  change: ->
    console.log 'AlbumList::change'
    
    list = Gallery.selectionList()

    @children().removeClass("active")
    if list
      for id in list
        item = Album.find(id) if Album.exists(id)
        @children().forItem(item).addClass("active") if item
        
      selected = Album.find(list[0]) if Album.exists(list[0])
      if selected and !selected.destroyed
        Album.current(selected)

    Spine.trigger('change:selectedAlbum', selected)
  
  render: (items, newAlbum) ->
    console.log 'AlbumList::render'
    if items.length
      @html @template items
    else
      @html 'This Gallery has no Albums&nbsp;<button class="optCreateAlbum">New Album</button>'
    
    #Gallery.updateSelection([newAlbum.id]) if newAlbum and newAlbum instanceof Album
    @change()
    @el
  
  children: (sel) ->
    @el.children(sel)

  create: ->
    Spine.trigger('create:album')

  click: (e) ->
    console.log 'AlbumList::click'
    item = $(e.target).item()
    Spine.trigger('change:selection', item.constructor.className) unless @isCtrlClick(e)

    if App.hmanager.hasActive()
      @openPanel('album', App.albumsShowView.btnAlbum)
    
    item.addRemoveSelection(Gallery, @isCtrlClick(e))
    @change item 

  dblclick: (e) ->
    @openPanel('album', App.albumsShowView.btnAlbum)
  
  edit: (e) ->
    console.log 'AlbumList::edit'
    item = $(e.target).item()
    @change item

module?.exports = Spine.AlbumList