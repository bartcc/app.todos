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
    @thumbSize = 140
    @fullScreen = true
    @autoplay = false
    Spine.bind('show:slideshow', @proxy @show)
    Spine.bind('play:slideshow', @proxy @play)
    Spine.bind('slider:change', @proxy @size)
    Spine.bind('slider:start', @proxy @sliderStart)
    
  render: (items) ->
    return unless @isActive()
    console.log 'SlideshowView::render'
    @items.html @template items
    @uri items, 'append'
    @refreshElements()
    @size(App.showView.sliderOutValue())
    
    @items.sortable 'photo'
    @el
        
  params: (width = @parent.thumbSize, height = @parent.thumbSize) ->
    width: width
    height: height
  
  modalParams: ->
    width: 600
    height: 451
    square: 2
    force: false
    
  uri: (items, mode) ->
    console.log 'SlideshowView::uri'
    Album.record.uri @params(), mode, (xhr, record) => @callback items, xhr
    
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
  
  # this loads the image-source attributes pointing to the regular sized image files necessary for the slideshow
  loadModal: (items, mode='html') ->
    Album.record.uri @modalParams(), mode, (xhr, record) => @callbackModal items, xhr
  
  callbackModal: (items, json) ->
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
        
  imageLoad: ->
    css = 'url(' + @src + ')'
    $('.thumbnail', @element).css
      'backgroundImage': css
      'backgroundPosition': 'center, center'
      'backgroundSize': '100%'
    
  show: ->
    console.log 'Slideshow::show'
#    return unless Album.record
    Spine.trigger('change:canvas', @)
    
    filterOptions =
      key: 'album_id'
      joinTable: 'AlbumsPhoto'
      sorted: true
    items = Photo.filterRelated(Album.record.id, filterOptions)
    @render items
    
  sliderStart: =>
    @refreshElements()
    
  size: (val=@thumbSize, bg='none') ->
    # 2*10 = border radius
    @thumb.css
      'height'          : val+'px'
      'width'           : val+'px'
      'backgroundSize'  : bg
    
  play: ->
    return if @parent.slideshowMode is App.SILENTMODE
    @items.find('li:first').click()
    
#    modal = $('#modal-gallery').data('modal')
#    modal.toggleSlideShow()
      
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
      
module?.exports = SlideshowView