Spine         = require("spine")
Drag          = require("plugins/drag")
$             = Spine.$
Album         = require('models/album')
AlbumsPhoto   = require('models/albums_photo')
Info          = require('controllers/info')

require("plugins/tmpl")

class PhotoView extends Spine.Controller
  
  @extend Drag
  
  elements:
    '.hoverinfo'       : 'infoEl'
    '.items'           : 'items'
    '.items .item'     : 'item'
  
  events:
    'click'                           : 'click'
    'mousemove  .item'                : 'infoUp'
    'mouseleave .item'                : 'infoBye'
    'dragstart  .item'                : 'stopInfo'
    'dragstart  .items .thumbnail'    : 'dragstart'
    'dragenter  .items .thumbnail'    : 'dragenter'
    'drop       .items .thumbnail'    : 'drop'
    'dragend    .items .thumbnail'    : 'dragend'
    'dragenter'                       : 'dragenter'
    'drop'                            : 'drop'
    'dragend'                         : 'dragend'
    'click .glyphicon-set .back'      : 'back'
    
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
    
    
    Spine.bind('show:photo', @proxy @show)
    AlbumsPhoto.bind('destroy', @proxy @remove)
    Photo.bind('update', @proxy @renderHeader)
    Photo.bind('destroy', @proxy @destroy)
    Spine.bind('change:selectedPhoto', @proxy @renderHeader)
    
  change: (item) ->
    console.log 'PhotoView::change'
    @render(item)
    
  render: (item) ->
    console.log 'PhotoView::render'
    @current = item
    @created = !!@items.html @template @current unless @once
    @uri @current
    @renderHeader item
    
  renderHeader: (item) ->
    @header.change item
  
  remove: (ap) ->
    console.log ap
    photo = Photo.exists ap.photo_id
    console.log photo
    $('.item', @el).remove()
    Photo.current()
    @renderHeader @current
    delete @current
    @created = false
  
  destroy: (item) ->
    console.log 'PhotoView::destroy'
    photoEl = @items.children().forItem item
    photoEl.remove()
    Photo.current()
    @renderHeader @current
    delete @current
    @created = false
    
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
      img.parent = $('.thumbnail', @el)#.forItem(item)
      img.src = jsn.src
  
  imageLoad: ->
    parent = @parent
    w = @width
    h = @height
    
    img = $(@)
    parent.html img
    .hide()
    .css
      'opacity'           : 0.01
    parent.animate
      'width'             : w+'px'
      'height'            : h+'px'
    , complete: => img
      .css
        'opacity'         : 1
      .fadeIn()
      parent.css
        'borderStyle'       : 'solid'
        'backgroundColor'   : 'rgba(255, 255, 255, 0.5)'
        'backgroundImage'   : 'none'
  
  deletePhoto: (e) ->
    item = $(e.currentTarget).item()
    return unless item?.constructor?.className is 'Photo' 
    
    el = $(e.currentTarget).parents('.item')
    el.removeClass('in')
    Album.updateSelection item.id
    
    window.setTimeout( ->
      Spine.trigger('destroy:photo')
    , 300)
    
    @stopInfo()
    e.stopPropagation()
    e.preventDefault()
  
  back: (e) ->
    @navigate '/gallery', Gallery.record.id, Album.record.id
    e.stopPropagation()
    e.preventDefault()
    
  click: (e) ->
    e.stopPropagation()
    e.preventDefault()
    
  
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
  
  show: (photo) ->
    App.showView.trigger('change:toolbarOne', ['Default'])
    App.showView.trigger('canvas', @)
    @change photo unless photo.id is @current?.id
    
module?.exports = PhotoView