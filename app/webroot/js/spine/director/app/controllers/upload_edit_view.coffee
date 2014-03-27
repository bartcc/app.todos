Spine = require("spine")
Album = require("models/album")
$      = Spine.$

class UploadEditView extends Spine.Controller

  elements:
    '.delete:not(.files .delete)' : 'clearEl'
    '.files'                      : 'filesEl'
    '.uploadinfo'                 : 'uploadinfoEl'

  events:
    'fileuploaddone'              : 'done'
    'fileuploadsubmit'            : 'submit'
    'fileuploadfail'              : 'fail'
    'fileuploaddrop'              : 'drop'
    'fileuploadadd'               : 'add'
    'fileuploadpaste'             : 'paste'
    'fileuploadsend'              : 'send'
    'fileuploadprogressall'       : 'alldone'
    'fileuploadprogress'          : 'progress'
    'fileuploaddestroyed'         : 'destroyed'
    
  template: (item) ->
    $('#template-upload').tmpl item
    
  constructor: ->
    super
    Spine.bind('change:selectedAlbum', @proxy @changedSelected)
    @data = fileslist: []
    @queue = []
    
  change: (item) ->
    @render()
    
  render: ->
    console.log 'UploadView::render'
    selection = Gallery.selectionList()
    gallery = Gallery.record
#    @album = Album.record
    @album = (Album.find(selection[0]) if Album.exists(selection[0])) || false
    @uploadinfoEl.html @template
      gallery: gallery
      album: @album
    @refreshElements()
    @el
    
  destroyed: ->
    
  fail: (e, data) ->
      
  drop: (e, data) ->

  add: (e, data) ->
    @data.fileslist.push data.files for file in data.files
    @data.link = Album.record.id
    @c = App.hmanager.hasActive()
    App.hmanager.change @
    unless App.showView.isQuickUpload()
      App.showView.openPanel('upload')
        
  notify: ->
    App.modal2ButtonView.show
      header: 'No Album selected'
      body: 'Please select an album .'
      info: ''
      button_1_text: 'Hallo'
      button_2_text: 'Bye'
        
  send: (e, data) ->
    album = Album.exists(@data.link)
    Spine.trigger('loading:start', album) if album
    
  alldone: (e, data) ->
    
  done: (e, data) ->
    album = Album.exists(@data.link)
    raws = $.parseJSON(data.jqXHR.responseText)
    photos = []
    photos.push new Photo(raw['Photo']).save(ajax: false) for raw in raws
    if album
      for photo in photos
#        photo = new Photo(raw['Photo'])
        photo.addToSelection()
#        photo.save(ajax: false)

#        photo = Photo.exists(raw['Photo'].id)
#        if photo
        Photo.trigger('create:join', photo.id, album)

      Spine.trigger('loading:done', album)
#      Spine.trigger('done:upload', album)
    else
      Photo.trigger('created', photos)
#        Photo.trigger('created', photo)
      @navigate '/gallery//'
      
    if data.autoUpload
      @clearEl.click()
      
    e.preventDefault()
    
  progress: (e, data) ->
    
  paste: (e, data) ->
    @drop(e, data)
    
  submit: (e, data) ->
    
  changedSelected: (album, changed) ->
    album = Album.exists(album.id)
    if @data.fileslist.length
      $.extend @data, link: Album.record?.id
        
module?.exports = UploadEditView