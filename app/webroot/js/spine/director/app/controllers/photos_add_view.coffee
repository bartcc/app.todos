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
PhotosList      = require('controllers/photos_list')
User            = require('models/user')
Extender        = require("plugins/controller_extender")

require("plugins/tmpl")

class PhotosAddView extends Spine.Controller

  @extend Extender

  elements:
    '.items'        : '_items'

  events:
    'click .item'             : 'click'
    'click .opt-AddExecute'   : 'add'

  template: (items) ->
    $('#addTemplate').tmpl
      title: 'Select Photos'
      type: 'photos'
      
  subTemplate: (items, options) ->
    $("#photosTemplate").tmpl items, options
    
  constructor: ->
    super
    @visible = false
    @modal = @el.modal
      show: @visible
      backdrop: true
    @modal.bind('shown.bs.modal', @proxy @setStatus)
    @modal.bind('hide.bs.modal', @proxy @setStatus)
    
    @list = new PhotosList
      template: @subTemplate
      
    Spine.bind('photos:add', @proxy @show)
      
  render: (items) ->
    @html @template items
    @items = $('.items', @el)
    @list.el = @items
    @list.render items, 'add'
  
  show: ->
    @el.modal('show')
    list = AlbumsPhoto.photos(Album.record.id).toID()
    records = Photo.filter list, func: 'idExcludeSelect'
    @render records
    
  hide: ->
    @el.modal('hide')
  
  setStatus: (e) ->
    type = e.type
    switch type
      when 'shown'
        @preservedList = Album.selectionList()
      when 'hide'
        Album.updateSelection @preservedList
    
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
    Spine.trigger('photos:copy', Album.selectionList().slice(0), Album.record)
    @hide()
    
module.exports = PhotosAddView