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
    Photo.bind('update', @proxy @update)
    Photo.bind("ajaxError", Photo.customErrorHandler)
    Photo.bind('uri', @proxy @uri)
    
  change: (item) ->
    @children().removeClass("active")
    @exposeSelection()
    Spine.trigger('change:selectedPhoto', item)
  
  render: (items, album, mode) ->
    console.log 'PhotoList::render'
    mode?= 'html'
    album?= Album.record
    
    if album
      if items.length
        @[mode] @template items
        @uri album, items, mode
        @change()
        @el
      else
        @html '<label class="invite"><span class="enlightened">This album has no images.</span></label>'
    else
      @html '<label class="invite"><span class="enlightened">No album selected.</span></label>'
  
  renderItem: (item) ->
    el = =>
      @children().forItem(item)
    tb = ->
      $('.thumbnail', el())
      
    backgroundImage = tb().css('backgroundImage')
    isActive = el().hasClass('active')
    tmplItem = el().tmplItem()
    tmplItem.tmpl = $( "#photosTemplate" ).template()
    tmplItem.update()
    tb().css('backgroundImage', backgroundImage)
    el().toggleClass('active', isActive)
  
  update: (item) ->
    @renderItem item
  
  previewSize: (width = 140, height = 140) ->
    width: width
    height: height
  
  uri: (album, items, mode) ->
    console.log 'PhotoList::uri'
    album.uri @previewSize(), mode, (xhr, record) => @callback items, xhr
  
  callback: (items, json) =>
    console.log 'PhotoList::callback'
    searchJSON = (id) ->
      for itm in json
        return itm[id] if itm[id]
    for item in items
      jsn = searchJSON item.id
      if jsn
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
    
  exposeSelection: ->
    console.log 'PhotoList::exposeSelection'
    list = Album.selectionList()
    for id in list
      if Photo.exists(id)
        item = Photo.find(id) 
        @children().forItem(item).addClass("active")
    current = if list.length is 1 then list[0] 
    Photo.current(current)
  
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