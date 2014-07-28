Spine           = require("spine")
$               = Spine.$
KeyEnhancer     = require("plugins/key_enhancer")
Extender        = require('plugins/controller_extender')
GalleriesAlbum  = require('models/galleries_album')

class AlbumEditView extends Spine.Controller
  
  @extend Extender
  
  events:
    'keyup'         : 'saveOnKeyup'
  
  template: (item) ->
    $('#editAlbumTemplate').tmpl item

  constructor: ->
    super
    @bind('active', @proxy @active)
    Gallery.bind('change:selection', @proxy @change)

  active: ->
    @render()
  
  change: (parent, selection) ->
    @current = Album.find(selection.first())
    @render() 
  
  render: () ->
    if @current #and !item.destroyed 
      @html @template @current
    else
      @html $("#noSelectionTemplate").tmpl({type: '<label class="invite"><span class="enlightened">Select or create an album</span></label>'})
    @el

  save: (el) ->
    @log 'save'
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

module?.exports = AlbumEditView