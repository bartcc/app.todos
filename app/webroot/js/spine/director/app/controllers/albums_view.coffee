Spine           = require("spine")
$               = Spine.$
Controller      = Spine.Controller
Drag            = require("plugins/drag")
User            = require("models/user")
Album           = require('models/album')
Gallery         = require('models/gallery')
GalleriesAlbum  = require('models/galleries_album')
AlbumsPhoto     = require('models/albums_photo')
Info            = require('controllers/info')
AlbumsList      = require('controllers/albums_list')
Extender        = require("plugins/controller_extender")
User            = require('models/user')

require("plugins/tmpl")

class AlbumsView extends Spine.Controller
  
  @extend Drag
  @extend Extender
  
  elements:
    '.hoverinfo'                      : 'infoEl'
    '.header .hoverinfo'              : 'headerEl'
    '.items'                          : 'itemsEl'
    
  events:
    'click      .item'                : 'click'
    
    'dragstart .item'                 : 'dragstart'
    'dragstart'                       : 'stopInfo'
    'drop .item'                      : 'drop'
    'dragover   .item'                : 'dragover'
    
    'sortupdate .items'               : 'sortupdate'
    'mousemove .item'                 : 'infoUp'
    'mouseleave .item'                : 'infoBye'
    
  albumsTemplate: (items, options) ->
    templ = $("#albumsTemplate").tmpl items, options
    
#  toolsTemplate: (items) ->
#    $("#toolsTemplate").tmpl items
#
  headerTemplate: (items) ->
    $("#headerAlbumTemplate").tmpl items
 
  infoTemplate: (item) ->
    $('#albumInfoTemplate').tmpl item
 
  constructor: ->
    super
    @bind('active', @proxy @active)
    @trace = false
    @el.data('current',
      model: Gallery
      models: Album
    )
    @type = 'Album'
    @info = new Info
      el: @infoEl
      template: @infoTemplate
    @list = new AlbumsList
      el: @itemsEl
      template: @albumsTemplate
      parent: @
    @header.template = @headerTemplate
    @viewport = @list.el
#      joinTableItems: (query, options) -> Spine.Model['GalleriesAlbum'].filter(query, options)

    GalleriesAlbum.bind('beforeDestroy', @proxy @beforeDestroyGalleriesAlbum)
    GalleriesAlbum.bind('destroy', @proxy @destroyGalleriesAlbum)
    
#    Gallery.bind('change:collection', @proxy @collectionChanged)
    
    Album.bind('refresh:one', @proxy @refreshOne)
    Album.bind('ajaxError', Album.errorHandler)
    Album.bind('create', @proxy @create)
    Album.bind('beforeDestroy', @proxy @beforeDestroyAlbum)
    Album.bind('destroy', @proxy @destroy)
    Album.bind('create:join', @proxy @createJoin)
    Album.bind('destroy:join', @proxy @destroyJoin)
    Album.bind('activate', @proxy @activateRecord)
    Album.bind('change:collection', @proxy @renderBackgrounds)
    
    Photo.bind('refresh', @proxy @refreshBackgrounds)
    
    AlbumsPhoto.bind('destroy create', @proxy @updateBackgrounds)
    
#    GalleriesAlbum.bind('ajaxError', Album.errorHandler)
    
    Spine.bind('reorder', @proxy @reorder)
    Spine.bind('create:album', @proxy @createAlbum)
    Spine.bind('loading:start', @proxy @loadingStart)
    Spine.bind('loading:done', @proxy @loadingDone)
    Spine.bind('loading:fail', @proxy @loadingFail)
    Spine.bind('destroy:album', @proxy @destroyAlbum)
    
    @bind('drag:start', @proxy @dragStart)
    @bind('drag:help', @proxy @dragHelp)
    @bind('drag:drop', @proxy @dragDrop)
    
    $(@views).queue('fx')
    
  refreshOne: ->
    Album.one('refresh', @proxy @refresh)
    
  refresh: ->
    @updateBuffer()
    @render @buffer, 'html'
    
  updateBuffer: (gallery=Gallery.record) ->
    filterOptions =
      model: 'Gallery'
      key: 'gallery_id'
      sorted: 'sortByOrder'
    
    if gallery
      items = Album.filterRelated(gallery.id, filterOptions)
    else
      items = Album.filter()
    
    @buffer = items
    
  render: (items, mode='html') ->
    return unless @isActive()
    @list.render(items || @updateBuffer(), mode)
    @list.sortable('album') if Gallery.record
