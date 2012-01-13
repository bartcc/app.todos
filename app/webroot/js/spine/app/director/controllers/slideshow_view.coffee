Spine ?= require("spine")
$      = Spine.$

class SlideshowView extends Spine.Controller
  
  elements:
    '.items'           : 'items'
    '.thumbnail'       : 'thumb'
    '#gallery'         : 'galleryEl'
    
  events:
#    'click'            : 'click'
    'click .thumbnail' : 'clickThumb'
#    'click a'          : 'anker'
    
  template: (items) ->
    $("#photosTemplate").tmpl items

  constructor: ->
    super
    @el.data current: false
    @thumbSize = 140
    @fullscreen = true
    @autoplay = false
    Spine.bind('show:slideshow', @proxy @show)
    Spine.bind('play:slideshow', @proxy @play)
    
  render: (items) ->
    console.log 'SlideshowView::render'
    @items.html @template items
    @uri items, 'append'
    @refreshElements()
    @size()
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
        el = document.createElement('a')
        ele = @items.children().forItem(item)
          .children('.thumbnail')
          .append $(el).hide()
          .attr
            'href'  : jsn.src
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
    return unless Album.record
    Spine.trigger('change:canvas', @)
    
    filterOptions =
      key: 'album_id'
      joinTable: 'AlbumsPhoto'
    items = Photo.filter(Album.record.id, filterOptions)
    @render items
    
  size: (val=@thumbSize, bg='none') ->
    # 2*10 = border radius
    @thumb.css
      'height'          : val+'px'
      'width'           : val+'px'
      'backgroundSize'  : bg
    
  play: (autoplay) ->
    @refreshElements()
    if autoplay
      first = @galleryEl.find('.thumbnail:first')
      window.setTimeout ->
        first.click()
      , 1
      
  slideshow: (active) ->
    val = if active then 4000 else 0
    @galleryEl.imagegallery 'option', 'slideshow', val
    @play val if val
  
  slideshowMode: (active=@autoplay) ->
    @autoplay = unless active is false then active else false
    @slideshow @autoplay
  
  fullscreenMode: (active=@fullscreen) ->
    @fullscreen = unless active is false then active else false
    @toggleFullscreen @fullscreen
    @fullscreen
    
  # Toggle fullscreen mode:
  toggleFullscreen: (active) ->
    root = document.documentElement
    if active
      $('#gallery-modal').addClass('fullscreen')
      if(root.webkitRequestFullScreen)
        root.webkitRequestFullScreen(window.Element.ALLOW_KEYBOARD_INPUT)
      else if(root.mozRequestFullScreen)
        root.mozRequestFullScreen()
    else
      $('#gallery-modal').removeClass('fullscreen')
      (document.webkitCancelFullScreen || document.mozCancelFullScreen || $.noop).apply(document)
      
#  click: (e) ->
#    e.stopPropagation()
#    e.preventDefault()
      
  clickThumb: (e) ->
    console.log 'SlideshowView::click'
    el =  $(e.target).find('a')
    e.stopPropagation()
    e.preventDefault()
    el.click()
    
  anker: (e) ->
    e.stopPropagation()
    e.preventDefault()
    
module?.exports = SlideshowView