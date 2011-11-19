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
    if album
      if items.length
        @html @template items
        @uri album, items
        @change()
        @el
      else
        @html '<label class="invite"><span class="enlightened">This album has no images.</span></label>'
    else
      @html '<label class="invite"><span class="enlightened">No album selected.</span></label>'
  
  previewSize: (width = 140, height = 140) ->
    width: width
    height: height
  
  uri: (album, items) ->
    console.log 'PhotoList::uri'
    album.uri @previewSize(), (xhr, record) => @callback items, xhr
  
  callback: (items, json) =>
    console.log 'PhotoList::callback'
    searchJSON = (id) ->
      for itm in json
        return itm[id] if itm[id]
    for item in items
      jsn = searchJSON item.id
      ele = @children().forItem(item)
      src = jsn.src
      img = new Image
      img.element = ele
      img.src = src
      img.onload = @imageLoad
    
  imageLoad: ->
    css = 'url(' + @src + ')'
    $('.thumbnail', @element).css
      'backgroundImage': css
      'backgroundPosition': 'center, center'
    
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