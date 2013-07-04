Spine       = require("spine")
$           = Spine.$
Photo       = require('models/photo')
Album       = require('models/album')
AlbumsPhoto = require('models/albums_photo')
Extender    = require('plugins/controller_extender')

require("plugins/tmpl")

class PhotosList extends Spine.Controller
  
  @extend Extender
  
  elements:
    '.thumbnail'              : 'thumb'
    
  events:
    'click .item'             : 'click'
    'click .icon-set .back'   : 'back'
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
    Photo.bind('activate', @proxy @activate)
    Spine.bind('slider:start', @proxy @sliderStart)
    Spine.bind('slider:change', @proxy @size)
    Photo.bind('update', @proxy @update)
    AlbumsPhoto.bind('beforeSave', @proxy @updateRelated)
#    Photo.bind("ajaxError", Photo.errorHandler)
    Album.bind("ajaxError", Album.errorHandler)
    
  change: ->
    console.log 'PhotosList::change'
    
  render: (items=[], mode='html') ->
    console.log 'PhotosList::render'
    if Album.record
      @wipe().removeClass 'all'
      if items.length
        console.log items
        @[mode] @template items
        @uri items, mode
      else
        html = '<label class="invite"><span class="enlightened">No Photos here. &nbsp;<p>Simply drop your photos in your browser window</p>'
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
  
  wipe: ->
    wipe = Album.record and Album.record.contains() is 1
    @el.empty() if wipe
    @el
  
  update: (item, ap) ->
    console.log 'PhotosList::update'
    el = =>
      @children().forItem(item, true)
    tb = ->
      $('.thumbnail', el())
      
    backgroundImage = tb().css('backgroundImage')
    css = tb().attr('style')
    active = el().hasClass('active')
    try
      tmplItem = el().tmplItem()
      tmplItem.data.order = ap.order or tmplItem.data.order
      tmplItem.tmpl = $( "#photosTemplate" ).template()
      tmplItem.update()
    catch e
      return
    tb().attr('style', css)
    el().toggleClass('active', active)
    @el.sortable('destroy').sortable('photos')
    @refreshElements()
  
  updateRelated: (ap) ->
    photo = Photo.exists(ap['photo_id'])
    @update(photo, ap)
  
  thumbSize: (width = App.showView.thumbSize, height = App.showView.thumbSize) ->
    width: width
    height: height
  
  # the actual final rendering method
  uri: (items, mode) ->
    console.log 'PhotosList::uri'
    @size(App.showView.sOutValue)
    
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
        ele = @children().forItem(item, true)
        src = jsn.src
        img = new Image
        img.element = ele
        img.onload = @imageLoad
        img.src = src
    Spine.trigger('show:slideshow') if App.slideshow.options.autostart
    
  photos: (id) ->
    if Album.record
      Album.record.photos()
    else if id
      Album.photos(id)
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
      if photo = Photo.exists(id)
        @children().forItem(photo, true).addClass("active")
  
  activate: (items = []) ->
    id = null
    unless Spine.isArray items
      items = [items]
    
    for item in items
      if photo = Photo.exists(item)
        unless photo.destroyed
          id = photo.id
          break
      
    Photo.current(id)
      
    @exposeSelection()
      
  select: (item, lonely) ->
    console.log 'PhotosList::select'
    list = item?.addRemoveSelection(lonely)
    Photo.trigger('activate', list)
  
  click: (e) ->
    console.log 'PhotosList::click'
    item = $(e.currentTarget).item()
    
    @select item, @isCtrlClick(e)
    App.showView.trigger('change:toolbarOne')
    
    e.stopPropagation() if $(e.target).hasClass('thumbnail')
  
  zoom: (e) ->
    item = $(e?.currentTarget).item() || @current
    @select item, true
    @stopInfo()
    @navigate '/gallery', (Gallery.record?.id or 'nope'), (Album.record?.id or 'nope'), item.id
    Photo.trigger('activate', item)
    
    e.stopPropagation()
    e.preventDefault()
  
  back: ->
    @navigate '/gallery', Gallery.record.id
  
  deletePhoto: (e) ->
    item = $(e.currentTarget).item()
    return unless item?.constructor?.className is 'Photo' 
    
    el = $(e.currentTarget).parents('.item')
    el.removeClass('in')
    Album.updateSelection item.id
    
    window.setTimeout( =>
      Spine.trigger('destroy:photo')
      @stopInfo()
      if album = Album.record
        unless @el.children().length
          @parent.render() #unless gallery.contains()
    , 300)
    
    @stopInfo()
    e.stopPropagation()
    e.preventDefault()
    
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