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
    'click .opt-AddPhotos'         : 'addPhotos'
    'click .glyphicon-set .back'   : 'back'
    'click .glyphicon-set .zoom'   : 'zoom'
    'click .glyphicon-set .delete' : 'deletePhoto'
    
  selectFirst: true
    
  constructor: ->
    super
    
    @toolbar = new ToolbarView
      el: @toolbarEl
    @add = @html
    Spine.bind('slider:start', @proxy @sliderStart)
    Spine.bind('slider:change', @proxy @size)
    Photo.bind('update', @proxy @update)
    Album.bind("ajaxError", Album.errorHandler)
    Album.bind("change:selection", @proxy @exposeSelection)
    AlbumsPhoto.bind('change', @proxy @changeRelated)
    
  changeRelated: (item, mode) ->
    return unless @parent.isActive()
    return unless Album.record
    return unless Album.record.id is item['album_id']
    return unless photo = Photo.exists(item['photo_id'])
    console.log 'PhotosList::changeRelated'
    
    switch mode
      when 'create'
        @wipe()
        @append @template photo
        @callDeferred [photo]
        @size(App.showView.sOutValue)
        @el.sortable('destroy').sortable()
        
      when 'destroy'
        el = @findModelElement(photo)
        el.detach()
          
      when 'update'
        @el.sortable('destroy').sortable()
    
    @refreshElements()
    @el
    
  render: (items=[], mode) ->
    console.log 'PhotosList::render ' + mode
    
    if items.length
      @wipe()
      @[mode] @template items
      @callDeferred items
      @size(App.showView.sOutValue)
      @exposeSelection()
    else if mode is 'add'
      @html '<h3 class="invite"><span class="enlightened">Nothing to add. &nbsp;</span></h3>'
      @append '<h3><label class="invite label label-default"><span class="enlightened">Either no more photos can be added or there is no album selected.</span></label></h3>'
    else 
      if Photo.count()
        @html '<label class="invite"><span class="enlightened">No photos here. &nbsp;<p>Simply drop your photos to your browser window</p><p>Note: You can also drag existing photos to a sidebars folder</p><button class="opt-AddPhotos dark large">Add existing photos</button></span></label>'
      else
        @html '<label class="invite"><span class="enlightened">No photos here. &nbsp;<p>Simply drop your photos to your browser window</p>'
      
    @el
  
  renderAll: ->
    console.log 'PhotosList::renderAll'
    items = Photo.all()
    if items.length
      @html @template items
      @activateRecord()
      @callDeferred  items
      @size(App.showView.sOutValue)
    @el
  
  wipe: ->
    if Album.record
      first = Album.record.count() is 1
    else
      first = Photo.count() is 1
    @el.empty() if first
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
    
    Photo.uri @thumbSize(),
      (xhr, record) => @callback(xhr, items),
      items
  
  callDeferred: (items) ->
    $.when(@uriDeferred(items)).done (xhr, rec) =>
      @callback xhr, rec
  
  uriDeferred: (items) ->
    console.log 'PhotosList::uri'
    deferred = $.Deferred()
    
    Photo.uri @thumbSize(),
      (xhr, record) => deferred.resolve(xhr, items)
      items
      
    deferred.promise()
  
  callback: (json, items) =>
    console.log 'PhotosList::callback'
    
    result = for jsn in json
      ret = for key, val of jsn
        src: jsn[key].src
        id: key
      ret[0]
    
    for res in result
      el = $('#'+res.id, @el)
      img = @createImage res.src
      img.src = res.src
      img.element = el
      img.onload = @imageLoad
        
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
      'backgroundSize': '100% auto'
    
    
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
  
  exposeSelection: (item=Album.record, sel) ->
    console.log 'PhotosList::exposeSelection'
    
    if Album.record
      if item then return unless Album.record.id is item.id
    else
      return if item
      
    item = item or Album
    selection = sel or item.selectionList()
      
    @deselect()
    for id in selection
      $('#'+id, @el).addClass("active")
    if first = selection.first()
      $('#'+first, @el).addClass("hot")
      
  remove: (ap) ->
    item = Photo.exists ap.photo_id
    @findModelElement(item).detach() if item
    
  deletePhoto: (e) ->
    console.log 'PhotosList::deletePhoto'
    item = $(e.currentTarget).item()
    return unless item?.constructor?.className is 'Photo' 
    
    Spine.trigger('destroy:photo', [item.id])
    
    e.stopPropagation()
    e.preventDefault()
    
  zoom: (e) ->
    item = $(e.currentTarget).item()
    @navigate '/gallery', Gallery.record?.id or '', Album.record?.id or '', item.id
    e.preventDefault()
    e.stopPropagation()
    
  back: (e) ->
    @navigate '/gallery', Gallery.record.id
    e.stopPropagation()
    e.preventDefault()
    
  initSelectable: ->
    options =
      helper: 'clone'
    @el.selectable()
    
  addPhotos: (e) ->
    e.stopPropagation()
    e.preventDefault()
    
    Spine.trigger('photos:add')
    
  sliderStart: ->
    @refreshElements()
    
  size: (val, bg='none') ->
    # 2*10 = border radius
    @thumb.css
      'height'          : val+'px'
      'width'           : val+'px'
      'backgroundSize'  : bg
    
module?.exports = PhotosList