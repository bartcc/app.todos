Spine ?= require("spine")
$      = Spine.$

class PhotoList extends Spine.Controller
  

  events:
    'click .item'             : "click"    
    'dblclick .item'          : 'dblclick'
    
  selectFirst: true
    
  constructor: ->
    super
    Spine.bind('photo:exposeSelection', @proxy @exposeSelection)
    Photo.bind('uri', @proxy @develop)
    
  template: -> arguments[0]
  
  render: (items) ->
    console.log 'PhotoList::render'
    console.log items
    @items = items
    Photo.develop items
  
  change: (item) ->
    list = Album.selectionList()
    @children().removeClass("active")
    @exposeSelection(list)
#    App.showView.trigger('change:toolbar', 'Photo')
    
  exposeSelection: (list) ->
    console.log 'PhotoList::exposeSelection'
    for id in list
      if Photo.exists(id)
        item = Photo.find(id) 
        @children().forItem(item).addClass("active")
  
  children: (sel) ->
    @el.children(sel)
  
  click: (e) ->
    console.log 'PhotoList::click'
    item = $(e.currentTarget).item()
    item.addRemoveSelection(Album, @isCtrlClick(e))
    
    if App.hmanager.hasActive()
      @openPanel('photo', App.showView.btnPhoto)
      
    @change item
    
    e.stopPropagation()
    e.preventDefault()
    false
  
  dblclick: (e) ->
    console.log 'PhotoList::dblclick'
    #@openPanel('album', App.showView.btnAlbum)
    item = $(e.currentTarget).item()
    
    @change item
    Spine.trigger('show:photo', item)
    
    e.stopPropagation()
    e.preventDefault()
    false
    
  develop: (json) ->
#    alert('Error: ' + json.length + ' / ' + @items.length) if json.length != @items.length
    for src in @items
      @items[_i]?.src = json[_i]
      
    @html @template @items
    @change()
    @el
    
module?.exports = PhotoList