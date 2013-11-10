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
  
  prevClick: ->
    @prevPage()
    @render()
    
  nextClick: ->
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
    t['Gallery'] = Gallery.records
    t['Album'] = Album.records
      
    arr = t[@currentRenderType]
    pages = @getPages(arr)
    @html @template
      text: 'Select ' + @currentRenderType
      items: -> arr[pages.start..pages.end]
      min: @curPage is 0
      max: @curPage+1 >= arr.length/@maxItemsInPage
    @el
  
  getPages: ->
    start: @curPage*@maxItemsInPage
    end: @curPage*@maxItemsInPage+@maxItemsInPage-1
    cur: @curPage
  
  nextPage: (arr) ->
    return @curPage unless @curPage+1 < arr.length/@maxItemsInPage
    ++@curPage
  
  prevPage: (arr) ->
    return @curPage unless @curPage-1 >= 0
    --@curPage
  
  open: (type) ->
    @setRenderType type
    @render()
    @el.modal('show')
    
  close: ->
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