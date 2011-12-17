Spine ?= require("spine")
$      = Spine.$

class PhotoView extends Spine.Controller
  
  elements:
    '.preview'            : 'previewEl'
    '.items'              : 'items'
    '.items .item'        : 'item'
  
  events:
    'mousemove .item'     : 'previewUp'
    'mouseleave  .item'   : 'previewBye'
    'dragstart .item'     : 'stopPreview'
    
  template: (item) ->
    $('#photoTemplate').tmpl(item)
    
  previewTemplate: (item) ->
    $('#photoPreviewTemplate').tmpl item
    
  constructor: ->
    super
    @preview = new Preview
      el: @previewEl
      template: @previewTemplate
    Spine.bind('show:photo', @proxy @show)
#    AlbumsPhoto.bind('update', @proxy @update)
    AlbumsPhoto.bind('destroy', @proxy @destroy)
    @img = new Image
    @img.onload = @imageLoad
    
  change: (item, changed) ->
    console.log 'PhotoView::change'
    @current = item
    
  render: (item, mode) ->
    console.log 'PhotoView::render'
    return if @current?.id is item.id
    @el.data item
    @items.html @template item
    @renderHeader item
    @uri item
    @change item
    
  renderHeader: (item) ->
    @header.change item
  
  destroy: (item) ->
    console.log 'PhotoView::destroy'
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
  
  previewUp: (e) =>
    e.stopPropagation()
    e.preventDefault()
    @preview.up(e)
    false
    
  previewBye: (e) =>
    e.stopPropagation()
    e.preventDefault()
    @preview.bye()
    false
    
  stopPreview: (e) =>
    @preview.bye()
  
  show: (item) ->
    Spine.trigger('change:canvas', @)
    @render item
    
    
module?.exports = PhotoView