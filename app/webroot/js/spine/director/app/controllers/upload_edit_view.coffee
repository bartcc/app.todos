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
    @data = fileslist: []
    @queue = []
    
  change: (item) ->
    @render()
    
  activated: ->
    
  render: ->
    selection = Gallery.selectionList()
    gallery = Gallery.record
    @album = Album.exists(selection[0]) || false
    @uploadinfoEl.html @template
      gallery: gallery
      album: @album
    @refreshElements()
    @el
    
  destroyed: ->
    
  fail: (xhr, textStatus, errorThrown) ->
    album = Album.exists(@data.link)
    Spine.trigger('loading:fail', album, textStatus, errorThrown)
      
  drop: (e, data) ->

  add: (e, data) ->
    @data.fileslist.push file for file in data.files
    @data.link = Album.record.id
    @c = App.hmanager.hasActive()
    @trigger('active')
        
  notify: ->
    App.modal2ButtonView.show
      header: 'No Album selected'
      body: 'Please select an album .'
      info: ''
      button_1_text: 'Hallo'
      button_2_text: 'Bye'
        
  send: (e, data) ->
    album = Album.exists(@data.link)
    Spine.trigger('loading:start', album)
    
  alldone: (e, data) ->
    
  done: (e, data) ->
    album = Album.exists(@data.link)
    raws = $.parseJSON(data.jqXHR.responseText)
    console.log raws
    console.log album
    selection = []
    photos = []
    photos.push new Photo(raw['Photo']).save(ajax: false) for raw in raws
    if album
      for photo in photos
        selection.addRemoveSelection()
        
      options = $().extend {},
        photos: photos.toID()
        album: album
      Album.updateSelection(selection)
      Photo.trigger('create:join', options)
      Spine.trigger('loading:done', album)
    else
      Photo.trigger('created', photos)
      @navigate '/gallery//'
      
    if data.autoUpload
      @clearEl.click()
      
    e.preventDefault()
    
  progress: (e, data) ->
    
  paste: (e, data) ->
    console.log 'paste'
    @drop(e, data)
    
  submit: (e, data) ->
    
  changedSelected: (album) ->
    album = Album.exists(album.id)
    if @data.fileslist.length
      $.extend @data, link: Album.record?.id
        
module?.exports = UploadEditView