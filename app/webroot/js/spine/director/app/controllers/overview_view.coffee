Spine   = require("spine")
$       = Spine.$
Recent  = require('models/recent')
Photo   = require('models/photo')

require("plugins/tmpl")

class OverviewView extends Spine.Controller

  elements:
    '#overview-carousel'         : 'carousel'
    '.carousel-inner'            : 'content'
    '.carousel-inner .recents'   : 'items'
    '.carousel-inner .summary'   : 'summary'
    
  events:
    'click .item'         : 'navi'
    'keyup'               : 'pause'

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
#    @carousel.carousel
#      interval: 1000000
#      pause: 'click'
    @carouselWidth = 450
    @carouselHeight = 350
    @img = new Image
    @img.width = @carouselWidth
    @el.data current: Recent
    @max = 16
    @bind('render:toolbar', @proxy @renderToolbar)
    Spine.bind('show:overview', @proxy @show)
    
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
      items.push photo if photo = Photo.exists(test.id)
      
    @content.html @template items
    @refreshElements()
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
      console.log e
      alert "New photos found. \n\nRestarting Application!"
      User.redirect 'director_app'
  
  callback: (json, items) =>
    console.log 'PhotoList::callback'
    searchJSON = (id) ->
      for itm in json
        return itm[id] if itm[id]
        
    for item in items
      photo = item
      jsn = searchJSON photo.id
      photoEl = @items.children().forItem(photo)
      console.log 
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
    
  activated: ->
    @loadRecent()
    
  show: ->
    App.trigger('canvas', @)
    
  navi: (e) ->
    item = $(e.currentTarget).item()
    return unless item
    photo = Photo.exists(item.id)
    
    if photo
      photo.emptySelection()
      @navigate '/gallery', '/', photo.id
      
    false
  
  pause: ->
    @carousel.carousel('pause')
    
  error: (xhr, statusText, error) ->
    console.log xhr
    @record.trigger('ajaxError', xhr, statusText, error)

module?.exports = OverviewView