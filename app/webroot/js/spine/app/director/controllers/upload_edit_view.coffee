Spine ?= require("spine")
$      = Spine.$

class UploadEditView extends Spine.Controller

  elements:
    '#fileupload'                 : 'uploadEl'
    '#fileupload .files'          : 'filesEl'

  events:
    'click'                       : 'click'
    'fileuploadadd #fileupload'   : 'add'
    'fileuploaddone #fileupload'  : 'done'
    'fileuploadsubmit #fileupload': 'submit'
    'change select'               : 'changeSelected'
    'fileuploadsend #fileupload'  : 'fileuploadsend'
    
  template: (item) ->
    $('#fileuploadTemplate').tmpl item
    
  constructor: ->
    super
    @bind("change", @change)
#    Album.bind('change', @proxy @change)
    Spine.bind('change:selectedAlbum', @proxy @change)
    
  change: (item) ->
    @render()
    
  render: ->
    console.log 'UploadView::render'
    selection = Gallery.selectionList()
    gallery = Gallery.record
    album = Album.record
    @html @template
      gallery: gallery
      album: album
    @initFileupload()
    @refreshElements()
    @el
    
  add: (e, data) ->
    console.log 'UploadView::add'
    
  done: (e, data) ->
    console.log 'UploadView::done'
    photos = $.parseJSON(data.jqXHR.responseText)
    Photo.refresh(photos, clear: false)
    
  submit: (e, data) ->
    console.log 'UploadView::submit'
    
  initFileupload: ->
    console.log 'UploadEditView::initFileupload'
    @uploadEl.fileupload()
#    $.getJSON $('form', @uploadEl).prop('action'), (files) ->
#      fu = @uploadEl.data('fileupload')
#      fu._adjustMaxNumberOfFiles(-files.length)
#      template = fu._renderDownload(files)
#        .appendTo @filesEl
#      #Force reflow:
#      fu._reflow = fu._transition && template.length && template[0].offsetWidth;
#      template.addClass('in');
    
  fileuploadsend: (e, data) ->
    # Enable iframe cross-domain access via redirect page:
    redirectPage = window.location.href.replace /\/[^\/]*$/, '/result.html?%s'
    
    if (data.dataType.substr(0, 6) is 'iframe')
      target = $('<a/>').prop('href', data.url)[0]
      unless window.location.host is target.host
        data.formData.push
          name: 'redirect'
          value: redirectPage
    
  changeSelected: (e) ->
    el = $(e.currentTarget)
    id = el.val()
    album = Album.find(id)
    album.updateSelection [album.id]
    Spine.trigger('album:activate')
    
  click: (e) ->
#    console.log 'click'
    
    e.stopPropagation()
    e.preventDefault()
    false
    
module?.exports = UploadEditView