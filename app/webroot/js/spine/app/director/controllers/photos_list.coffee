Spine ?= require("spine")
$      = Spine.$

class PhotosList extends Spine.Controller
  
  elements:
    '.thumbnail'              : 'thumb'
    
  events:
    'click .item'             : "click"
    'dblclick .item'          : 'dblclick'
    'mousemove .item'         : 'infoUp'
    'mouseleave  .item'       : 'infoBye'
    'dragstart .item'         : 'stopInfo'
  
  selectFirst: true
    
  constructor: ->
    super
    Spine.bind('photo:exposeSelection', @proxy @exposeSelection)
    Photo.bind('update', @proxy @update)
    Photo.bind("ajaxError", Photo.customErrorHandler)
    Photo.bind('uri', @proxy @uri)
#    @initSelectable()
    
  change: ->
    console.log 'PhotosList::change'
    
  select: (item, e) ->
    console.log 'PhotosList::select'
    @exposeSelection()
    @current = item
    Spine.trigger('change:selectedPhoto', item)
  
  render: (items, mode='html') ->
    console.log 'PhotosList::render'
    if Album.record
      if items.length
        @[mode] @template items
        @exposeSelection() unless mode is 'append'
        @uri items, mode
        @el
      else
        @html '<label class="invite"><span class="enlightened">This album has no images.</span></label>'
    else
      @renderAll()
  
  renderAll: ->
    console.log 'PhotosList::renderAll'
    items = Photo.all()
    if items.length
      @html @template items
      @exposeSelection()
      @uri items, 'html'
      @el
  
  update: (item) ->
    console.log 'PhotosList::update'
    el = =>
      @children().forItem(item)
    tb = ->
      $('.thumbnail', el())
      
    backgroundImage = tb().css('backgroundImage')
    css = tb().attr('style')
    active = el().hasClass('active')
    tmplItem = el().tmplItem()
    tmplItem.tmpl = $( "#photosTemplate" ).template()
    tmplItem.update()
    tb().attr('style', css)
    el().toggleClass('active', active)
    @refreshElements()
  
  thumbSize: (width = @parent.thumbSize, height = @parent.thumbSize) ->
    width: width
    height: height
  
  # the actual final rendering method
  uri: (items, mode) ->
    console.log 'PhotosList::uri'
    @size(@parent.sOutValue)
    
    if Album.record
      Album.record.uri @thumbSize(), mode, (xhr, record) => @callback items, xhr
    else
      Photo.uri @thumbSize(), mode, (xhr, record) => @callback items, xhr
  
  callback: (items, json) =>
    console.log 'PhotosList::callback'
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
      'backgroundSize': '100%'
    
  exposeSelection: ->
    console.log 'PhotosList::exposeSelection'
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
    console.log 'PhotosList::click'
    item = $(e.currentTarget).item()
    item.addRemoveSelection(@isCtrlClick(e))
    
#    if App.hmanager.hasActive()
#      @openPanel('photo', App.showView.btnPhoto)
    
    Spine.trigger('change:toolbarOne', ['Photos'], App.showView.initSlider)
    @select item, e
    
    e.stopPropagation()
    e.preventDefault()
    false
  
  dblclick: (e) ->
    console.log 'PhotosList::dblclick'
    Spine.trigger('show:photo', @current)
    
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
    
  infoUp: (e) =>
    e.stopPropagation()
    e.preventDefault()
    @info.up(e)
    false
    
  infoBye: (e) =>
    e.stopPropagation()
    e.preventDefault()
    @info.bye()
    false
    
  stopInfo: (e) =>
    @info.bye()
    
  sliderStart: =>
    
  size: (val, bg='none') =>
    # 2*10 = border radius
    @thumb.css
      'height'          : val+'px'
      'width'           : val+'px'
      'backgroundSize'  : bg
    
module?.exports = PhotosList