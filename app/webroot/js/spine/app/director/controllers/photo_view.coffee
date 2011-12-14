Spine ?= require("spine")
$      = Spine.$

class PhotoView extends Spine.Controller
  
  elements:
    '.items'              : 'items'
    '.items .item'        : 'item'
  
  template: (item) ->
    $('#photoTemplate').tmpl(item)
    
  constructor: ->
    super
    Spine.bind('show:photo', @proxy @show)
    @img = new Image
    @img.onload = @imageLoad
    
  change: (item, changed) ->
    console.log 'PhotoView::change'
    
  render: (item, mode) ->
    console.log 'PhotoView::render'
    @el.data item
    @items.html @template item
    @renderHeader item
    @uri item
    
  renderHeader: (item) ->
    @header.change item
    
  params: ->
    width: 600
    height: 451
    square: 2
    force: false
    
  uri: (item, mode = 'html') ->
    console.log 'PhotoView::uri'
    item.uri @params(), mode, (xhr, record) => @callback item, xhr
  
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
  
  show: ->
    Spine.trigger('change:canvas', @)
    
    
module?.exports = PhotoView