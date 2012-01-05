Spine ?= require("spine")
$      = Spine.$

class PhotoView extends Spine.Controller
  
  elements:
    '.info'            : 'infoEl'
    '.items'           : 'items'
    '.items .item'     : 'item'
  
  events:
    'mousemove .item'     : 'infoUp'
    'mouseleave  .item'   : 'infoBye'
    'dragstart .item'     : 'stopInfo'
    
  template: (item) ->
    $('#photoTemplate').tmpl(item)
    
  infoTemplate: (item) ->
    $('#photoInfoTemplate').tmpl item
    
  constructor: ->
    super
    @el.data current: Photo
    @info = new Info
      el: @infoEl
      template: @infoTemplate
    @img = new Image
    @img.onload = @imageLoad
    
    Spine.bind('show:photo', @proxy @show)
    AlbumsPhoto.bind('destroy', @proxy @destroy)
    
  change: (item, changed) ->
    console.log 'PhotoView::change'
    Photo.activeRecord = @current = item
    
  render: (item, mode) ->
    console.log 'PhotoView::render'
    @items.html @template item
    @renderHeader item
    @uri item
    @change item
    
  renderHeader: (item) ->
    @header.change item
  
  destroy: (item) ->
    console.log 'PhotoView::destroy'
    photoEl = @items.children().forItem @current
    photoEl.remove()
    delete @current
    @renderHeader()
    
  params: ->
    width: 600
    height: 451
    square: 2
    force: false
    
  uri: (item, mode = 'html') ->
    console.log 'PhotoView::uri'
    item.uri @params(), mode, (xhr, record) => @callback record, xhr
  
  callback: (record, json) =>
    console.log 'PhotoView::callback'
    searchJSON = (id) ->
      for itm in json
        return itm[id] if itm[id]
    jsn = searchJSON record.id
    if jsn
      @img.element = $('.item', @items).forItem(record)
      @img.src = jsn.src
  
  imageLoad: ->
    el = $('.thumbnail', @element)
    img = $(@)
    w = @width
    h = @height
    
    el.html img
    .hide()
    .css
      'opacity'           : 0.01
    el.animate
      'width'             : w+'px'
      'height'            : h+'px'
    , complete: => img
      .css
        'opacity'         : 1
      .fadeIn()
      el.css
        'borderWidth'       : '1px'
        'borderStyle'       : 'solid'
        'borderColor'       : '#575757'
        'backgroundColor'   : 'rgba(255, 255, 255, 0.5)'
        'backgroundImage'   : 'none'
  
  infoUp: (e) =>
    e.stopPropagation()
    e.preventDefault()
    @info.up(e)
    false
    
  infoBye: (e) =>
    e.stopPropagation()
    e.preventDefault()
    @info.bye()
    false
    
  stopInfo: (e) =>
    @info.bye()
  
  show: (item) ->
    Spine.trigger('change:toolbar', 'Photo')
    Spine.trigger('change:canvas', @)
    @render item
    
    
module?.exports = PhotoView