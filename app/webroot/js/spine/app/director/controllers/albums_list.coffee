Spine ?= require("spine")
$      = Spine.$

class AlbumsList extends Spine.Controller
  
  events:
    'click .item'             : 'click'
    'click .icon-set .delete' : 'deleteAlbum'
    'click .icon-set .zoom'   : 'zoom'
    'mouseenter .item'        : 'infoEnter'
    'mousemove'               : 'infoMove'
    'mousemove .item'         : 'infoUp'
    'mouseleave .item'        : 'infoBye'
    'dragstart .item'         : 'stopInfo'
    
  constructor: ->
    super
    # initialize flickr's slideshow
#    @el.toggleSlideshow()
    Spine.bind('album:activate', @proxy @activate)
    Photo.bind('refresh', @proxy @refreshBackgrounds)
    Album.bind('change', @proxy @update)
    Album.bind('sortupdate', @proxy @sortupdate)
    Album.bind("ajaxError", Album.errorHandler)
    AlbumsPhoto.bind('beforeDestroy', @proxy @widowedAlbumsPhoto)
    AlbumsPhoto.bind('destroy create', @proxy @updateBackgrounds)
    GalleriesAlbum.bind('destroy', @proxy @sortupdate)
    GalleriesAlbum.bind('change', @proxy @renderRelatedAlbum)
    
  template: -> arguments[0]
  
  change: (items, mode) ->
    @renderBackgrounds items
    
  update: (item, mode) ->
    console.log 'AlbumsList::update'
    el = =>
      @children().forItem(item, true unless mode is 'update')
    tb = ->
      $('.thumbnail', el())
    
    #Spine triggers 'update' also on new items
    return unless el().length
    
    active = el().hasClass('active')
    css = el().attr('style')
    tmplItem = el().tmplItem()
    tmplItem.tmpl = $( "#albumsTemplate" ).template()
    tmplItem.update()
    el().toggleClass('active', active)
    el().attr('style', css)
    @refreshElements()
  
  renderRelatedAlbum: (item, mode) ->
    return unless album = Album.exists(item['album_id'])
    albumEl = @children().forItem(album, true)
    
    switch mode
      when 'create'
        # caution! watch out for the correct gallery
        return unless item.gallery_id is Gallery.record.id
        # clear screen for first element
        if gallery = Gallery.record
          @el.empty() if gallery.contains() is 1

        @append @template album
        
      when 'update'
        @updateTemplate album
        
      when 'destroy'
        albumEl.remove()
        if gallery = Gallery.record
          unless @el.children().length
            @parent.render() unless gallery.contains()
          
    @exposeSelection()
    @el
  
  render: (items=[], mode) ->
    console.log 'AlbumsList::render'
      
    if items.length
      @html @template items
    else
      if Album.count()
        @html '<label class="invite"><span class="enlightened">This Gallery has no albums. &nbsp;<button class="optCreateAlbum dark large">New Album</button><button class="optShowAllAlbums dark large">Show existing Albums</button></span></label>'
      else
        @html '<label class="invite"><span class="enlightened">Time to create a new album. &nbsp;<button class="optCreateAlbum dark large">New Album</button></span></label>'
    
    
    @change items, mode
    @el
  
  updateTemplate: ->
    
  exposeSelection: ->
    list = Gallery.selectionList()
    list.push Album.record.id if !list.length and Album.record
    @deselect()
    for id in list
      if item = Album.exists(id)
        el = @children().forItem(item, true)
        el.addClass("active")
        
    Spine.trigger('expose:sublistSelection', Gallery.record)
  
  activate: (id) ->
    selection = Gallery.selectionList()
    return unless Spine.isArray selection
    
    if selection.length
      last = Album.exists(selection[selection.length-1])
      unless last?.destroyed
        Album.current(last)
    if id and Album.exists(id)
      Album.current(id)
    else
      Album.current()
      
    @exposeSelection()
  
  select: (item, lonely) ->
    it = item?.addRemoveSelection(lonely)
    Spine.trigger('album:activate')
    
  zoom: (e) ->
    item = $(e.currentTarget).item()
    
    @select(item, true)
    @stopInfo()
    @navigate '/gallery', (Gallery.record?.id or ''), item.id
    
    e.stopPropagation()
    e.preventDefault()
  
  updateBackgrounds: (ap, mode) ->
    console.log 'AlbumsList::updateBackgrounds'
    albums = ap.albums()
    @renderBackgrounds albums
    
  refreshBackgrounds: (photos) ->
    album = App.upload.album
    @renderBackgrounds [album] if album
  
  # remember the AlbumPhoto before it gets deleted (needed to remove widowed photo thumbnails)
  widowedAlbumsPhoto: (ap) ->
    @widows = ap.albums()
  
  renderBackgrounds: (albums) ->
    return unless App.ready
    if albums.length
      for album in albums
        @processAlbum album
    else if @widows?.length
      @processAlbum album for album in @widows
      @widows = []
  
  processAlbum: (album) ->
    return unless album?.contains?()
    data = album.photos(4)
      
    Photo.uri
      width: 50
      height: 50,
      (xhr, rec) => @callback(xhr, album)
      data
      
  callback: (json, album) =>
    console.log 'AlbumsList::callback'
    el = @children().forItem(album)
    
    search = (o) ->
      for key, val of o
        return o[key].src
    
    res = []
    for jsn in json
      res.push search(jsn)
      
    css = for itm in res
      'url(' + itm + ')'
    el.css('backgroundImage', css)
  
  click: (e) ->
    console.log 'AlbumsList::click'
    item = $(e.currentTarget).item()
    
    @select(item, @isCtrlClick(e))
    
    e.stopPropagation()
    e.preventDefault()

  loadtest: (t) ->
    test = $('.item', @el).each ->
      len = $(@).data('queue')
      if len and len.length
        return true
      else
        return false 

  deleteAlbum: (e) ->
    item = $(e.currentTarget).item()
    return unless item?.constructor?.className is 'Album'
    Gallery.updateSelection item.id
    
    el = $(e.currentTarget).parents('.item')
    el.removeClass('in')
    
    @stopInfo()
    
    window.setTimeout( =>
      Spine.trigger('destroy:album')
      el.remove()
    , 200)
    
    
    e.stopPropagation()
    e.preventDefault()
    
  sortupdate: (e, item) ->
    @children().each (index) ->
      item = $(@).item()
      if item and Gallery.record
        ga = GalleriesAlbum.filter(item.id, func: 'selectAlbum')[0]
        if ga and ga.order isnt index
          ga.order = index
          ga.save()
      else if item
        album = (Album.filter(item.id, func: 'selectAlbum'))[0]
        album.order = index
        album.save()
        
    @exposeSelection()
    
  infoUp: (e) =>
    @info.up(e)
    el = $('.icon-set' , $(e.currentTarget)).addClass('in').removeClass('out')
    e.preventDefault()
    
  infoBye: (e) =>
    @info.bye()
    el = $('.icon-set' , $(e.currentTarget)).addClass('out').removeClass('in')
    e.preventDefault()
    
  stopInfo: (e) =>
    @info.bye()
    
  infoEnter: (e) ->
#    el = $(e.target).find('.more-icon')
#    el.addClass('infast')
    
  infoMove: (e) ->
#    return unless $(e.target).hasClass('items')
#    el = $(e.target).find('.more-icon')
#    el.removeClass('in')

module?.exports = AlbumsList