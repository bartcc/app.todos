Spine       = require("spine")
$           = Spine.$
Photo       = require('models/photo')
Album       = require('models/album')
AlbumsPhoto = require('models/albums_photo')
ToolbarView = require("controllers/toolbar_view")
Extender    = require('plugins/controller_extender')
Drag        = require("plugins/drag")

require("plugins/tmpl")

class PhotosList extends Spine.Controller
  
  @extend Drag
  @extend Extender
  
  elements:
    '.thumbnail'              : 'thumb'
    '.toolbar'                : 'toolbarEl'
    
  events:
    'click .item'                  : 'click'
    'click .glyphicon-set .back'   : 'back'
    'click .glyphicon-set .zoom'   : 'zoom'
    'click .glyphicon-set .delete' : 'deletePhoto'
    
    'mouseenter .item'             : 'infoEnter'
    'mousemove'                    : 'infoMove'
    
    'mousemove .item'              : 'infoUp'
    'mouseleave  .item'            : 'infoBye'
    'dragstart'                    : 'dragstart'
    'dragstart .item'              : 'stopInfo'
    'dragover .item'               : 'dragover'
    
  selectFirst: true
    
  constructor: ->
    super
    
    @toolbar = new ToolbarView
      el: @toolbarEl
      
    Photo.bind('activate', @proxy @activate)
    Spine.bind('slider:start', @proxy @sliderStart)
    Spine.bind('slider:change', @proxy @size)
    Photo.bind('update', @proxy @update)
#    Photo.bind("ajaxError", Photo.errorHandler)
    Album.bind("ajaxError", Album.errorHandler)
    AlbumsPhoto.bind('destroy', @proxy @remove)
    
    
  change: ->
    console.log 'PhotosList::change'
    
  render: (items=[], mode='html') ->
    console.log 'PhotosList::render'
    
    if Album.record
      if items.length
        @wipe()
        @[mode] @template items
        @uri items, mode
      else
        html = '<label class="invite"><span class="enlightened">No photos here. &nbsp;<p>Simply drop your photos to your browser window</p><p>Note: You can also drag existing photos to a sidebars folder</p>'
        if Photo.count()
          html += '<button class="optShowAllPhotos dark large">Show existing photos</button></span>'
        html += '</label>'
        @html html
    else
      if Photo.count()
        @renderAll()
      else
        html = '<label class="invite"><span class="enlightened">No photos here. &nbsp;<p>Simply drop your photos to your browser window</p><p>Note: You can also drag existing photos to a sidebars folder</p>'
        @html html
    @activate()
    @el
  
  renderAll: ->
    console.log 'PhotosList::renderAll'
    items = Photo.all()
    if items.length
      @html @template items
      @exposeSelection()
      @uri items, 'html'
    @el
  
  wipe: ->
    wipe = Album.record and Album.record.count() is 1
    @el.empty() if wipe
    @el

  update: (item) ->
    console.log 'PhotosList::update'
    
    helper =
      refresh: =>
        el = @children().forItem(item, true)
        tb = $('.thumbnail', el)
        el: el
        tb: tb

    elements = helper.refresh()
    css = elements.tb.attr('style')
    active = elements.el.hasClass('active')
    hot = elements.el.hasClass('hot')
    photoEl = elements.el.tmplItem()
    photoEl.data = item
    try
      photoEl.update()
    catch e
    elements = helper.refresh()
    elements.tb.attr('style', css)
    elements.el.toggleClass('active', active)
    elements.el.toggleClass('hot', hot)
    @el.sortable('destroy').sortable('photos')
    @refreshElements()
  
  thumbSize: (width, height) ->
    width: width || App.showView.thumbSize
    height: height || App.showView.thumbSize
  
  # the actual final rendering method
  uri: (items, mode) ->
    console.log 'PhotosList::uri'
    @size(App.showView.sOutValue)
    
    Photo.uri @thumbSize(),
      (xhr, record) => @callback(xhr, items),
      @photos()
  
  callback: (json = [], items) =>
    searchJSON = (id) ->
      for itm in json
        return itm[id] if itm[id]
        
    for item in items
      jsn = searchJSON item.id
      if jsn
        ele = @children().forItem(item, true)
        src = jsn.src
        img = new Image
        img.element = ele
        img.onload = @imageLoad
        img.src = src
        
  photos: (id) ->
    if Album.record
      Album.record.photos()
    else if id
      Album.photos(id)
    else
      Photo.all()
    
  imageLoad: ->
    css = 'url(' + @src + ')'
    $('.thumbnail', @element).css
      'backgroundImage': css  
    
    
  #  ****** START SLIDESHOW SPECIFICS *****
  
  modalParams: ->
    width: 600
    height: 451
    force: false
    
  loadModal: (items, mode='html') ->
    Photo.uri @modalParams(),
      (xhr, record) => @callbackModal(xhr, items),
      @photos()
  
  callbackModal: (json, items) ->
    console.log 'Slideshow::callbackModal'
    searchJSON = (id) ->
      for itm in json
        return itm[id] if itm[id]
        
    for item in items
      jsn = searchJSON item.id
      if jsn
        el = @children().forItem(item)
        a = $('<a></a>').attr
          'data-href'             : jsn.src
          'title'                 : item.title or item.src
          'data-iso'              : item.iso or ''
          'data-captured'         : item.captured or ''
          'data-description'      : item.description or ''
          'data-model'            : item.model or ''
          'rel'                   : 'gallery'
        $('.play', el).append a
        
    
  #  ****** END ***** 
  
  exposeSelection: ->
    console.log 'PhotosList::exposeSelection'
    @deselect()
    list = Album.selectionList()
    for id in list
      if photo = Photo.exists(id)
        el = @children().forItem(photo, true)
        el.addClass("active")
        if Photo.record.id is photo.id
          el.addClass("hot")
        
