Spine ?= require("spine")
$      = Spine.$

class SlideshowView extends Spine.Controller
  
  #slideshow
  # modal = $('#modal-gallery').data('modal')
  # modal.startSlideShow()
  # modal.stopSlideShow()
  
  
  elements:
    '.items'           : 'items'
    '.thumbnail'       : 'thumb'
    
  template: (items) ->
    $("#photosSlideshowTemplate").tmpl items

  constructor: ->
    super
    @el.data
      current: className: 'Slideshow'
    @thumbSize = 240
    @fullScreen = true
    @autoplay = false #the slideshow itselfs autoplay
    @autostart = false #play slideshow upon opening a album
    
    Spine.bind('show:slideshow', @proxy @show)
    Spine.bind('slider:change', @proxy @size)
    Spine.bind('slider:start', @proxy @sliderStart)
    
    @bind('slideshow:ready', @proxy @play)
    
  render: (items) ->
    @items.html @template items
    @uri items
    @refreshElements()
    @size(App.showView.sliderOutValue())
    
    @items.children().sortable 'photo'
    @exposeSelection()
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
  
  modalParams: ->
    width: 600
    height: 451
    square: 2
    force: false
    
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
          'data-href'  : jsn.src
          'title' : item.title or item.src
          'rel'   : 'gallery'
          
    @play()
        
  show: ->
    console.log 'Slideshow::show'
    
    App.showView.trigger('change:toolbarOne', [''])
    App.showView.trigger('change:toolbarTwo', ['SlideshowPackage', App.showView.initSlider])
    App.showView.trigger('canvas', @)
    
    filterOptions =
      key: 'album_id'
      joinTable: 'AlbumsPhoto'
      sorted: true
    
    @render @phos = @photos()
    
  close: (e) ->
    @parent.showPrevious()
    @navigate '/gallery', Gallery.record.id if Gallery.record
    
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
    active = @fullScreenEnabled()
    root = document.documentElement
    unless active
      $('#modal-gallery').addClass('modal-fullscreen')
      if(root.webkitRequestFullScreen)
        root.webkitRequestFullScreen(window.Element.ALLOW_KEYBOARD_INPUT)
      else if(root.mozRequestFullScreen)
        root.mozRequestFullScreen()
    else
      $('#modal-gallery').removeClass('modal-fullscreen')
      (document.webkitCancelFullScreen || document.mozCancelFullScreen || $.noop).apply(document)
      
  fullScreenEnabled: ->
    !!(window.fullScreen) or $('#modal-gallery').hasClass('modal-fullscreen')
    
  slideshowable: ->
    @photos().length
    
  isAutoplay: ->
    @autoplay
  
  isAutostart: ->
    App.slideshow.options.autostart
  
#  startSlideShow: ->
#    App.slideshow.startSlideShow()
#    
#  stopSlideShow: ->
#    App.slideshow.stopSlideShow()
#    
#  cancelSlideShow: ->
#    App.slideshow.stopSlideShow()
#    
#  toggleSlideShow: ->
#    App.slideshow.toggleSlideShow()
    
  play: ->
    unless @isActive()
      @navigate '/slideshow', (Math.random() * 16 | 0)
    
    elFromSelection = =>
      console.log 'elFromSelection'
      list = Album.selectionList()
      if list.length
        id = list[0] 
        item = Photo.find(id) if Photo.exists(id)
        parent = @el.children().forItem(item, true)
        el = $('[rel="gallery"]', parent)[0]
        return el
      return
    
    elFromCanvas = =>
      console.log 'elFromCanvas'
      item = AlbumsPhoto.photos(Album.record.id)[0]
      el = $('[rel=gallery]', @el)[0]
      el
    
    if @slideshowable()
      # prevent ghosted backdrops
      return if $('.modal-backdrop').length
      
      el = (elFromSelection() or elFromCanvas())
      el?.click()
    else
      @notify()
      
  stop: ->
    App.slideshow.stopSlideShow()
   
  notify: ->
    App.modalView.show
      header: 'Information'
      body: 'To start a slideshow at least one (not empty) album must be selected'
      info: 'Tip of the day: You can also use your spacebar to start a slideshow'
   
  toggle: (e) ->
    unless @slideshowable()
      @notify()
      return
    
    unless App.slideshow.isShown
      @navigate '/slideshow', (Math.random() * 16 | 0)
    else
      App.slideshow.toggleSlideShow()
    false
  
      
module?.exports = SlideshowView