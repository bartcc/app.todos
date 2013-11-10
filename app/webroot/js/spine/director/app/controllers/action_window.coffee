Spine   = require('spine')
$       = Spine.$
Album = require('models/album')
Gallery = require('models/gallery')

class ActionWindow extends Spine.Controller

  elements:
    'form'  : 'form'

  events:
    'click .previous'    : 'prevClick'
    'click .next'        : 'nextClick'
#    'click .copy'        : 'startAlbumActionCopy'
    'submit form'        : 'startPhotoActionCopy'

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
    @currentRenderType = @renderTypeList[0]
    @render()
  
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
    @currentRenderType = type
  
  setStatus: (sts) ->
    switch sts.type
      when 'shown'
        @visible = true
      when 'hide'
        @visible = false
    return true
  
  template: (items) ->
    $("#modalActionTemplate").tmpl(items)
    
  render: ->
    return if @renderTypeList.indexOf(@currentRenderType) is -1
    t = {}
    gItems = Gallery.records
    gItems = gItems.sort Gallery.nameSort
    aItems = Album.records
    aItems = aItems.sort Album.nameSort
    t['Gallery'] = gItems
    t['Album'] = aItems
      
    @items = t[@currentRenderType]
    pages = @getPages(@items)
    @html @template
      text: 'Select ' + @currentRenderType
      items: => @items[pages.start..pages.end]
      min: @curPage is 0
      max: @curPage+1 >= @items.length/@maxItemsInPage
    @el
  
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
    
  startPhotoActionCopy: (e) ->
    e.stopPropagation()
    e.preventDefault()
    @close()
    res = []
    checkbox = $('.remove[type=checkbox]', @form)
    remove = checkbox[0].checked
    for input in $(@form).find('.active [type=radio]')
      res.push $(input).attr('id')
    if gallery = Gallery.exists res[0]
      albums = Gallery.selectionList()
      for id in albums
        if album = Album.exists id
          photos = album.photos()
#    Spine.photoCopyList = Album.toID(photos)
          App.showView.copyPhotosToNewAlbum(photos, gallery)
#          console.log album
#          console.log photos
#          console.log target
#    return
    
#    res = []
#    for input in $(@form).find('.active [type=radio]')
#      res.push $(input).attr('id')
#    if gallery = Gallery.exists res[0]
    App.showView.btnAlbum.click()
    
module.exports = ActionWindow