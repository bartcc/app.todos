Spine ?= require("spine")
$      = Spine.$

class Toolbar extends Spine.Controller
  
  constructor: ->
    @list = new Array
    @list.push [
      new Spine.ToolbarItem
        name: 'Edit Gallery'
        klass: 'optEditGallery'
        disabled: -> !Gallery.record
    ,
      new Spine.ToolbarItem 
        name: 'New Gallery'
        klass: 'optCreateGallery'
    ,
      new Spine.ToolbarItem
        name: 'Delete Gallery'
        klass: 'optDestroyGallery'
        disabled: -> !Gallery.record
    ]
    @list.push [
      new Spine.ToolbarItem
        name: 'Save and Close'
        klass: 'optSave default'
        disabled: -> !Gallery.record
    ,
      new Spine.ToolbarItem
        name: 'Delete Gallery'
        klass: 'optDestroy'
        disabled: -> !Gallery.record
    ]
    @list.push [
      new Spine.ToolbarItem
        name: 'New Album'
        klass: 'optCreateAlbum'
    ,
      new Spine.ToolbarItem
        name: 'Delete Album'
        klass: 'optDestroyAlbum '
        disabled: -> !Gallery.selectionList().length
    ]
    @list.push [
      new Spine.ToolbarItem
        name: 'Delete Image'
        klass: 'optDestroyPhoto '
        disabled: -> !Album.selectionList().length
    ,
      new Spine.ToolbarItem
        name: '<div class="optThumbsize" style="width: 150px;"><span id="slider" style=""></span></div>'
    ]
    @list.push [
      new Spine.ToolbarItem
        name: 'Delete Image'
        klass: 'optDestroyPhoto '
        disabled: -> !Album.selectionList().length
      ,
      new Spine.ToolbarItem
        name: 'Show Upload'
        klass: ''
    ]
    @list.push [
      new Spine.ToolbarItem
        name: 'Play'
        klass: ''
    ]
#    list[item]
        
    lockToolbar: ->
      @locked = true

    unlockToolbar: ->
      @locked = false

    selectTool: (name) ->
      console.log 'Toolbars::selectTool'
      return @currentToolbar = @toolBarList(name) unless @locked
      return

    change: (name) ->
      console.log 'Toolbar::cjange'
      console.log name
      return
      toolbar = @selectTool name
      console.log toolbar
      @trigger('render:toolbar', toolbar) if toolbar
