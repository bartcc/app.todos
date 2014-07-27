Spine   = require("spine")
$       = Spine.$
Recent  = require('models/recent')
Photo   = require('models/photo')
Extender= require("plugins/controller_extender")

require("plugins/tmpl")

class OverviewView extends Spine.Controller

  @extend Extender

  elements:
    '#overview-carousel'            : 'carousel'
    '.carousel-inner'               : 'content'
    '.carousel-inner .recents'      : 'items'
    '.carousel-inner .recents .item': 'item'
    '.carousel-inner .summary'      : 'summary'
    
  events:
    'click button.close'  : 'close'
    'click .item'         : 'showPhoto'
    'keyup'               : 'keyup'

  template: (photos) ->
    $("#overviewTemplate").tmpl
      photos: photos
      summary:
        galleries: Gallery.all()
        albums: Album.all()
        photos: Photo.all()

  toolsTemplate: (items) ->
    $("#toolsTemplate").tmpl items
    
  constructor: ->
    super
    @bind('active', @proxy @active)
    # carousel options
    @options =
      interval: 2000
    @carousel.on('slide.bs.carousel', @proxy @focus)
    @el.data current: Recent
    @max = 18
    @bind('render:toolbar', @proxy @renderToolbar)
    
  focus: (e) ->
    @carousel.focus()
    
  parse: (json) ->
    recents = []
    for item in json
      recents.push item['Photo']
    Recent.refresh(recents, {clear:true})
    @render Recent.all()
    
  render: (tests) ->
    #validate fresh records against existing model collection
    items = []
    for test in tests
      items.push photo if photo = Photo.find(test.id)
      
    @content.html @template items
    @refreshElements()
    @carousel.carousel @options
    @uri items
    
  thumbSize: (width = 70, height = 70) ->
    width: width
    height: height
    
  uri: (items) ->
    try
      Photo.uri @thumbSize(),
        (xhr, records) => @callback(xhr, items),
        items
    catch e
      @log e
      alert "New photos found. \n\nRestarting Application!"
      User.redirect 'director_app'
  
  callback: (json, items) =>
    @log 'callback'
    searchJSON = (id) ->
      for itm in json
        return itm[id] if itm[id]
        
    for item in items
      photo = item
      jsn = searchJSON photo.id
      photoEl = @items.children().forItem(photo)
      @log 
      img = new Image
      img.element = photoEl
      if jsn
        img.src = jsn.src
      else
        img.src = '/img/nophoto.png'
      img.onload = @imageLoad
        
  imageLoad: ->
    css = 'url(' + @src + ')'
    $('.thumbnail', @element).css
      'backgroundImage': css
      'backgroundPosition': 'center, center'
    
  loadRecent: ->
    Recent.loadRecent(@max, @proxy @parse)
    
  active: ->
    @loadRecent()
    @el.focus()
    
  showPhoto: (e) ->
    index = @item.index($(e.currentTarget))
    @slideshow.trigger('play', {index:index}, Recent.all())
    e.preventDefault()
    e.stopPropagation()
  
  error: (xhr, statusText, error) ->
    @log xhr
    @record.trigger('ajaxError', xhr, statusText, error)
    
  close: (e) ->
    e.preventDefault()
    e.stopPropagation()
    
    if localStorage.previousHash and localStorage.previousHash isnt location.hash
      location.hash = localStorage.previousHash
      delete localStorage.previousHash
    else
      @navigate '/galleries', ''
      
  keyup: (e) ->
    e.preventDefault()
    code = e.charCode or e.keyCode
    
#    @log 'OverviewView:keyupCode: ' + code
    
    switch code
      when 32 #Space
        paused = @carousel.data('bs.carousel').paused
        if paused
          @carousel.carousel('next')
          @carousel.carousel('cycle')
        else
          @carousel.carousel('pause')
      when 39 #Right
        @carousel.carousel('next')
        
      when 37 #Left
        @carousel.carousel('prev')

module?.exports = OverviewView