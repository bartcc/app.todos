Spine           = require("spine")
$               = Spine.$
Photo           = require('models/photo')
Album           = require('models/album')
AlbumsPhoto     = require('models/albums_photo')
ToolbarView     = require("controllers/toolbar_view")
Extender        = require('plugins/controller_extender')
Drag            = require("plugins/drag")

require("plugins/tmpl")

class PhotosList extends Spine.Controller
  
  @extend Drag
  @extend Extender
  
  elements:
    '.thumbnail'              : 'thumb'
    '.toolbar'                : 'toolbarEl'
    
  events:
    'click .opt-AddPhotos'         : 'add_'
    'click .glyphicon-set .back'   : 'back'
    'click .glyphicon-set .zoom'   : 'zoom'
    'click .glyphicon-set .delete' : 'deletePhoto'
    
    'mousemove .item'              : 'infoUp'
    'mouseleave  .item'            : 'infoBye'
    'dragstart .item'              : 'stopInfo'
    'dragstart'                    : 'dragstart'
    'dragover .item'               : 'dragover'
    
  selectFirst: true
    
  constructor: ->
    super
    
    @toolbar = new ToolbarView
      el: @toolbarEl
      
    @bind('drag:start', @proxy @dragStart)
    Photo.bind('activate', @proxy @activate)
    Spine.bind('slider:start', @proxy @sliderStart)
    Spine.bind('slider:change', @proxy @size)
    Photo.bind('update', @proxy @update)
#    Photo.bind("ajaxError", Photo.errorHandler)
    Album.bind("ajaxError", Album.errorHandler)
    AlbumsPhoto.bind('destroy', @proxy @remove)
    AlbumsPhoto.bind('change', @proxy @changeRelated)
    
  change: ->
    console.log 'PhotosList::change'
    
  changeRelated: (item, mode) ->
    console.log 'AlbumsList::changeRelatedAlbum'
    return unless @parent and @parent.isActive()
    return unless Album.record
    return unless Album.record.id is item['album_id']
    return unless photo = Photo.exists(item['photo_id'])
    
    switch mode
      when 'create'
        wipe = Album.record and Album.record.count() is 1
        @el.empty() if wipe
        @append @template photo
        @uri [photo]
        @activate photo.id
        @el.sortable('destroy').sortable()
        
      when 'destroy'
        photoEl = @children().forItem(photo, true)
        photoEl.detach()
        if album = Album.record
          @parent.render() unless album.count()
          
      when 'update'
        @el.sortable('destroy').sortable()
    
    @refreshElements()
    @el
    
  render: (items=[], mode) ->
    console.log 'PhotosList::render'
    
    if items.length
      @wipe()
      @html @template items
      @uri items, mode
    else if mode is 'add'
      @html '<h3 class="invite"><span class="enlightened">Nothing to add. &nbsp;</span></h3>'
      @append '<h3><label class="invite label label-default"><span class="enlightened">Either no more photos can be added or there is no album selected.</span></label></h3>'
    else 
      if Photo.count()
        @html '<label class="invite"><span class="enlightened">No photos here. &nbsp;<p>Simply drop your photos to your browser window</p><p>Note: You can also drag existing photos to a sidebars folder</p><button class="opt-AddPhotos dark large">Add existing photos</button></span></label>'
      else
        @html '<label class="invite"><span class="enlightened">No photos here. &nbsp;<p>Simply drop your photos to your browser window</p>'
      
    @activate()
    @el
  
  renderAll: ->
    console.log 'PhotosList::renderAll'
    items = Photo.all()
    if items.length
      @html @template items
      @activate()
      @uri items
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
    @el.sortable('destroy').sortable('photos') if Album.record
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
      @photos(mode)
  
  callback: (json = [], items) =>
    console.log 'PhotosList::callback'
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
        
  photos: (mode) ->
    if mode is 'add' or !Album.record
      Photo.all()
    else if album = Album.exists mode
      album.photos()
    else if Album.record
      Album.record.photos()
    
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
  
  exposeSelection: (selection) ->
    console.log 'PhotosList::exposeSelection'
    @deselect()
    list = selection or Album.selectionList()
    for id in list
      if photo = Photo.exists(id)
        el = @children().forItem(photo, true)
        el.addClass("active")
        if Photo.record.id is photo.id
          el.addClass("hot")
        
  activate: (items=Album.selectionList()) ->
    id = null
    unless Photo.isArray items
      unique = true
      items = [items]
    
    id = items[0]
    for item in items
      if photo = Photo.exists item
        photo.addToSelection(unique)
      
    Photo.current(id)
    @exposeSelection()
      
  remove: (ap) ->
    item = Photo.exists ap.photo_id
    @findModelElement(item).detach() if item
    
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
    
  zoom: (e) ->
    item = $(e?.currentTarget).item() || @current
    @parent.select item, true
    @stopInfo(e)
    @navigate '/gallery', (Gallery.record?.id or ''), (Album.record?.id or ''), item.id
    
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
    
  add_: (e) ->
    e.stopPropagation()
    e.preventDefault()
    
    Spine.trigger('photos:add')
    
  infoUp: (e) ->
    @info.up(e)
    el = $('.glyphicon-set' , $(e.currentTarget)).addClass('in').removeClass('out')
    
  infoBye: (e) ->
    @info.bye(e)
    el = $('.glyphicon-set' , $(e.currentTarget)).addClass('out').removeClass('in')
    
  stopInfo: (e) =>
    @info.bye(e)
    
  sliderStart: =>
    @refreshElements()
    
  size: (val, bg='none') ->
    # 2*10 = border radius
    @thumb.css
      'height'          : val+'px'
      'width'           : val+'px'
      'backgroundSize'  : bg
    
  dragStart: (e, o) ->
    if Album.selectionList().indexOf(Spine.dragItem.source.id) is -1
      @activate Spine.dragItem.source.id
    
module?.exports = PhotosList