#    Spine.trigger('expose:sublistSelection', Gallery.record)
  
  activate: (items=Album.selectionList(), toggle) ->
    id = null
    items = items or []
    items = [items] unless Photo.isArray items
      
    id = items[0]
          
    if id
      App.sidebar.list.expand(Gallery.record, true)
      
    Photo.current(id)
    @exposeSelection()
      
  select: (items = [], exclusive) ->
    unless Spine.isArray items
      items = [items]
    
    list = []
    for item in items
      exists = Album.selectionList().indexOf(item.id) isnt -1
      if !Photo.record and Album.selectionList().length and exists
        list = item.shiftSelection() if exists
      else
        list = item.addRemoveSelection(exclusive)
        
      
    Photo.trigger('activate', list[0], true)
  
  remove: (ap) ->
    item = Photo.exists ap.photo_id
    @findModelElement(item).remove() if item
    
  deletePhoto: (e) ->
    console.log 'PhotosList::deletePhoto'
    item = $(e.currentTarget).item()
    return unless item?.constructor?.className is 'Photo' 
    
    el = @findModelElement item
    el.removeClass('in')
    
    
    window.setTimeout( =>
      Spine.trigger('destroy:photo', [item.id])
    , 300)
    
    @stopInfo(e)
    
    e.stopPropagation()
    e.preventDefault()
    
  click: (e) ->
    console.log 'PhotosList::click'
    item = $(e.currentTarget).item()
    
    @select item, @isCtrlClick(e)
    App.showView.trigger('change:toolbarOne')
    
    e.stopPropagation() if $(e.target).hasClass('thumbnail')
  
  zoom: (e) ->
    item = $(e?.currentTarget).item() || @current
    @select item, true
    @stopInfo(e)
    @navigate '/gallery', (Gallery.record?.id or 'nope'), (Album.record?.id or 'nope'), item.id
    
    e.stopPropagation()
    e.preventDefault()
  
  back: (e) ->
    @navigate '/gallery', Gallery.record.id
    
    e.stopPropagation()
    e.preventDefault()
  
  initSelectable: ->
    options =
      helper: 'clone'
    @el.selectable()
    
  infoUp: (e) =>
    @info.up(e)
    el = $('.glyphicon-set' , $(e.currentTarget)).addClass('in').removeClass('out')
    e.preventDefault()
    
  infoBye: (e) =>
    @info.bye(e)
    el = $('.glyphicon-set' , $(e.currentTarget)).addClass('out').removeClass('in')
    e.preventDefault()
    
  stopInfo: (e) =>
    @info.bye(e)
    
  infoEnter: (e) ->
    
  infoMove: (e) ->
    
  sliderStart: =>
    @refreshElements()
    
  size: (val, bg='none') ->
    # 2*10 = border radius
    @thumb.css
      'height'          : val+'px'
      'width'           : val+'px'
      'backgroundSize'  : bg
    
module?.exports = PhotosList