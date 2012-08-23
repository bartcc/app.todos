Spine ?= require("spine")
$      = Spine.$

class PhotosList extends Spine.Controller
  
  elements:
    '.thumbnail'              : 'thumb'
    
  events:
    'click .item'             : 'click'
    'click .icon-set .zoom'   : 'zoom'
    'click .icon-set .delete' : 'deletePhoto'
    
    'mouseenter .item'        : 'infoEnter'
    'mousemove'               : 'infoMove'
    
    'mousemove .item'         : 'infoUp'
    'mouseleave  .item'       : 'infoBye'
    
    'dragstart .item'         : 'stopInfo'
    
  selectFirst: true
    
  constructor: ->
    super
    Photo.bind('sortupdate', @proxy @sortupdate)
    Spine.bind('photo:activate', @proxy @activate)
    Spine.bind('slider:start', @proxy @sliderStart)
    Spine.bind('slider:change', @proxy @size)
    Photo.bind('update', @proxy @update)
    Photo.bind("ajaxError", Photo.errorHandler)
    Album.bind("ajaxError", Album.errorHandler)
    
#    Photo.bind('uri', @proxy @uri)
    
  change: ->
    console.log 'PhotosList::change'
    
  select: (item, lonely) ->
    console.log 'PhotosList::select'
    item?.addRemoveSelection(lonely)
    @current = Photo.current(item?)
    @exposeSelection()
  
  render: (items, mode='html') ->
    console.log 'PhotosList::render'
    if Album.record
      @el.removeClass 'all'
      if items.length
        @[mode] @template items
        @exposeSelection() if mode is 'html'
        @uri items, mode
      else
        html = '<label class="invite"><span class="enlightened">This Album has no Photos. &nbsp;'
        if Photo.count()
          html += '<button class="optShowAllPhotos dark large">Show existing Photos</button></span>'
        html += '</label>'
        @html html
    else
      @el.addClass 'all'
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
    
    Photo.uri @thumbSize(),
      (xhr, record) => @callback(xhr, items),
      @photos()
  
  callback: (json = [], items) =>
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
#    @loadModal items
    Spine.trigger('show:slideshow') if App.slideshow.options.autostart
    
  photos: ->
    if Album.record
      Album.record.photos()
    else
      Photo.all()
    
  imageLoad: ->
    css = 'url(' + @src + ')'
    $('.thumbnail', @element).css
      'backgroundImage': css
      'backgroundPosition': 'center, center'
      'backgroundSize': '100%'
    
    
  #  ****** START SLIDESHOW SPECIFICS *****
  
  modalParams: ->
    width: 600
    height: 451
    square: 2
    force: false
    
  loadModal: (items, mode='html') ->
    Photo.uri @modalParams(),
      (xhr, record) => @callbackModal(xhr, items),
      @photos()
  
  callbackModal: (json, items) ->
    console.log 'Slideshow::callbackModal'
    searchJSON = (id) ->
      for itm in json
        return itm[id] if itm[id]
        
    for item in items
      jsn = searchJSON item.id
      if jsn
        el = @children().forItem(item)
        a = $('<a></a>').attr
          'data-href'             : jsn.src
          'title'                 : item.title or item.src
          'data-iso'              : item.iso or ''
          'data-captured'         : item.captured or ''
          'data-description'      : item.description or ''
          'data-model'            : item.model or ''
          'rel'                   : 'gallery'
        $('.play', el).append a
        
#    App.showView.slideshowView.play() if App.showView.slideshowView.autoplay
    
  #  ****** END ***** 
  
  exposeSelection: ->
    console.log 'PhotosList::exposeSelection'
    @deselect()
    list = Album.selectionList()
    for id in list
      if Photo.exists(id)
        item = Photo.find(id) 
        @children().forItem(item).addClass("active")
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
    
    @select item, @isCtrlClick(e)
    App.showView.trigger('change:toolbarOne')
    
    e.stopPropagation() if $(e.target).hasClass('thumbnail')
  
  zoom: (e) ->
    console.log 'PhotosList::zoom'
    item = $(e?.currentTarget).item() || @current
    return unless item?.constructor?.className is 'Photo'
    @select(item, true)
    
    @navigate '/gallery/' + Gallery.record.id + '/' + Album.record.id + '/' + @current.id
    
    e?.stopPropagation()
    e?.preventDefault()
  
  deletePhoto: (e) ->
    item = $(e.currentTarget).item()
    return unless item?.constructor?.className is 'Photo' 
    
    el = $(e.currentTarget).parents('.item')
    el.removeClass('in')
    Album.updateSelection item.id
    
    window.setTimeout( =>
      Spine.trigger('destroy:photo')
      @stopInfo()
    , 300)
    
    @stopInfo()
    e.stopPropagation()
    e.preventDefault()
    
  sortupdate: ->
    @children().each (index) ->
      item = $(@).item()
#      console.log AlbumsPhoto.filter(item.id, func: 'selectPhoto').length
      if item and Album.record
        ap = AlbumsPhoto.filter(item.id, func: 'selectPhoto')[0]
        if ap and ap.order isnt index
          ap.order = index
          ap.save()
        # set a *invalid flag*, so when we return to albums cover view, thumbnails can get regenerated
        Album.record.invalid = true
        Album.record.save(ajax:false)
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
    el = $('.icon-set' , $(e.currentTarget)).addClass('in').removeClass('out')
    e.preventDefault()
    
  infoBye: (e) =>
    @info.bye()
    el = $('.icon-set' , $(e.currentTarget)).addClass('out').removeClass('in')
    e.preventDefault()
    
  stopInfo: (e) =>
    @info.bye()
    
  infoEnter: (e) ->
#    el = $(e.target).find('.more-icon')
#    el.addClass('in')
    
  infoMove: (e) ->
#    return unless $(e.target).hasClass('items')
#    el = $(e.target).find('.more-icon')
#    el.removeClass('in')
    
  sliderStart: =>
    @refreshElements()
    
  size: (val, bg='none') ->
    # 2*10 = border radius
    @thumb.css
      'height'          : val+'px'
      'width'           : val+'px'
      'backgroundSize'  : bg
    
module?.exports = PhotosList