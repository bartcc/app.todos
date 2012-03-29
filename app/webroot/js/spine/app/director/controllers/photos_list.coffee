Spine ?= require("spine")
$      = Spine.$

class PhotosList extends Spine.Controller
  
  elements:
    '.thumbnail'              : 'thumb'
    
  events:
    'click .item'             : 'click'
    'click .more-icon.delete' : 'deletePhoto'
    'dblclick .item'          : 'dblclick'
    
    'mouseenter .item'        : 'infoEnter'
    'mousemove'               : 'infoMove'
    
    'mousemove .item'         : 'infoUp'
    'mouseleave  .item'       : 'infoBye'
    
    'dragstart .item'         : 'stopInfo'
    
  selectFirst: true
    
  constructor: ->
    super
    Photo.bind('sortupdate', @proxy @sortupdate)
#    AlbumsPhoto.bind('destroy', @proxy @sortupdate)
    Spine.bind('photo:activate', @proxy @activate)
    Spine.bind('slider:start', @proxy @sliderStart)
    Spine.bind('slider:change', @proxy @size)
    Photo.bind('update', @proxy @update)
    Photo.bind("ajaxError", Photo.errorHandler)
    Album.bind("ajaxError", Album.errorHandler)
    Photo.bind('uri', @proxy @uri)
    
  change: ->
    console.log 'PhotosList::change'
    
  select: (item, e) ->
    console.log 'PhotosList::select'
    @current = Photo.current(item)
    @exposeSelection()
#    @activate()
  
  render: (items, mode='html') ->
    console.log 'PhotosList::render'
    if Album.record
      @el.removeClass 'all'
      if items.length
        @[mode] @template items
        @exposeSelection() unless mode is 'append'
        @uri items, mode
      else
        @html '<label class="invite"><span class="enlightened">This album has no images.</span></label>'
    else
      @el.addClass 'all'
      @renderAll()
    
    @elIn = $('.more-icon', @el)
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
    @loadModal items
    
  imageLoad: ->
    css = 'url(' + @src + ')'
    $('.thumbnail', @element).css
      'backgroundImage': css
      'backgroundPosition': 'center, center'
      'backgroundSize': '100%'
    
    
  #  ****** START ***** for the slideshow
  
  modalParams: ->
    width: 600
    height: 451
    square: 2
    force: false
    
  loadModal: (items, mode='html') ->
    return unless Album.record
    Album.record.uri @modalParams(), mode, (xhr, record) => @callbackModal items, xhr
  
  callbackModal: (items, json) ->
    console.log 'Slideshow::callbackModal'
    searchJSON = (id) ->
      for itm in json
        return itm[id] if itm[id]
    for item in items
      jsn = searchJSON item.id
      if jsn
        el = @children().forItem(item)
        a = $('<a></a>').attr
          'data-href'  : jsn.src
          'title' : item.title or item.src
          'rel'   : 'gallery'
        $('.play', el).append a
        
    @play() unless @parent.silent
    
  play: ->
    el = @children('li:first')
    $('a', el).click()
    @parent.silent = true
    
  playSlideshow: (e) ->
    el = $(e.target).closest('li.item')
    console.log $('.play a', el)
#    @play(el)
    $('.play a', el).click()
    e.preventDefault()
    e.stopPropagation()
    false
    
  #  ****** END ***** 
  
  exposeSelection: ->
    console.log 'PhotosList::exposeSelection'
    @deselect()
    list = Album.selectionList()
    for id in list
      if Photo.exists(id)
        item = Photo.find(id) 
        @children().forItem(item).addClass("active")
#    current = if list.length is 1 then list[0] 
#    Photo.current(current)
    @activate()
  
  activate: ->
    selection = Album.selectionList()
    if selection.length is 1
      first = Photo.find(selection[0]) if Photo.exists(selection[0])

      if !first?.destroyed
        @current = first
        Photo.current(first)
    else
        Photo.current()
    
  click: (e) ->
    console.log 'PhotosList::click'
    item = $(e.currentTarget).item()
    item.addRemoveSelection(@isCtrlClick(e))
    
#    if App.hmanager.hasActive()
#      @openPanel('photo', App.showView.btnPhoto)
    
    Spine.trigger('change:toolbarOne')
    @select item, e
    e.stopPropagation() if $(e.target).hasClass('thumbnail')
#    false
  
  dblclick: (e) ->
    console.log 'PhotosList::dblclick'
    Spine.trigger('show:photo', @current)
    @exposeSelection()
    e.stopPropagation()
    e.preventDefault()
  
  deletePhoto: (e) ->
    item = $(e.target).closest('.item').item()
    Album.updateSelection item.id
    Spine.trigger('destroy:photo')
    @stopInfo()
    false
    
  sortupdate: ->
    @children().each (index) ->
      item = $(@).item()
#      console.log AlbumsPhoto.filter(item.id, func: 'selectPhoto').length
      if item and Album.record
        ap = AlbumsPhoto.filter(item.id, func: 'selectPhoto')[0]
        if ap and ap.order isnt index
          ap.order = index
          ap.save()
      else if item
        photo = (Photo.filter(item.id, func: 'selectPhoto'))[0]
        photo.order = index
        photo.save()
        
    @exposeSelection()
    
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
    
  infoEnter: (e) ->
    el = $(e.target).find('.more-icon')
    el.addClass('in')
    
  infoMove: (e) ->
    return unless $(e.target).hasClass('items')
    el = $(e.target).find('.more-icon')
    el.removeClass('in')
    
  sliderStart: =>
    @refreshElements()
    
  size: (val, bg='none') ->
    # 2*10 = border radius
    @thumb.css
      'height'          : val+'px'
      'width'           : val+'px'
      'backgroundSize'  : bg
    
module?.exports = PhotosList