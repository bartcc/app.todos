Spine       = require("spine")
$           = Spine.$
Model       = Spine.Model
Controller  = Spine.Controller
Photo       = require('models/photo')
AlbumsPhoto = require('models/albums_photo')

require('plugins/uri')
require("plugins/tmpl")
Extender = require("plugins/controller_extender")

class SlideshowView extends Spine.Controller
  
  @extend Extender
  
  elements:
    '.items'           : 'items'
    '.thumbnail'       : 'thumb'
    
  events:
    'click .items': 'click'
    
  template: (items) ->
    $("#photosSlideshowTemplate").tmpl items

  constructor: ->
    super
    @el.data
      current:
        className: 'Slideshow'
    @thumbSize = 240
    
    Spine.bind('show:slideshow', @proxy @show)
    Spine.bind('slider:change', @proxy @size)
    Spine.bind('slider:start', @proxy @sliderStart)
    Spine.bind('chromeless', @proxy @chromeless)
    @bind('play', @proxy @play)
    
  render: (items) ->
    console.log 'SlideshowView::render'
    @items.html @template items
    @uri items
    @refreshElements()
    @size(App.showView.sliderOutValue())
    
    @items.children().sortable 'photo'
    @el
       
  exposeSelection: ->
    console.log 'SlideshowView::exposeSelection'
    @deselect()
    list = Album.selectionList()
    for id in list
      if Photo.exists(id)
        item = Photo.find(id) if Photo.exists(id)
        @items.children().forItem(item, true).addClass("active")
       
  params: (width = @parent.thumbSize, height = @parent.thumbSize) ->
    width: width
    height: height
  
  uri: (items) ->
    console.log 'SlideshowView::uri'
    Photo.uri @params(),
      (xhr, record) => @callback(items, xhr),
      @photos()
    
  # we have the image-sources, now we can load the thumbnail-images
  callback: (items, json) ->
    console.log 'PhotosList::callback'
    searchJSON = (id) ->
      for itm in json
        return itm[id] if itm[id]
    for item in items
      jsn = searchJSON item.id
      if jsn
        ele = @items.children().forItem(item)
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
    
  modalParams: ->
    width: 600
    height: 451
    square: 2
    force: false
    
  # this loads the image-source attributes pointing to the regular sized image files necessary for the slideshow
  loadModal: (items, mode='html') ->
#    Album.record.uri @modalParams(), mode, (xhr, record) => @callbackModal xhr, items
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
        el = @items.children().forItem(item)
        $('div.thumbnail', el).attr
          'data-href'   : jsn.src
          'title'       : item.title or item.src
          'data-gallery': 'gallery'
    @trigger('slideshow:ready')
        
  slideshowPhotos: ->
    filterOptions =
      key: 'album_id'
      joinTable: 'AlbumsPhoto'
      sorted: true
      
    list = []
    if @photos().length
      for aid in Gallery.selectionList()
        photos = Photo.filterRelated(aid, filterOptions)
        list.push photo for photo in photos
    list
        
  show: ->
    console.log 'Slideshow::show'
    
    App.showView.trigger('change:toolbarOne', ['SlideshowPackage', App.showView.initSlider])
    App.showView.trigger('change:toolbarTwo', ['Back', 'Play'])
    App.showView.trigger('canvas', @)
    
    list = @slideshowPhotos()
    if list.length
      @render list
    else
      @notify()
      @parent.showPrevious()
    
  close: (e) ->
    @parent.showPrevious()
    if Gallery.record
      @navigate '/gallery', Gallery.record.id
    else
      @navigate '/galleryies/'
    
  sliderStart: =>
    @refreshElements()
    
  size: (val=@thumbSize, bg='none') ->
    # 2*10 = border radius
    @thumb.css
      'height'          : val+'px'
      'width'           : val+'px'
      'backgroundSize'  : bg
    
  # Toggle fullscreen mode:
  toggleFullScreen: (activate) ->
  
    root = document.documentElement
    
    if activate or !(isActive = @fullScreenEnabled())
      if(root.webkitRequestFullScreen)
        root.webkitRequestFullScreen(window.Element.ALLOW_KEYBOARD_INPUT)
      else if(root.mozRequestFullScreen)
        root.mozRequestFullScreen()
    else
      (document.webkitCancelFullScreen || document.mozCancelFullScreen || $.noop).apply(document)
    @fullScreenEnabled()
      
  fullScreenEnabled: ->
    !!(window.fullScreen)# or $('#modal-gallery').hasClass('modal-fullscreen')
    
  slideshowable: ->
    @photos().length
    
  playDeferred: ->
    first = =>
      $('[data-gallery=gallery]', @el)[0]
      
    if @slideshowable()
      first().click()
    else
      @notify()
    
  play: ->
    unless @isActive()
      @one('slideshow:ready', @proxy @playDeferred)
      @navigate '/slideshow', (Math.random() * 16 | 0), 1
    else
      @playDeferred()
    
      
  click: (e) ->
    e.stopPropagation()
    e.preventDefault()
    
    target = $(e.target)[0]
    options =
      index             : target
      startSlideshow    : true
      slideshowInterval : 2000
    links = $('.thumbnail', @items)
    gallery = blueimp.Gallery(links, options)
    
  hide: (e) ->
    @parent.showPrevious()
   
  notify: ->
    App.modalSimpleView.show
      header: 'No Photos for a Slideshow'
      body: 'Please select on or more albums containing at least one photo'
   
  toggle: (e) ->
    unless @slideshowable()
      @notify()
      return
    
    @play()
#    unless App.slideshow.isShown
#      @navigate '/slideshow', (Math.random() * 16 | 0), 1
#    else
#      @modal.modal('toggleSlideShow')
#    false
    
module?.exports = SlideshowView