Spine           = require("spine")
$               = Spine.$
Model           = Spine.Model
Controller      = Spine.Controller
Photo           = require('models/photo')
AlbumsPhoto     = require('models/albums_photo')
ModalSimpleView = require("controllers/modal_simple_view")

require('plugins/uri')
require("plugins/tmpl")
Extender = require("plugins/controller_extender")

class SlideshowView extends Spine.Controller
  
  @extend Extender
  
  elements:
    '.items'           : 'items'
    '.thumbnail'       : 'thumb'
    
  events:
    'click .items'     : 'click'
    'hidden.bs.modal'  : 'hiddenmodal'
    
  template: (items) ->
    $("#photosSlideshowTemplate").tmpl items

  constructor: ->
    super
    @el.data
      current:
        className: 'Slideshow'
    @viewport = @el
    @thumbSize = 240
    @modalSimpleView = new ModalSimpleView
      el: $('#modal-view')
    
    @modalSimpleView.el.bind('hidden.bs.modal', @proxy @hiddenmodal)
    @modalSimpleView.el.bind('hide.bs.modal', @proxy @hidemodal)
    @modalSimpleView.el.bind('show.bs.modal', @proxy @showmodal)
    
    @links = $('.thumbnail', @items)
    @bind('play', @proxy @play)
    
    @defaults =
      index             : 0
      startSlideshow    : true
      slideshowInterval : 2000
      onclose: =>
      onclosed: => @close()
    
    Spine.bind('show:slideshow', @proxy @show)
    Spine.bind('slider:change', @proxy @size)
    Spine.bind('slider:start', @proxy @sliderStart)
    Spine.bind('chromeless', @proxy @chromeless)
    Spine.bind('loading:done', @proxy @loadingDone)
    
  render: (items) ->
    console.log 'SlideshowView::render'
    
    @items.html @template items
    @uri items
    @refreshElements()
    @size(App.showView.sliderOutValue())
    
    @el
    
  loadingDone: ->
    return unless @isActive()
    @show()
       
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
    console.log 'SlideshowView::callback'
    searchJSON = (id) ->
      for itm in json
        return itm[id] if itm[id]
    for item, index in items
      jsn = searchJSON item.id
      if jsn
        ele = @items.children().forItem(item)
        img = new Image
        img.onload = @imageLoad
        img.that = @
        img.element = ele
        img.index = index
        img.items = items
        img.src = jsn.src
        $(img).addClass('hide')
  
  imageLoad: ->
    css = 'url(' + @src + ')'
    $('.thumbnail', @element).css
      'backgroundImage': css
      'backgroundPosition': 'center, center'
      'backgroundSize': '100%'
    .append @
    if @index is @items.length-1
      @that.loadModal @items
      
    
  modalParams: ->
    width: 600
    height: 451
    square: 2
    force: false
    
  # loading data-href for original images size (modalParams)
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
        el = @items.children().forItem(item)
        thumb = $('.thumbnail', el)
        thumb.attr
          'href'   : jsn.src
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
    App.showView.trigger('change:toolbarOne', ['SlideshowPackage', App.showView.initSlider])
    App.showView.trigger('change:toolbarTwo', ['Close'])
    App.showView.trigger('canvas', @)
    
  activated: ->
    list = @slideshowPhotos()

    if list.length
      @render list
    else
      @notify(@parent.showPrevious)
    
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
    !!(window.fullScreen)
    
  slideshowable: ->
    @photos().length
    
  opened: ->
    alert 'opened'
    
  hidemodal: (e) ->
    
  hiddenmodal: (e) ->
    @parent.back()
    
  showmodal: (e) ->
    @items.empty()
    
  notify: ->
    @modalSimpleView.show
      header: 'Empty Slideshow'
      body: 'Select one or more albums in order to present its content.'
      
  click: (e) ->
    e.stopPropagation()
    e.preventDefault()
    options = index: @thumb.index($(e.target))
    @play(options)
    
  play: (options={}) ->
    if @isActive()
      options = $().extend(@defaults, options)
      @gallery = blueimp.Gallery(@thumb, options)
    else
      @toggle()
    
  toggle: ->
    if @isActive()
      @play(index:0) unless @gallery
      return
    
    @one('slideshow:ready', @proxy @play)
    @navigate '/slideshow', (Math.random() * 16 | 0), 1
      
  close: (e) ->
    if @isActive()
      @gallery = null
      @parent.back()
  
module?.exports = SlideshowView