class UploadView extends Spine.Controller

  events:
    "click .item": "click"
    'fileuploadadd' : 'add'
    'fileuploaddone' : 'done'
    'fileuploadsubmit' : 'submit'
    
  constructor: ->
    super
    @bind("change", @change)
    
  add: (e, data) ->
    console.log 'UploadView::add'
    
  done: (e, data) ->
    console.log 'UploadView::done'
    photos = $.parseJSON(data.jqXHR.responseText)
    
    Photo.refresh(photos, {clear: false})
    
  submit: (e, data) ->
    console.log 'UploadView::submit'
    console.log data