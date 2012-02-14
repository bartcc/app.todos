Spine ?= require("spine")
$      = Spine.$

class UploadEditView extends Spine.Controller

#  @extend Spine.Controller.Drag
  
  elements:
    '#fileupload'                 : 'uploader'
    '.files'                      : 'filesEl'
    '.uploadinfo'                 : 'uploadinfoEl'

  events:
    'change select'               : 'changeSelected'
    'fileuploaddone'              : 'done'
    'fileuploadsubmit'            : 'submit'
    'fileuploadadd'               : 'add'
    
  template: (item) ->
    $('#fileuploadTemplate').tmpl item
    
  constructor: ->
    super
    @bind("change", @change)
    Album.bind('change', @proxy @change)
    Spine.bind('change:selectedAlbum', @proxy @change)
    
  change: (item) ->
    @render()
    
  render: ->
    console.log 'UploadView::render'
    selection = Gallery.selectionList()
    gallery = Gallery.record
    @album = Album.record
    @uploadinfoEl.html @template
      gallery: gallery
      album: @album
    @refreshElements()
    @el
    
  add: (e, data) ->
#    if data.files.length
#      @openPanel('upload', App.showView.btnUpload)
    e.preventDefault()
    e.stopPropagation()
    
  done: (e, data) ->
    console.log 'UploadView::done'
    photos = $.parseJSON(data.jqXHR.responseText)
    Photo.refresh(photos, clear: false)
    Spine.trigger('album:updateBuffer', @album)
    
  submit: (e, data) ->
    console.log 'UploadView::submit'
    
  changeSelected: (e) ->
    el = $(e.currentTarget)
    id = el.val()
    album = Album.find(id)
    album.updateSelection [album.id]
    Spine.trigger('album:activate')
    
module?.exports = UploadEditView