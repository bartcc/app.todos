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
    'click .item'                            : 'click'
    'click .opt-AddExecute:not(.disabled)'   : 'add'
    'click .opt-SelectInv:not(.disabled)'    : 'selectInv'
    'keyup'                                  : 'keyup'
    
  template: (items) ->
    $('#addTemplate').tmpl
      title: 'Add photos to your album'
      type: 'photos'
      disabled: true
      contains: !!@items.length
      container: Album.record
      
  subTemplate: (items, options) ->
    $("#photosTemplate").tmpl items, options
    
  footerTemplate: (selection) ->
    $('#footerTemplate').tmpl
      disabled: !selection.length
      contains: !!@items.length
    
  constructor: ->
    super
    @thumbSize = 100
    @visible = false
    @modal = @el.modal
      show: @visible
      backdrop: true
    @modal.bind('show.bs.modal', @proxy @modalShow)
    @modal.bind('shown.bs.modal', @proxy @modalShown)
    @modal.bind('hide.bs.modal', @proxy @modalHide)
    
    @list = new PhotosList
      template: @subTemplate
      parent: @parent
      
    Spine.bind('photos:add', @proxy @show)
      
  render: (items) ->
    @html @template @items = items
    @itemsEl = $('.items', @el)
    @list.el = @itemsEl
    @list.render items, 'add'
  
  renderFooter: (list) ->
    @footer = $('.modal-footer', @el)
    @footer.html @footerTemplate list
    
  show: ->
    album = Album.record
    list = AlbumsPhoto.photos(album.id).toID()
    records = Photo.filter list, func: 'idExcludeSelect'
    @render records, album
    @el.modal('show')
    
  hide: ->
    @el.modal('hide')
  
  modalShow: (e) ->
    Spine.trigger('slider:change', @thumbSize)
    @preservedList = Album.selectionList().slice(0)
    @selectionList = []
  
  modalShown: (e) ->
  
  modalHide: (e) ->
    Spine.trigger('slider:change', App.showView.sOutValue)
    
  click: (e) ->
    e.stopPropagation()
    e.preventDefault()
    
    item = $(e.currentTarget).item()
    @select(item.id, @isCtrlClick(e))
    
  select: (items = [], exclusive) ->
    unless Spine.isArray items
      items = [items]
      
    list = []
    for item in items
      list = @selectionList.addRemoveSelection(item)
        
    @renderFooter list
    @list.exposeSelection(list)
    
  selectAll: ->
    root = @itemsEl
    return unless root and root.children('.item').length
    list = []
    root.children('.item').each (index, el) ->
      item = $(@).item()
      list.unshift item.id
    @select(list)
    
  selectInv: (e)->
    @selectAll()
    e.stopPropagation()
    e.preventDefault()
    
  add: ->
    Spine.trigger('photos:copy', @selectionList, Album.record)
    if @selectionList.length
      Photo.trigger('activate', @selectionList)
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
    
module.exports = PhotosAddView