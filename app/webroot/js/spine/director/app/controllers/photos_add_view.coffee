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
    'click .opt-SelectInv:not(.disabled)'       : 'selectInv'
    'click .opt-SelectAll:not(.disabled)'       : 'selectAll'
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
      
    @selectionList = [] if exclusive
    
    for item in items
      @selectionList.addRemoveSelection(item)
        
    @renderFooter @selectionList
    @list.exposeSelection(Album.record, @selectionList)
    
  selectAll: (e) ->
    list = @select_()
    @select(list, true)
    e.stopPropagation()
    
  selectInv: (e) ->
    list = @select_()
    @select(list)
    e.stopPropagation()
    
  select_: ->
    root = @itemsEl
    items = root.children('.item')
    return unless root and items.length
    list = []
    items.each (index, el) ->
      item = $(@).item()
      list.unshift item.id
    list
    
  add: ->
    Spine.trigger('photos:copy', @selectionList, Album.record)
    @hide()
    
  keyup: (e) ->
    code = e.charCode or e.keyCode
    
    @log 'PhotosAddView:keyupCode: ' + code
    
    switch code
      when 65 #CTRL A
        if e.metaKey or e.ctrlKey
          @selectAll(e)
          e.stopPropagation()
          e.preventDefault()
      when 73 #CTRL I
        if e.metaKey or e.ctrlKey
          @selectInv(e)
          e.preventDefault()
          e.stopPropagation()
    
module.exports = PhotosAddView