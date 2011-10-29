Spine ?= require("spine")
$      = Spine.$

class AlbumList extends Spine.Controller
  
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
    Spine.bind('exposeSelection', @proxy @exposeSelection)
    
  template: -> arguments[0]
  
  change: ->
    console.log 'AlbumList::change'
    
    list = Gallery.selectionList()
    
    @children().removeClass("active")
    if list
      @exposeSelection(list)
        
      # highlight first element in list
      selected = Album.find(list[0]) if Album.exists(list[0])
      if selected and !selected.destroyed
        Album.current(selected)
    
    Spine.trigger('change:selectedAlbum', selected)
    App.showView.trigger('change:toolbar', 'Album')
  
  exposeSelection: (list) ->
    for id in list
      if Album.exists(id)
        item = Album.find(id) 
        @children().forItem(item).addClass("active")
  
  render: (items, newAlbum) ->
    console.log 'AlbumList::render'
    if items.length
      @html @template items
    else
      if Album.count() == 0
        @html '<label class="invite"><span class="enlightened">Time to create a new album. &nbsp;</span></label><div class="invite"><button class="optCreateAlbum dark invite">New Album</button></div>'
      else if Album.count()
        @html '<label class="invite"><span class="enlightened">This Gallery has no albums. &nbsp;</span><div class="invite"><button class="optCreateAlbum dark invite">New Album</button><button class="optShowAllAlbums dark invite">Show available Albums</button></div>'
      else
        @html '<label class="invite"><span class="enlightened">This Gallery has no albums. &nbsp;</span><button class="optCreateAlbum dark invite">New Album</button></label>'
    
    @change()
    @el
  
  children: (sel) ->
    @el.children(sel)

  create: ->
    Spine.trigger('create:album')

  click: (e) ->
    console.log 'AlbumList::click'
    item = $(e.target).item()
    
    if App.hmanager.hasActive()
      @openPanel('album', App.showView.btnAlbum)
    
    item.addRemoveSelection(Gallery, @isCtrlClick(e))
    list = Gallery.selectionList()
    @change item 

  dblclick: (e) ->
    @openPanel('album', App.showView.btnAlbum)
  
  edit: (e) ->
    console.log 'AlbumList::edit'
    item = $(e.target).item()
    @change item

module?.exports = AlbumList