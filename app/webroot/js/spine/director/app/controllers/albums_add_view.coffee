Spine = require('spine')
$               = Spine.$
Controller      = Spine.Controller
Drag            = require("plugins/drag")
User            = require("models/user")
Album           = require('models/album')
Gallery         = require('models/gallery')
GalleriesAlbum  = require('models/galleries_album')
AlbumsPhoto     = require('models/albums_photo')
Info            = require('controllers/info')
AlbumsList      = require('controllers/albums_list')
User            = require('models/user')
Extender        = require("plugins/controller_extender")

require("plugins/tmpl")

class AlbumsAddView extends Spine.Controller

  @extend Extender

  elements:
    '.items'        : '_items'

  events:
    'click .item'             : 'click'
    'click .opt-AddExecute'   : 'add'
    'click .opt-Selection'    : 'revertSelection'

  template: (items) ->
    $('#addTemplate').tmpl
      title: 'Select Albums'
      type: 'albums'
    
  subTemplate: (items, options) ->
    $("#albumsTemplate").tmpl items, options
    
  constructor: ->
    super
    @visible = false
    @modal = @el.modal
      show: @visible
      backdrop: true
    @modal.bind('show.bs.modal', @proxy @setStatus)
    @modal.bind('hide.bs.modal', @proxy @setStatus)
    
    @list = new AlbumsList
      template: @subTemplate
      
    Spine.bind('albums:add', @proxy @show)
      
  render: (items) ->
    @html @template items
    @items = $('.items', @el)
    @list.el = @items
    @list.render items, 'add'
  
  show: ->
    @el.modal('show')
    list = GalleriesAlbum.albums(Gallery.record.id).toID()
    records = Album.filter list, func: 'idExcludeSelect'
    @render records
    
  hide: ->
    @el.modal('hide')
  
  setStatus: (e) ->
    type = e.type
    switch type
      when 'show'
        @preservedList = Gallery.selectionList().slice(0)
        @selectionList = []
      when 'hide'
        Album.trigger('activate', @selectionList)
    
  click: (e) ->
    e.stopPropagation()
    e.preventDefault()
    
    item = $(e.currentTarget).item()
    @select(item.id, @isCtrlClick(e))
    
  select: (items = [], exclusive) ->
    unless Spine.isArray items
      items = [items]
      
    for item in items
      list = @selectionList.addRemoveSelection(item)
      
    @list.exposeSelection(list)
    
  selectAll: ->
    root = @items
    return unless root and root.children('.item').length
    list = []
    root.children('.item').each (index, el) ->
      item = $(@).item()
      list.unshift item.id
    @select(list)
    
  revertSelection: (e)->
    @selectAll()
    e.stopPropagation()
    e.preventDefault()
    
  add: ->
    Spine.trigger('albums:copy', @selectionList, Gallery.record)
    @hide()
    
  keyup: (e) ->
    code = e.charCode or e.keyCode
    
    console.log 'PhotosAddView:keyupCode: ' + code
    
    switch code
      when 65 #CTRL A
        if e.metaKey or e.ctrlKey
          @selectAll()
          e.stopPropagation()
          e.preventDefault()
    
module.exports = AlbumsAddView