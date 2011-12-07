Spine ?= require("spine")
$      = Spine.$

class PhotoList extends Spine.Controller
  
  elements:
    '.thumbnail'              : 'thumb'
    
  events:
    'click .close'            : "closeInfo"  
    'click .item'             : "click"    
    'dblclick .item'          : 'dblclick'
    'mousemove .item'         : 'previewUp'
    'mouseleave  .item'       : 'previewBye'
    'dragstart .item'         : 'stopPreview'
  
  selectFirst: true
    
  constructor: ->
    super
    Spine.bind('photo:exposeSelection', @proxy @exposeSelection)
    Photo.bind('update', @proxy @update)
    Photo.bind("ajaxError", Photo.customErrorHandler)
    Photo.bind('uri', @proxy @uri)
#    @initSelectable()
    
  change: (item, e) ->
    @exposeSelection(e)
    @current = item
    Spine.trigger('change:selectedPhoto', item)
  
  render: (items, mode='html') ->
    console.log 'PhotoList::render'
#    album?= Album.record
    if Album.record
      if items.length
        @[mode] @template items
        @exposeSelection()
        @uri items, mode
        @change()
        @el
      else
        @html '<label class="invite"><span class="enlightened">This album has no images.</span></label>'
    else
      @renderAll()
      # Album.record is unknown - render all existing photos
#      @html '<label class="invite"><span class="enlightened">Here all photos should be rendered</span></label>'
  
  renderAll: ->
    console.log 'PhotoList::renderAll'
    items = Photo.all()
    if items.length
      @html @template items
      @exposeSelection()
      @uri items, 'html'
      @change()
      @el
    
  
  update: (item) ->
    el = =>
      @children().forItem(item)
    tb = ->
      $('.thumbnail', el())
      
    backgroundImage = tb().css('backgroundImage')
    style = el().prop('style')
    isActive = el().hasClass('active')
    tmplItem = el().tmplItem()
    tmplItem.tmpl = $( "#photosTemplate" ).template()
    tmplItem.update()
    tb().css 'backgroundImage', backgroundImage
    el().toggleClass('active', isActive)
  
  previewSize: (width = 140, height = 140) ->
    width: width
    height: height
  
  # the actual final rendering method
  uri: (items, mode) ->
    console.log 'PhotoList::uri'
    if Album.record
      Album.record.uri @previewSize(), mode, (xhr, record) => @callback items, xhr
    else
      Photo.uri @previewSize(), mode, (xhr, record) => @callback items, xhr
  
    @size(@slider.sOutValue)
  
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
        img.onload = @imageLoad
        img.src = src
    
  imageLoad: ->
    css = 'url(' + @src + ')'
    $('.thumbnail', @element).css
      'backgroundImage': css
      'backgroundPosition': 'center, center'
    
  exposeSelection: (e) ->
    console.log 'PhotoList::exposeSelection'
    @deselect()
    list = Album.selectionList()
    for id in list
      if Photo.exists(id)
        item = Photo.find(id) 
        el = @children().forItem(item)
        el.addClass("active")
    current = if list.length is 1 then list[0] 
    Photo.current(current)
  
  click: (e) ->
    console.log 'PhotoList::click'
    item = $(e.currentTarget).item()
    item.addRemoveSelection(Album, @isCtrlClick(e))
    
    if App.hmanager.hasActive()
      @openPanel('photo', App.showView.btnPhoto)
    
    App.showView.trigger('change:toolbar', 'Photo')
    @change item, e
    
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
  
  closeInfo: (e) =>
    @el.click()
    e.stopPropagation()
    e.preventDefault()
    false
    
  initSelectable: ->
    options =
      helper: 'clone'
    @el.selectable()
    
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
    
  sliderStart: =>
    console.log @thumb.length
    
  size: (val) =>
    # 2+10 = border radius
    @thumb.css
      'height': val+'px'
      'width': val+'px'
      'backgroundSize': parseInt(val+20)+'px ' + parseInt(val+20)+'px'
    
module?.exports = PhotoList