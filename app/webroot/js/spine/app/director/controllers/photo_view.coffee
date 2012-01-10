Spine ?= require("spine")
$      = Spine.$

class PhotoView extends Spine.Controller
  
  @extend Spine.Controller.Drag
  
  elements:
    '.hoverinfo'       : 'infoEl'
    '.items'           : 'items'
    '.items .item'     : 'item'
  
  events:
    'mousemove  .item'                : 'infoUp'
    'mouseleave .item'                : 'infoBye'
    'dragstart  .item'                : 'stopInfo'
    'dragstart  .items .thumbnail'    : 'dragstart'
    'dragenter  .items .thumbnail'    : 'dragenter'
    'dragover   .items .thumbnail'    : 'dragover'
    'drop       .items .thumbnail'    : 'drop'
    'dragend    .items .thumbnail'    : 'dragend'
    'dragenter'                       : 'dragenter'
    'dragover'                        : 'dragover'
    'drop'                            : 'drop'
    'dragend'                         : 'dragend'
    
  template: (item) ->
    $('#photoTemplate').tmpl(item)
    
  infoTemplate: (item) ->
    $('#photoInfoTemplate').tmpl item
    
  constructor: ->
    super
    @el.data current: Album
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
    @info.up(e)
    e.preventDefault()
    
  infoBye: (e) =>
    @info.bye()
    e.preventDefault()
    
  stopInfo: (e) =>
    @info.bye()
  
  show: (item) ->
    Spine.trigger('change:toolbarOne', ['Photo'])
    Spine.trigger('change:canvas', @)
    @render item
    
    
module?.exports = PhotoView