Spine           = require('spine')
$               = Spine.$
Album           = require('models/album')
Gallery         = require('models/gallery')
GalleriesAlbum  = require('models/galleries_album')
Extender        = require('plugins/controller_extender')

class ActionWindow extends Spine.Controller

  @extend Extender

  elements:
    'form'        : 'form'
    '.galleries'  : 'galleriesEl'
    '.albums'     : 'albumsEl'

  events:
    'click .previous'                   : 'prevClick'
    'click .next'                       : 'nextClick'
    'click .item:not(.disabled)'        : 'click'
    'submit form'                       : 'startActionCopy'

  constructor: ->
    super
    @visible = false
    @maxItemsInPage = 5
    @curPage = 0
    @modal = $('#modal-action').modal
      show: @visible
      backdrop: true
    @modal.bind('shown.bs.modal', @proxy @setStatus)
    @modal.bind('hide.bs.modal', @proxy @setStatus)
    @renderTypeList = ['Gallery', 'Album']
    @renderType = @renderTypeList[0]
    @render()
#    Gallery.bind('create', @proxy @galleryCreated)
#    Album.bind('activate', @proxy @albumCreated)
  
  template: (items) ->
    $("#modalActionTemplate").tmpl(items)
    
  colTemplate: (items) ->
    $("#modalActionColTemplate").tmpl(items)
    
  render: ->
    return if @renderTypeList.indexOf(@renderType) is -1
#    console.log @el.modal()
    
#    pages = @getPages(@items)
    @html @template
      text: 'Select ' + @renderType
      galleries: => []
      albums: => []
      type: @renderType
      min: 0#@curPage is 0
      max: 0#@curPage+1 >= @items.length/@maxItemsInPage
    @renderGalleries Gallery.records.sort Gallery.nameSort
#    @renderAlbums Gallery.albums(Gallery.record.cid).sort Album.nameSort
    if @renderType is 'Gallery'
      @albumsEl.children().addClass('disabled')
    @el
  
  renderAlbums: (items) ->
    @albumsEl.html @colTemplate items
    activeAlbum = Album.toRecords(Gallery.selectionList())[0]
    @albumsEl.children().forItem(activeAlbum).addClass('active') if activeAlbum
    @albumsEl
    
  renderGalleries: (items) ->
    @galleriesEl.html @colTemplate items
    el = @galleriesEl.children('#'+Gallery.record.id)
    el.addClass('active').click() if Gallery.record
    @galleriesEl
  
  getPages: ->
    start: @curPage*@maxItemsInPage
    end: @curPage*@maxItemsInPage+@maxItemsInPage-1
    cur: @curPage
  
  nextPage: ->
    return @curPage unless @curPage+1 < @items.length/@maxItemsInPage
    ++@curPage
  
  prevPage: (arr) ->
    return @curPage unless @curPage-1 >= 0
    --@curPage
  
  click: (e) ->
    console.log 'click'
    e.stopPropagation()
    e.preventDefault()
    
    el = $(e.currentTarget)
    el.parent().deselect()
    el.addClass('active')
    item = el.item()
    type = item.constructor.className
    switch type
      when 'Gallery'
        items = Gallery.albums(item.id).sort Album.nameSort
        Gallery.trigger('activate', item)
        @renderAlbums items
        if @renderType is 'Gallery'
          @albumsEl.children().addClass('disabled')
      when 'Album'
        Album.trigger('activate', item)
    
  prevClick: (e) ->
    e.stopPropagation()
    e.preventDefault()
    @prevPage()
    @render()
    
  nextClick: (e) ->
    e.stopPropagation()
    e.preventDefault()
    @nextPage(Gallery.records)
    @render()
  
  setRenderType: (type) ->
    @renderType = type
  
  setStatus: (sts) ->
    switch sts.type
      when 'shown'
        @visible = true
      when 'hide'
        @visible = false
    return true
  
  open: (type, list) ->
    @clipBoard = list
    @setRenderType type
    @render()
    @el.modal('show')
    
  close: ->
    @curPage  = 0
    @el.modal('hide')
    
  toggle: ->
    @el.modal('toggle')
    @render() if @visible is true
    
  startActionCopy: (e) ->
    e.stopPropagation()
    e.preventDefault()
    @['actionCopyTo' + @renderType]()
  
  actionCopyToGallery: ->
    checkbox = $('.remove[type=checkbox]', @form)
    remove = checkbox[0].checked
    gallery = $('.galleries .active', @form).item()
    
    if gallery
      Spine.trigger('albums:copy', @clipBoard, gallery)
      # open edit-panel
      App.showView.btnAlbum.click()
      @close()

    
  actionCopyToAlbum: ->
    checkbox = $('.remove[type=checkbox]', @form)
    remove = checkbox[0].checked
    
    gallery = $('.galleries .active', @form).item()
    album = $('.albums .active', @form).item()
    
    if album
      Spine.trigger('photos:copy', @clipBoard, gallery, album)
      # open edit-panel
      App.showView.btnAlbum.click()
      @close()

  albumCreated: (album) ->
    albums = Gallery.albums()
    @renderAlbums(albums)
    
  galleryCreated: (gal) ->
    Gallery.trigger('activate', gal.id or gal.cid)
    @renderGalleries(Gallery.records)
    
module.exports = ActionWindow