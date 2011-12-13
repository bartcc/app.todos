Spine ?= require("spine")
$      = Spine.$

class UploadEditView extends Spine.Controller

  events:
    'click'           : 'click'
    'fileuploadadd'   : 'add'
    'fileuploaddone'  : 'done'
    'fileuploadsubmit': 'submit'
    
  template: (item) ->
    $('#fileuploadTemplate').tmpl item
    
  constructor: ->
    super
    @bind("change", @change)
    Album.bind('change', @proxy @render)
    Spine.bind('change:selectedAlbum', @proxy @render)
    Spine.bind('change:selectedGallery', @proxy @render)
    Gallery.bind('refresh', @proxy @render)
    
  render: ->
    console.log 'UploadView::render'
    selection = Gallery.selectionList()
    gallery = Gallery.record
    album = Album.find(selection[0]) if Album.exists(selection[0])
    if (!@current?.eql album)
      @html @template
        gallery: gallery
        album: album
      @current = album
    
  add: (e, data) ->
    console.log 'UploadView::add'
    
  done: (e, data) ->
    console.log 'UploadView::done'
    photos = $.parseJSON(data.jqXHR.responseText)
    
    Photo.refresh(photos, clear: false)
    
  submit: (e, data) ->
    console.log 'UploadView::submit'
    
  click: (e) ->
    console.log 'click'
    
    e.stopPropagation()
    e.preventDefault()
    false
    
module?.exports = UploadEditView