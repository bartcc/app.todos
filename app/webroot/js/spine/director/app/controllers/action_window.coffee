Spine   = require('spine')
$       = Spine.$
Album   = require('models/album')
Gallery = require('models/gallery')
Extender= require('plugins/controller_extender')

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
  
  template: (items) ->
    $("#modalActionTemplate").tmpl(items)
    
  colTemplate: (items) ->
    $("#modalActionColTemplate").tmpl(items)
    
  render: ->
    return if @renderTypeList.indexOf(@renderType) is -1
    
#    pages = @getPages(@items)
    @html @template
      text: 'Select ' + @renderType
      galleries: => []
      albums: => []
      min: 0#@curPage is 0
      max: 0#@curPage+1 >= @items.length/@maxItemsInPage
    @renderAlbums Album.records.sort Album.nameSort
    @renderGalleries Gallery.records.sort Gallery.nameSort
    if @renderType is 'Gallery'
      @albumsEl.children().addClass('disabled')
    @el
  
  renderAlbums: (items) ->
    @albumsEl.html @colTemplate items
    @albumsEl
    
  renderGalleries: (items) ->
    @galleriesEl.html @colTemplate items
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
        @renderAlbums items
        if @renderType is 'Gallery'
          @albumsEl.children().addClass('disabled')
    
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
  
  open: (type) ->
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
      @close()
      albums = Gallery.selectionList()
      for id in albums
        if album = Album.exists id
          photos = album.photos()
          App.showView.copyPhotosToNewAlbum(photos, gallery)
      # open edit-panel
      App.showView.btnAlbum.click()

    
  actionCopyToAlbum: ->
    checkbox = $('.remove[type=checkbox]', @form)
    remove = checkbox[0].checked
    
    gallery = $('.galleries .active', @form).item()
    album = $('.albums .active', @form).item()
    photos = Photo.toRecords Album.selectionList()
    
    if album
      App.showView.copyPhotosToAlbum(photos, album, gallery)
      # open edit-panel
      App.showView.btnAlbum.click()
      @close()

    
module.exports = ActionWindow