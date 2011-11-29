class UploadView extends Spine.Controller

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
#    Spine.bind('change:selectedAlbum', @proxy @render)
    Gallery.bind('change:selection', @proxy @render)
    
  render: (selection) ->
    console.log 'UploadView::render'
    album = Album.find(selection[0]) if Album.exists(selection[0])
    isAlbum = album instanceof Album
    @html @template album: isAlbum
    @refreshElements()
    
  add: (e, data) ->
    console.log 'UploadView::add'
    
  done: (e, data) ->
    console.log 'UploadView::done'
    photos = $.parseJSON(data.jqXHR.responseText)
    
    Photo.refresh(photos, {clear: false})
    
  submit: (e, data) ->
    console.log 'UploadView::submit'
    
  click: (e) ->
    console.log 'click'
    
    e.stopPropagation()
    e.preventDefault()
    false