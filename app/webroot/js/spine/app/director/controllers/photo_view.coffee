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
    
  change: (item, changed) ->
    console.log 'PhotoView::change'
    
  render: (item, mode) ->
    console.log 'PhotoView::render'
    @items.html @template item
    @renderHeader item
    @uri item
    
  renderHeader: (item) ->
    @header.change item
    
  params: ->
    width: 600
    height: 451
    square: 1
    force: false
    
  uri: (item, mode = 'html') ->
    console.log 'PhotoView::uri'
    item.uri @params(), mode, (xhr, record) => @callback item, xhr
  
  callback: (record, json) =>
    console.log 'PhotoView::callback'
    console.log record
    console.log json
    searchJSON = (id) ->
      for itm in json
        return itm[id] if itm[id]
    jsn = searchJSON record.id
    if jsn
      ele = $('.item', @items).forItem(record)
      console.log ele
      src = jsn.src
      img = new Image
      img.element = ele
      img.onload = @imageLoad
      img.src = src
  
  imageLoad: ->
    console.log @
    console.log @width
    console.log @height
    css = 'url(' + @src + ')'
    $('.thumbnail', @element).css
      'backgroundImage': css
      'backgroundPosition': 'center, center'
      'width': @width+'px'
      'height': @height+'px'
  
  show: ->
    console.log 'PhotoView::show'
    Spine.trigger('change:canvas', @)
    
    
module?.exports = PhotoView