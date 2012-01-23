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
    Photo.bind('sortupdate', @proxy @sortupdate)
    Spine.bind('photo:activate', @proxy @activate)
    Photo.bind('update', @proxy @update)
    Photo.bind("ajaxError", Photo.errorHandler)
    Album.bind("ajaxError", Album.errorHandler)
    Photo.bind('uri', @proxy @uri)
    
  change: ->
    console.log 'PhotosList::change'
    
  select: (item, e) ->
    console.log 'PhotosList::select'
    @current = item
    Photo.current(item)
    @activate()
#    Spine.trigger('change:selectedPhoto', item)
  
  render: (items, mode='html') ->
    console.log 'PhotosList::render'
    if Album.record
      if items.length
        @[mode] @template items
        @exposeSelection() unless mode is 'append'
        @uri items, mode
      else
        @html '<label class="invite"><span class="enlightened">This album has no images.</span></label>'
    else
      @renderAll()
    @el
  
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
    
  activate: ->
    @exposeSelection()
    
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
  
  activate: ->
  
    selection = Album.selectionList()
    if selection.length is 1
      first = Photo.find(selection[0]) if Photo.exists(selection[0])

      if !first?.destroyed
        @current = first
        Photo.current(first)
    else
        Photo.current()
    
    @exposeSelection()
  
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
  
  sortupdate: (e, item) ->
    @children().each (index) ->
      item = $(@).item()
      if Album.record
        ap = (AlbumsPhoto.filter(item.id, func: 'selectPhoto'))[0]
        unless (ap?.order) is index
          ap.order = index
          ap.save()
#      else
#        photo = (Photo.filter(item.id, func: 'selectPhoto'))[0]
#        photo.order = index
#        photo.save()
  
  closeInfo: (e) =>
    @el.click()
    e.stopPropagation()
    e.preventDefault()
    
  initSelectable: ->
    options =
      helper: 'clone'
    @el.selectable()
    
  infoUp: (e) =>
    @info.up(e)
    e.preventDefault()
    
  infoBye: (e) =>
    @info.bye()
    e.preventDefault()
    
  stopInfo: (e) =>
    @info.bye()
    
  sliderStart: =>
    @refreshElements()
    
  size: (val, bg='none') =>
    # 2*10 = border radius
    @thumb.css
      'height'          : val+'px'
      'width'           : val+'px'
      'backgroundSize'  : bg
    
module?.exports = PhotosList