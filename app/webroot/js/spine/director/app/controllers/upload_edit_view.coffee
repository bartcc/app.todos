Spine = require("spine")
Album = require("models/album")
$      = Spine.$

class UploadEditView extends Spine.Controller

  elements:
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
    
  template: (item) ->
    $('#template-upload').tmpl item
    
  constructor: ->
    super
    Spine.bind('change:selectedAlbum', @proxy @changedSelected)
    @fileslist = []
    @data = fileslist: @fileslist
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
    
  fail: (e, data) ->
      
  drop: (e, data) ->
    list = Gallery.selectionList()
    # dont allow uploads without an album selected
#    unless list.length
#      data.files[0...data.files.length] = []
#      @notify()

  add: (e, data) ->
    @fileslist.push data for file in data.files
    @data.link = Album.record.id
    console.log data
    @c = App.hmanager.hasActive()
    App.hmanager.change @
    unless App.showView.isQuickUpload()
      App.showView.openPanel('upload')
        
  notify: ->
    App.modal2ButtonView.show
      header: 'No Album selected'
      body: 'Please select an album .'
      info: ''
        
  send: (e, data) ->
    album = Album.exists(@data.link)
    Spine.trigger('loading:start', album) if album
    
  alldone: (e, data) ->
    @fileslist = []
    
  done: (e, data) ->
    album = Album.exists(@data.link)
    raws = $.parseJSON(data.jqXHR.responseText)
    for raw in raws
      photo = new Photo(raw['Photo'])
      photo.addToSelection()
      photo.save(ajax: false)
    
      if album
        photo = Photo.exists(raw['Photo'].id)
        Photo.trigger('create:join', photo, album) if photo
        Spine.trigger('loading:done', album)
        Spine.trigger('album:updateBuffer', album)
      else
        Photo.trigger('created', photo)
        @navigate '/gallery//'
      
    e.preventDefault()
    
  progress: (e, data) ->
    
  paste: (e, data) ->
    
  submit: (e, data) ->
    
  changedSelected: (album, changed) ->
    album = Album.exists(album.id)
    if @fileslist.length
      $.extend @data, link: Album.record?.id
        
module?.exports = UploadEditView