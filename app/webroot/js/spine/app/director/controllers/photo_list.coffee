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
    Photo.bind("ajaxError", Photo.customErrorHandler)
    Photo.bind('uri', @proxy @uri)
    
  render: (items, album) ->
    console.log 'PhotoList::render'
    if items.length and album
      album.uri
        width:140
        height:140
        , (xhr, album) => @callback items, xhr
    else
      @html '<label class="invite"><span class="enlightened">This album has no images.</span></label>'
  
  callback: (items, json) ->
    console.log 'PhotoList::uri'
    for src in items
      items[_i]?.src = json[_i]
      
    @html @template items
    @change()
    @el
    
  change: (item) ->
    list = Album.selectionList()
    @children().removeClass("active")
    @exposeSelection(list)
  
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
    
    App.showView.trigger('change:toolbar', 'Photo')
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
  
    
module?.exports = PhotoList