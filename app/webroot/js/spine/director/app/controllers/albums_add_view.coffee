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
    'click .item'                   : 'click'
    'click .opt-AddExecute'    : 'add'

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
    @modal.bind('shown.bs.modal', @proxy @setStatus)
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
      when 'shown'
        @preservedList = Gallery.selectionList()
      when 'hide'
        Gallery.updateSelection @preservedList
    
  click: (e) ->
    e.stopPropagation()
    e.preventDefault()
    
    item = $(e.currentTarget).item()
    @select(item, @isCtrlClick(e))
    
  select: (items = [], exclusive) ->
    unless Spine.isArray items
      items = [items]
      
    for item in items
      list = item.addRemoveSelection()
        
    @list.exposeSelection()
    
  add: ->
    Spine.trigger('albums:copy', Gallery.selectionList().slice(0), Gallery.record)
    @hide()
    
module.exports = AlbumsAddView