Spine         = require("spine")
$             = Spine.$
Album         = require('models/album')
AlbumsPhoto   = require('models/albums_photo')
Info          = require('controllers/info')
Extender      = require('plugins/controller_extender')
Drag          = require("plugins/drag")

require("plugins/tmpl")

class PhotoView extends Spine.Controller
  
  @extend Drag
  @extend Extender
  
  elements:
    '.hoverinfo'       : 'infoEl'
    '.items'           : 'items'
    '.items .item'     : 'item'
  
  events:
    'mousemove  .item'                : 'infoUp'
    'mouseleave .item'                : 'infoBye'
    'dragstart  .item'                : 'stopInfo'
    'dragstart'                       : 'dragstart'
    'drop       .item'                : 'drop'
    'click .glyphicon-set .back'      : 'back'
    'click .glyphicon-set .delete'    : 'deletePhoto'
    'click .glyphicon-set .resize'    : 'resize'
    
  template: (item) ->
    $('#photoTemplate').tmpl(item)
    
  infoTemplate: (item) ->
    $('#photoInfoTemplate').tmpl item
    
  constructor: ->
    super
    @el.data current: Photo
    @type = 'Photo'
    @info = new Info
      el: @infoEl
      template: @infoTemplate
    @viewport = @items
    
    Photo.one('refresh', @proxy @refresh)
    Spine.bind('show:photo', @proxy @show)
    
  render: (item=Photo.record) ->
    return unless @isActive()
    @items.html @template item
    @uri item
    @el
  
  refresh: ->
    @render()
    
  show: ->
    App.showView.trigger('change:toolbarOne', ['Default'])
    App.showView.trigger('change:toolbarTwo', ['Test'])
    App.showView.trigger('canvas', @)
    
  activated: ->
    @render()
    
  params: ->
    width: 600
    height: 451
    square: 2
    force: false
    
  uri: (item, mode = 'html') ->
    console.log 'PhotoView::uri'
    Photo.uri @params(),
      (xhr, record) => @callback(xhr, item),
      [item]
  
  callback: (json, item) =>
    console.log 'PhotoView::callback'
    img = new Image
    img.onload = @imageLoad
    
    searchJSON = (id) ->
      for itm in json
        return itm[id] if itm[id]
        
#    for item in items
    jsn = searchJSON item.id
    if jsn
      img.parentEl = $('.thumbnail', @el)#.forItem(item)
      img.src = jsn.src
  
  imageLoad: ->
    parentEl = @parentEl
    w = @width
    h = @height
    
    img = $(@)
    parentEl.html img
    .hide()
    .css
      'opacity'           : 0.01
    parentEl.animate
      'width'             : w+'px'
      'height'            : h+'px'
    , complete: => img
      .css
        'opacity'         : 1
      .fadeIn()
      parentEl.css
        'borderStyle'       : 'solid'
        'backgroundColor'   : 'rgba(255, 255, 255, 0.5)'
  
  deletePhoto: (e) ->
    item = $(e.currentTarget).item()
    return unless item?.constructor?.className is 'Photo' 
    
    @items.removeClass('in')
    
    window.setTimeout( =>
      Spine.trigger('destroy:photo', [item.id])
      @back(e)
    , 300)
    
    @stopInfo(e)
    
    e.stopPropagation()
    e.preventDefault()
  
  back: (e) ->
    @navigate '/gallery', Gallery.record.id, Album.record.id
    e.stopPropagation()
    e.preventDefault()
    
  resize: (e) ->
    e.stopPropagation()
    e.preventDefault()
    
    @parent.slideshowView.trigger('play', {}, [Photo.record])
    
  infoUp: (e) =>
    @info.up(e)
    el = $('.glyphicon-set' , $(e.currentTarget)).addClass('in').removeClass('out')
    e.preventDefault()
    
  infoBye: (e) =>
    @info.bye()
    el = $('.glyphicon-set' , $(e.currentTarget)).addClass('out').removeClass('in')
    e.preventDefault()
    
  stopInfo: (e) =>
    @info.bye()
    
module?.exports = PhotoView