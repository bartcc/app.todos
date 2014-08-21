Spine           = require("spine")
$               = Spine.$
Model           = Spine.Model
Controller      = Spine.Controller
Photo           = require('models/photo')
AlbumsPhoto     = require('models/albums_photo')
Extender        = require("plugins/controller_extender")

require('plugins/uri')
require('plugins/tmpl')
require('plugins/utils')

class SlideshowView extends Spine.Controller
  
  @extend Extender
  
  elements:
    '.items'           : 'itemsEl'
    '.thumbnail'       : 'thumb'
    
  events:
    'click .item'      : 'click'
    'click .back'      : 'back'
    
    'keydown'          : 'keydown'
    
  template: (items) ->
    $("#photosSlideshowTemplate").tmpl items

  constructor: ->
    super
    @bind('active', @proxy @active)
    @el.data('current',
      model: Gallery
      models: Album
    )
    @images = []
    @viewport = @el
    @thumbSize = 240
    
    @defaults =
      index             : 0
      startSlideshow    : true
      slideshowInterval : 2000
      clearSlides: true
      container: '#blueimp-gallery'
      displayClass: 'blueimp-gallery-display'
      fullScreen: false
      carousel: false
      useBootstrapModal: true
      onopened: @proxy @onopenedGallery
      onclose:  @proxy @oncloseGallery
      onclosed: @proxy @onclosedGallery
      onslide: @onslide
    
    @bind('play', @proxy @play)
    Spine.bind('slider:change', @proxy @size)
    Spine.bind('chromeless', @proxy @chromeless)
    Spine.bind('loading:done', @proxy @loadingDone)
    
  active: (params) ->
    if params
      @options = $().unparam(params)
      
    App.showView.trigger('change:toolbarOne', ['SlideshowPackage', App.showView.initSlider])
    App.showView.trigger('change:toolbarTwo', ['Close'])
    @activated()
    
  activated: ->
    list = []
    if @images.length
      list.update @images
    else
      list.update Gallery.activePhotos()

    @render list
    
  render: (items) ->
    @log 'render'
    unless items.length
      @itemsEl.html '<label class="invite">
        <span class="enlightened">This slideshow does not have any images &nbsp;
        <p>Note: Select one or more albums with images.</p>
        </span>
        <button class="back dark large"><i class="glyphicon glyphicon-chevron-up"></i><span>&nbsp;Back</span></button>
        </label>'
    else
      @itemsEl.html @template items
      @uri items
      @refreshElements()
      @size(App.showView.sliderOutValue())
    
    @el
    
  loadingDone: ->
    return unless @isActive()
    @images.update []
    @trigger('active')
       
  params: (width = @parent.thumbSize, height = @parent.thumbSize) ->
    width: width
    height: height
  
  uri: (items) ->
    @log 'uri'
    Photo.uri @params(),
      (xhr, record) => @callback(items, xhr),
      items
    
  # we have the image-sources, now we can load the thumbnail-images
  callback: (items, json) ->
    @log 'callback'
    searchJSON = (id) ->
      for itm in json
        return itm[id] if itm[id]
    for item, index in items
      jsn = searchJSON item.id
      if jsn
        ele = @itemsEl.children().forItem(item)
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
      items
  
  callbackModal: (json, items) ->
    @log 'callbackModal'
    
    searchJSON = (id) ->
      for itm in json
        return itm[id] if itm[id]
        
    for item in items
      jsn = searchJSON item.id
      if jsn
        el = @itemsEl.children().forItem(item)
        thumb = $('.thumbnail', el)
        thumb.attr
          'href'   : jsn.src
          'title'       : item.title or item.src
          'data-gallery': 'gallery'
          'data-description': item.description
    @trigger('slideshow:ready')
      
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
    
  click: (e) ->
    options =
      index         : @thumb.index($(e.target))
      startSlideshow: false
    @play(options)
    
    e.stopPropagation()
    e.preventDefault()
    
  play: (options={index:0}, list=[]) ->
#    unless @isActive() and @parent.isActive()
    @images.update list # mixin images to override album images
    @one('slideshow:ready', @proxy @playSlideshow)
    @previousHash = location.hash unless /^#\/slideshow\//.test(location.hash)
    params = $.param(options)
    @navigate '/slideshow', params
      
  playSlideshow: (options=@options) ->
    return if @galleryIsActive()
    options = $().extend({}, @defaults, options)
    @refreshElements()
    @gallery = blueimp.Gallery(@thumb, options)
    delete @options
    
  onopenedGallery: (e) ->
    
  onclosedGallery: (e) ->
    
  oncloseGallery: (e) ->
    if @previousHash
      location.hash = @previousHash
      delete @previousHash
    else
      @parent.back()
    
  onclosedGallery: (e) ->
    @images = []
    
  onslide: (index, slide) ->
    text = @list[index].getAttribute('data-description')
    node = @container.find('.description')
    node.empty()
    if (text)
      node[0].appendChild(document.createTextNode(text));
    
  galleryIsActive: ->
    $('#blueimp-gallery').hasClass(@defaults.displayClass)
    
  back: (e) ->
    if localStorage.previousHash and localStorage.previousHash isnt location.hash
      location.hash = localStorage.previousHash
      delete localStorage.previousHash
    else
      @navigate '/galleries/'
    
  keydown: (e) ->
    code = e.charCode or e.keyCode
    
    @log 'SlideshowView:keydownCode: ' + code
    
    switch code
      when 27 #Esc
        @back(e)
        e.preventDefault()
  
module?.exports = SlideshowView