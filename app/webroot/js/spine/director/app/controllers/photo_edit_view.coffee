Spine       = require("spine")
$           = Spine.$
KeyEnhancer = require("plugins/key_enhancer")
Extender    = require('plugins/controller_extender')
AlbumsPhoto = require('models/albums_photo')

class PhotoEditView extends Spine.Controller

  @extend Extender
  
  events:
    'click'           : 'click'
    'keyup'           : 'saveOnKeyup'
    
  template: (item) ->
    $('#editPhotoTemplate').tmpl(item)
  
  constructor: ->
    super
    @bind('active', @proxy @active)
    Album.bind('change:selection', @proxy @change)
  
  active: ->
    @render()
  
  change: (parent, selection) ->
    @current = Photo.find(selection.first())
    @render()
  
  render: () ->
    if @current #and !item.destroyed 
      @html @template @current
    else
      info = ''
      info += '<label class="invite"><span class="enlightened">No photo selected.</span></label>' unless Album.selectionList().length and !Album.count()
      info += '<label class="invite"><span class="enlightened">You should create an album first to catalogue your photos.</span></label>' unless Album.count()
      @html $("#noSelectionTemplate").tmpl({type: info})
    @el
  
  save: (el) ->
    if @current
      atts = el.serializeForm?() or @el.serializeForm()
      @current.updateChangedAttributes(atts)
 
  saveOnKeyup: (e) =>
    code = e.charCode or e.keyCode
    
    switch code
      when 32 # SPACE
        e.stopPropagation() 
      when 9 # TAB
        e.stopPropagation()
    
    @save @el
    
  click: (e) ->

module?.exports = PhotoEditView