#    $('.tooltips', @el).tooltip(title:'default title')
    delete @buffer
    @el
      
  active: ->
    return unless @isActive()
    App.showView.trigger('change:toolbarOne', ['Default', 'Help'])
    App.showView.trigger('change:toolbarTwo', ['Slideshow'])
    
    albums = GalleriesAlbum.albums(Gallery.record.id)
    for alb in albums
      if alb.invalid
        alb.invalid = false
        alb.save(ajax:false)
        
    @refresh()
    @parent.scrollTo(@el.data('current').models.record)
    
  collectionChanged: ->
    unless @isActive()
      @navigate '/gallery', Gallery.record?.id or ''
      
  activateRecord: (records) ->
    unless records
      records = Gallery.selectionList()
      Album.current()
      noid = true
      
    unless Spine.isArray(records)
      records = [records]
    
    list = []
    for id_ in records
      list.push album.id if album = Album.find(id_)

    id = list[0]

    App.sidebar.list.expand(Gallery.record, true) if id
    Gallery.updateSelection(Gallery.record?.id, list)
    Album.current(id) unless noid
    if Album.record
      Photo.trigger('activate', Album.selectionList())
    else
      Photo.trigger('activate')
      
  newAttributes: ->
    if User.first()
      title   : @albumName()
      author  : User.first().name
      invalid : false
      user_id : User.first().id
      order   : Album.count()
    else
      User.ping()
  
  albumName: (proposal = 'Album ' + (->
    s = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
    index = if (i = Album.count()+1) < s.length then i else (i % s.length)
    s.split('')[index])()) ->
    Album.each (record) =>
      if record.title is proposal
        return proposal = @albumName(proposal + proposal.split(' ')[1][0])
    return proposal
  
  createAlbum: (target=Gallery.record, options={}) ->
    cb = (album, ido) ->
      if target
        album.createJoin(target)
        target.updateSelection(album.id)
      else
        Gallery.updateSelection(Gallery.record?.id, album.id)
        
      album.updateSelectionID()
      
      # fill in / remove photos
      $().extend options, album: album
      if options.photos
        Photo.trigger('create:join', options, false)
        Photo.trigger('destroy:join', options.photos, options.deleteFromOrigin) if options.deleteFromOrigin
        
      Album.trigger('change:collection', album)
      Album.trigger('activate', album.id)
      @navigate '/gallery', target?.id or ''
    
    album = new Album @newAttributes()
    album.one('ajaxSuccess', @proxy cb)
    album.save()
       
  beforeDestroyGalleriesAlbum: (ga) ->
    gallery = Gallery.find ga.gallery_id
    gallery.removeFromSelection ga.album_id if gallery
       
  destroyGalleriesAlbum: (ga) ->
    albums = GalleriesAlbum.albums ga.gallery_id
    @render(null, 'html') unless albums.length
       
  destroyAlbum: (ids) ->
    @log 'destroyAlbum'
  
    @stopInfo()
  
    func = (el) =>
      $(el).detach()
  
    albums = ids || Gallery.selectionList().slice(0)
    albums = [albums] unless Album.isArray(albums)
    
    for id in albums
      if item = Album.find(id)
        el = @list.findModelElement(item)
        el.removeClass('in')
      
#      setTimeout(func, 300, el)
    
    if gallery = Gallery.record
      @destroyJoin albums, Gallery.record
    else
      for id in albums
        album.destroy() if album = Album.find(id)
  
  create: (album) ->
    @render([album], 'append') unless Gallery.record 
   
  beforeDestroyAlbum: (album) ->
    
    # remove selection from root
    Gallery.removeFromSelection null, album.id
    
    # all involved galleries
    galleries = GalleriesAlbum.galleries(album.id)

    for gallery in galleries
      gallery.removeFromSelection album.id
      album.removeSelectionID()
      
