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
    @autoplay = false
    
    Spine.bind('show:slideshow', @proxy @show)
    Spine.bind('slider:change', @proxy @size)
    Spine.bind('slider:start', @proxy @sliderStart)
    Spine.bind('slideshow:ready', @proxy @play)
    
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
        item = Photo.find(id)
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
      @phos
    
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
      @phos
  
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
#    @parent.play() if @parent.autoStart()
    Spine.trigger('slideshow:ready')
        
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
      
  activePhotos: ->
    phos = []
    albs =[]
    albs.push itm for itm in Gallery.selectionList()
    return unless albs.length
    for alb in albs
      album = Album.exists(alb)
      photos = album.photos()
      phos.push pho for pho in photos
    phos
    
  slideshowable: ->
    @activePhotos().length
    
    
  play: ->
    console.log 'SlideshowView::play'
    
    elFromSelection = =>
      console.log 'elFromSelection'
      list = Album.selectionList()
      if list.length
        id = list[0] 
        item = Photo.find(id) if Photo.exists(id)
        root = @current.el.children('.items')
        parent = root.children().forItem(item)
        el = $('[rel="gallery"]', parent)[0]
        return el
      return
    
    elFromCanvas = =>
      console.log 'elFromCanvas'
      item = AlbumsPhoto.photos(Album.record.id)[0]
      root = @current.el.children('.items')
      parent = root.children().forItem(item)
      el = $('[rel="gallery"]', parent)[0]
      el
    
    if @slideshowable()
      # prevent ghosted backdrops
#      return if $('.modal-backdrop').length
      console.log it = elFromSelection() or elFromCanvas()
      it.click()
    else
      alert 'UUpps'
        
  pause: (e) ->
    return unless @slideshowable()
    modal = $('#modal-gallery').data('modal')
    isShown = modal?.isShown
    
    unless isShown
      @slideshowPlay(e)
    else
      $('#modal-gallery').data('modal').toggleSlideShow()
      
    false
  
  slideshowPlay: (e) =>
#    Spine.trigger('slideshow:ready') unless @navigate '/slideshow/'
    @navigate '/slideshow', (Math.random() * 16 | 0)
        
      
      
module?.exports = SlideshowView