#      @list.findModelElement(album).detach()
      
      # remove all associated albums
      @log album
      photos = AlbumsPhoto.photos(album.id).toID()
      Photo.trigger('destroy:join', photos, album)
      # remove all associated albums
      @destroyJoin album.id, gallery
   
  destroy: (item) ->
    item.removeSelectionID()
    el = @list.findModelElement(item)
    el.detach()
    @render() unless Album.count()
      
  createJoin: (albums, gallery, callback) ->
    @log 'createJoin'
    albums = albums.toID()
    Album.createJoin albums, gallery, callback
    gallery.updateSelection(albums)
    
  destroyJoin: (albums, gallery) ->
    @log 'destroyJoin'
    return unless gallery and gallery.constructor.className is 'Gallery'
    
    callback = ->
      
    albums = [albums] unless Album.isArray(albums)
    albums = albums.toID()
    
    selection = []
    for id in albums
      selection.addRemoveSelection id

    Album.destroyJoin albums, gallery, callback
      
  loadingStart: (album) ->
    return unless @isActive()
    return unless album
    el = @itemsEl.children().forItem(album)
    $('.glyphicon-set', el).addClass('in')
    $('.downloading', el).removeClass('hide').addClass('in')
    
  loadingDone: (album) ->
    return unless @isActive()
    return unless album
    el = @itemsEl.children().forItem(album)
    $('.glyphicon-set', el).removeClass('in')
    $('.downloading', el).removeClass('in').addClass('hide')
#    el.data('queue').queue.splice(0, 1)
  
  loadingFail: (album, error) ->
    return unless @isActive()
    err = error.errorThrown
    el = @itemsEl.children().forItem(album)
    $('.glyphicon-set', el).removeClass('in')
    $('.downloading', el).addClass('error').tooltip('destroy').tooltip(title:err).tooltip('show')
    
  renderBackgrounds: (albums) ->
    return unless @isActive()
    @list.renderBackgrounds albums
    
  updateBackgrounds: (ap, mode) ->
    return unless @isActive()
    @log 'updateBackgrounds'
    albums = ap.albums()
    @list.renderBackgrounds albums
    
  refreshBackgrounds: (photos) ->
    return unless @isActive()
    @log 'refreshBackgrounds'
    album = App.upload.album
    @list.renderBackgrounds [album] if album
    
  sortupdate: (e, o) ->
    return unless Gallery.record
    
    cb = -> Gallery.trigger('change:collection', Gallery.record)
      
    @list.children().each (index) ->
      item = $(@).item()
      if item
        ga = GalleriesAlbum.filter(item.id, func: 'selectAlbum')[0]
        if ga and parseInt(ga.order) isnt index
          ga.order = index
          ga.save(ajax:false)
          
    Gallery.record.save(done: cb)
    
  reorder: (gallery) ->
    if gallery.id is Gallery.record.id
      @render()
      
  click: (e) ->
    item = $(e.currentTarget).item()
    @select(item.id, @isCtrlClick(e))
    
  select: (items = [], exclusive) ->
    unless Spine.isArray items
      items = [items]
    Gallery.emptySelection() if exclusive
      
    selection = Gallery.selectionList()[..]
    for id in items
      selection.addRemoveSelection(id)
    
    Album.trigger('activate', selection[0])
    Gallery.updateSelection(Gallery.record?.id, selection)
    
  infoUp: (e) =>
    @info.up(e)
    el = $(e.currentTarget)
    $('.glyphicon-set' , el).addClass('in').removeClass('out')
    
  infoBye: (e) =>
    @info.bye(e)
    el = $(e.currentTarget)
    set = $('.glyphicon-set' , el).addClass('out').removeClass('in')
#    set.children('.open').removeClass('open')
    
  stopInfo: (e) =>
    @info.bye(e)
      
  dropComplete: (e) ->
    @log 'dropComplete'
        
module?.exports = AlbumsView